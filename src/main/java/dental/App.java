package dental;

import org.jpl7.*;
import javax.swing.*;
import javax.swing.border.*;
import javax.swing.event.*;
import javax.swing.table.*;
import javax.swing.plaf.FontUIResource;
import java.awt.*;
import java.awt.geom.*;
import java.awt.image.BufferedImage;
import java.nio.file.*;
import java.time.*;
import java.util.*;
import java.util.List;
import java.util.concurrent.*;

public final class App extends JFrame {
    static final Color NAVY=new Color(24,48,77), BLUE=new Color(234,242,248), TEAL=new Color(20,112,117), GRAY=new Color(79,96,112);
    static final Font BODY=loadInterfaceFont(), DISPLAY=BODY.deriveFont(Font.BOLD,32f);

    private static Font loadInterfaceFont(){
        try{
            for(String style:List.of("Regular","Bold")){
                try(var stream=App.class.getResourceAsStream("/fonts/Inter-"+style+".otf")){
                    if(stream==null)throw new IllegalStateException("Bundled Inter font missing: "+style);
                    GraphicsEnvironment.getLocalGraphicsEnvironment().registerFont(Font.createFont(Font.TRUETYPE_FONT,stream));
                }
            }
            return new Font("Inter",Font.PLAIN,14);
        }catch(Exception e){throw new ExceptionInInitializerError(e);}
    }
    private Bridge bridge;
    final Map<String,AnswerControl> fields=new LinkedHashMap<>();
    private final JPanel screens=new JPanel(new CardLayout());
    final JComboBox<String> mode=new JComboBox<>(new String[]{"Forward chaining","Backward chaining"});
    final JComboBox<Bridge.Option> goal=new JComboBox<>();
    private final JTextArea resultText=new JTextArea();
    private final JButton assessButton=button("Assess presentation",'A');
    private final JButton saveButton=button("Save result",'S');
    private final JPanel goalRow=new JPanel(new BorderLayout(8,8));
    private final ExecutorService worker=Executors.newSingleThreadExecutor(r->{Thread t=new Thread(r,"dental-inference");t.setDaemon(true);return t;});
    long generation;
    private String savedResult;
    private final JLabel resultTitle=new JLabel("Assessment");
    private JPanel questionnaire;

    public static void main(String[] args){
        if(Arrays.asList(args).contains("--verify-runtime")){
            try {Bridge b=new Bridge();System.out.println("Bundled runtime: Java "+System.getProperty("java.version")+"; SWI/JPL ready; KB "+b.version+"; "+b.questions.size()+" questions");}
            catch(Throwable e){e.printStackTrace();System.exit(1);}return;
        }
        SwingUtilities.invokeLater(()->{
            try{UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());}catch(Exception ignored){}
            // Include inherited fonts used by search fields, table headers, menus and dialogs.
            for(Object key:new ArrayList<>(UIManager.getDefaults().keySet())){
                if(UIManager.get(key) instanceof Font)UIManager.put(key,new FontUIResource(BODY));
            }
            new App().setVisible(true);
        });
    }
    public App(){
        super("DentalExplain • Expert system");
        installEditingKeys();
        setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);setSize(1180,850);setMinimumSize(new Dimension(960,680));setLocationRelativeTo(null);
        setIconImage(icon(128));setLayout(new BorderLayout());
        screens.setBackground(Color.WHITE);add(screens,BorderLayout.CENTER);
        JPanel loading=page("Preparing your workspace", "Loading questions, facts and rules from SWI-Prolog.");screens.add(loading,"loading");
        worker.submit(()->{try{Bridge b=new Bridge();SwingUtilities.invokeLater(()->initialize(b));}catch(Throwable e){SwingUtilities.invokeLater(()->startupError(e));}});
    }
    private void startupError(Throwable e){
        e.printStackTrace();
        JTextArea error=textArea("Could not initialize the bundled Prolog runtime.\n\n"+e+"\n\nSee the troubleshooting section of the user manual.");
        JPanel panel=page("Runtime unavailable","The application needs matching Java, SWI-Prolog and JPL libraries.");panel.add(new JScrollPane(error),BorderLayout.CENTER);screens.add(panel,"error");show("error");
    }
    void initialize(Bridge b){
        bridge=b;
        for(Bridge.Question q:b.questions)fields.put(q.key(),new AnswerControl(q,this::refreshVisibility));
        for(var c:b.conditions.entrySet())goal.addItem(new Bridge.Option(new Atom(c.getKey()),c.getValue()));
        goal.setEditable(false);mode.setEditable(false);
        screens.add(welcome(),"welcome");screens.add(setup(),"setup");screens.add(questionnaire(),"questionnaire");screens.add(results(),"results");
        screens.add(knowledge(),"knowledge");refreshVisibility();show("welcome");
    }
    private JPanel welcome(){
        JPanel page=page("A structured dental assessment", "For dentists assessing tooth pain and gum symptoms across age groups.");
        JPanel body=new JPanel(new BorderLayout(35,25));body.setOpaque(false);
        JPanel content=new JPanel();content.setOpaque(false);content.setLayout(new BoxLayout(content,BoxLayout.Y_AXIS));
        content.add(note("Five supported conditions", "Dental caries · Reversible pulpitis · Symptomatic irreversible pulpitis · Gingivitis · Periodontitis"));
        content.add(Box.createVerticalStrut(20));content.add(note("Built around clinical findings", "Choose reported symptoms, relevant history and dentist-supplied examination findings. No patient identifiers are collected."));
        content.add(Box.createVerticalStrut(20));content.add(note("Provisional knowledge", "Candidate conditions require clinical judgement. Rules and synthetic test expectations await dentist review. Treatment prescribing is outside scope."));
        body.add(content,BorderLayout.CENTER);JLabel artwork=new JLabel(new ImageIcon(icon(210)));artwork.setBorder(new EmptyBorder(30,15,30,30));body.add(artwork,BorderLayout.EAST);page.add(body,BorderLayout.CENTER);
        JButton start=button("Start consultation",'S');start.addActionListener(e->{reset();show("setup");});
        JButton kb=button("View knowledge base",'K');kb.addActionListener(e->show("knowledge"));page.add(actions(kb,start),BorderLayout.SOUTH);return page;
    }
    private JPanel setup(){
        JPanel p=page("01 / Consultation setup","Record age and the affected dentition. Choose how the engine will reason.");
        JPanel grid=new JPanel(new GridLayout(0,2,28,22));grid.setOpaque(false);
        fields.values().stream().filter(f->f.question.section().equals("setup")).forEach(grid::add);
        JPanel reasoning=new JPanel(new BorderLayout(8,8));reasoning.setOpaque(false);reasoning.add(new JLabel("Reasoning mode"),BorderLayout.NORTH);reasoning.add(mode,BorderLayout.CENTER);grid.add(reasoning);
        goalRow.setOpaque(false);goalRow.add(new JLabel("Candidate to investigate"),BorderLayout.NORTH);goalRow.add(goal,BorderLayout.CENTER);grid.add(goalRow);
        mode.addActionListener(e->{goalRow.setVisible(mode.getSelectedIndex()==1);invalidateAssessment();});
        JPanel holder=new JPanel(new BorderLayout());holder.setOpaque(false);holder.add(grid,BorderLayout.NORTH);p.add(new JScrollPane(holder),BorderLayout.CENTER);
        JButton back=button("Welcome",'W');back.addActionListener(e->show("welcome"));JButton next=button("Continue to questionnaire",'C');next.addActionListener(e->{refreshVisibility();show("questionnaire");});p.add(actions(back,next),BorderLayout.SOUTH);return p;
    }
    private JPanel questionnaire(){
        JPanel p=page("02 / Clinical questionnaire","Unknown means not supplied. Not applicable means the finding cannot be used for this assessment.");
        questionnaire=new JPanel();questionnaire.setBackground(Color.WHITE);questionnaire.setLayout(new BoxLayout(questionnaire,BoxLayout.Y_AXIS));
        String[][] sections={{"symptoms","Reported symptoms"},{"history","Relevant history"},{"examination","Dentist-supplied tooth findings"},{"periodontal","Dentist-supplied periodontal findings"}};
        for(String[] section:sections){
            JPanel group=new JPanel();group.setOpaque(false);group.setLayout(new BoxLayout(group,BoxLayout.Y_AXIS));
            JLabel heading=new JLabel(section[1]);heading.setFont(BODY.deriveFont(Font.BOLD,18));heading.setForeground(NAVY);heading.setOpaque(true);heading.setBackground(BLUE);heading.setBorder(new EmptyBorder(12,14,12,14));heading.setMaximumSize(new Dimension(java.lang.Integer.MAX_VALUE,48));heading.setAlignmentX(Component.LEFT_ALIGNMENT);group.add(heading);
            for(AnswerControl f:fields.values())if(f.question.section().equals(section[0])){
                f.setBorder(new CompoundBorder(new MatteBorder(0,0,1,0,BLUE),new EmptyBorder(12,14,14,14)));
                f.setAlignmentX(Component.LEFT_ALIGNMENT);f.setMaximumSize(new Dimension(java.lang.Integer.MAX_VALUE,f.question.type().equals("multi")?150:90));group.add(f);
            }
            group.setAlignmentX(Component.LEFT_ALIGNMENT);questionnaire.add(group);questionnaire.add(Box.createVerticalStrut(16));
        }
        JScrollPane scroll=new JScrollPane(questionnaire);scroll.setBorder(BorderFactory.createLineBorder(BLUE));scroll.getVerticalScrollBar().setUnitIncrement(24);p.add(scroll,BorderLayout.CENTER);
        JButton back=button("Back to setup",'B');back.addActionListener(e->show("setup"));assessButton.addActionListener(e->assess());p.add(actions(back,assessButton),BorderLayout.SOUTH);return p;
    }
    private JPanel results(){
        JPanel p=page("03 / Assessment result","Candidate conditions can coexist. Results do not establish an autonomous diagnosis.");
        JPanel body=new JPanel(new BorderLayout(0,18));body.setOpaque(false);resultTitle.setForeground(TEAL);resultTitle.setFont(DISPLAY.deriveFont(25f));body.add(resultTitle,BorderLayout.NORTH);
        resultText.setEditable(false);resultText.setLineWrap(true);resultText.setWrapStyleWord(true);resultText.setFont(BODY.deriveFont(16f));resultText.setMargin(new Insets(18,18,18,18));resultText.setBackground(BLUE);body.add(new JScrollPane(resultText),BorderLayout.CENTER);p.add(body,BorderLayout.CENTER);
        JButton edit=button("Edit answers",'E');edit.addActionListener(e->show("questionnaire"));saveButton.addActionListener(e->save());JButton fresh=button("New consultation",'N');fresh.addActionListener(e->{reset();show("setup");});p.add(actions(edit,saveButton,fresh),BorderLayout.SOUTH);return p;
    }
    private JPanel knowledge(){
        JPanel p=page("Knowledge workspace","Read-only catalogue. Domain facts, production rules and consultation questions have separate counts.");
        JTabbedPane tabs=new JTabbedPane();
        Map<String,String> questionSources=new HashMap<>();
        for(Term t:bridge.catalog("question_sources"))questionSources.put(t.arg(1).name(),t.arg(2).name());
        for(String kind:List.of("questions","facts","rules")){
            String[] cols=kind.equals("questions")?new String[]{"ID","Section / type","Question / allowed mappings","Source / review"}:new String[]{"ID","Statement / premises","Conclusion / description","Source / review"};
            DefaultTableModel model=new DefaultTableModel(cols,0){public boolean isCellEditable(int r,int c){return false;}};
            for(Term t:bridge.catalog(kind)){
                if(kind.equals("questions"))model.addRow(new Object[]{t.arg(1).name(),t.arg(2).name()+" / "+t.arg(3).name(),t.arg(4).name()+" | "+t.arg(5),questionSources.get(t.arg(1).name())+" / Pending review"});
                else model.addRow(new Object[]{t.arg(1).name(),t.arg(2).toString(),kind.equals("facts")?t.arg(3).name():t.arg(3).toString(),t.arg(4).name()+" / "+t.arg(5).name()});
            }
            JTable table=new JTable(model);table.setRowHeight(32);table.setFont(BODY);table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
            int[] widths={65,310,450,520};for(int i=0;i<4;i++)table.getColumnModel().getColumn(i).setPreferredWidth(widths[i]);
            table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);TableRowSorter<DefaultTableModel> sorter=new TableRowSorter<>(model);table.setRowSorter(sorter);
            JTextField search=new JTextField();search.getAccessibleContext().setAccessibleName("Search "+kind);
            search.getDocument().addDocumentListener(new DocumentListener(){public void insertUpdate(DocumentEvent e){filter();}public void removeUpdate(DocumentEvent e){filter();}public void changedUpdate(DocumentEvent e){filter();}void filter(){String s=search.getText();sorter.setRowFilter(s.isEmpty()?null:RowFilter.regexFilter("(?i)"+java.util.regex.Pattern.quote(s)));}});
            JTextArea detail=textArea("Select a row to read its full content and source.");detail.setRows(5);detail.setBackground(BLUE);
            table.getSelectionModel().addListSelectionListener(e->{if(table.getSelectedRow()<0)return;int row=table.convertRowIndexToModel(table.getSelectedRow());StringBuilder s=new StringBuilder();for(int i=0;i<4;i++)s.append(cols[i]).append(": ").append(model.getValueAt(row,i)).append("\n\n");detail.setText(s.toString());detail.setCaretPosition(0);});
            JPanel pane=new JPanel(new BorderLayout(0,12));pane.setOpaque(false);JPanel bar=new JPanel(new BorderLayout(12,0));bar.setOpaque(false);bar.add(new JLabel("Search "+kind+" ("+model.getRowCount()+")"),BorderLayout.WEST);bar.add(search,BorderLayout.CENTER);pane.add(bar,BorderLayout.NORTH);pane.add(new JScrollPane(table),BorderLayout.CENTER);pane.add(new JScrollPane(detail),BorderLayout.SOUTH);
            tabs.addTab(Character.toUpperCase(kind.charAt(0))+kind.substring(1)+" ("+model.getRowCount()+")",pane);
        }
        p.add(tabs,BorderLayout.CENTER);JButton back=button("Welcome",'W');back.addActionListener(e->show("welcome"));p.add(actions(back),BorderLayout.SOUTH);return p;
    }
    boolean visible(Term v){
        if(v.isAtom())return v.name().equals("always");
        if(v.name().equals("when"))return fields.get(v.arg(1).name()).value().equals(v.arg(2));
        if(v.name().equals("all"))return Arrays.stream(v.arg(1).listToTermArray()).allMatch(this::visible);
        return false;
    }
    void refreshVisibility(){
        if(bridge==null)return;
        // Parents precede children in the shared catalogue, so hidden-dependent fields clear in order.
        for(AnswerControl f:fields.values()){
            boolean show=visible(f.question.visibility());
            if(!show)f.reset();f.setVisible(show);
        }
        goalRow.setVisible(mode.getSelectedIndex()==1);invalidateAssessment();
        if(questionnaire!=null){questionnaire.revalidate();questionnaire.repaint();}
    }
    Map<String,Term> answers(){
        Map<String,Term> a=new LinkedHashMap<>();fields.forEach((k,f)->{if(visible(f.question.visibility()))a.put(k,f.value());});return a;
    }
    void invalidateAssessment(){generation++;savedResult=null;saveButton.setEnabled(false);}
    void reset(){generation++;fields.values().forEach(AnswerControl::reset);mode.setSelectedIndex(0);if(goal.getItemCount()>0)goal.setSelectedIndex(0);resultText.setText("");savedResult=null;saveButton.setEnabled(false);assessButton.setEnabled(true);assessButton.setText("Assess presentation");refreshVisibility();if(questionnaire!=null)questionnaire.scrollRectToVisible(new Rectangle(0,0,1,1));}
    void assess(){
        Map<String,Term> input=answers();String method=mode.getSelectedIndex()==0?"forward":"backward";
        String target=method.equals("forward")?"all":((Bridge.Option)goal.getSelectedItem()).value().name();
        long ticket=++generation;assessButton.setEnabled(false);assessButton.setText("Assessing…");
        worker.submit(()->{try{Bridge.Result r=bridge.assess(input,method,target);SwingUtilities.invokeLater(()->{
            assessButton.setEnabled(true);assessButton.setText("Assess presentation");if(ticket!=generation){return;}
            present(r,input,method,target);show("results");
        });}catch(Throwable e){SwingUtilities.invokeLater(()->{assessButton.setEnabled(true);assessButton.setText("Assess presentation");if(ticket!=generation)return;JOptionPane.showMessageDialog(this,e.toString(),"Runtime error",JOptionPane.ERROR_MESSAGE);});}});
    }
    private void present(Bridge.Result r,Map<String,Term> input,String method,String target){
        String title=switch(r.status()){case "candidates"->"Supported candidate conditions";case "incomplete"->"Additional information needed";case "conflict"->"Clarify conflicting selections";case "invalid"->"Correct invalid inputs";case "outside_scope"->"Outside the supported scope";default->"No supported conclusion";};resultTitle.setText(title);
        StringBuilder out=new StringBuilder();for(String c:r.candidates())out.append("• ").append(bridge.conditions.get(c)).append("\n");
        if(!r.candidates().isEmpty())out.append("\n");for(String message:r.messages())out.append(message).append("\n\n");
        if(!r.missing().isEmpty()){out.append("Missing or unusable findings:\n");for(String k:r.missing())out.append("• ").append(fields.containsKey(k)?fields.get(k).question.label():k).append("\n");}
        if(r.candidates().contains("irreversible_pulpitis")&&input.getOrDefault("tooth_type",new Atom("unknown")).name().equals("primary"))out.append("\nPrimary-tooth findings can overlap with pulp necrosis; this candidate requires dentist review.\n");
        resultText.setText(out.toString());resultText.setCaretPosition(0);
        StringBuilder record=new StringBuilder("DentalExplain consultation\nSaved assessment: "+Instant.now()+"\nKnowledge version: "+bridge.version+"\nExpert review: pending\nMode: "+method+"\nGoal: "+target+"\n\nINPUTS\n");
        input.forEach((k,v)->record.append(k).append(" = ").append(v).append(" | ").append(fields.get(k).displayed()).append("\n"));record.append("\nSTATUS: ").append(r.status()).append("\n\n").append(out);savedResult=record.toString();saveButton.setEnabled(true);
    }
    private void save(){
        if(savedResult==null)return;
        FileDialog chooser=new FileDialog(this,"Save consultation result",FileDialog.SAVE);
        chooser.setFile("DentalExplain-result.txt");chooser.setVisible(true);
        String file=chooser.getFile(),directory=chooser.getDirectory();chooser.dispose();
        if(file==null)return;Path path=Path.of(directory,file);
        if(Files.exists(path)&&JOptionPane.showConfirmDialog(this,"Replace the existing result file?","Save result",JOptionPane.YES_NO_OPTION)!=JOptionPane.YES_OPTION)return;
        try{Files.writeString(path,savedResult);JOptionPane.showMessageDialog(this,"Saved result to "+path.getFileName(),"Result saved",JOptionPane.INFORMATION_MESSAGE);}catch(Exception e){JOptionPane.showMessageDialog(this,e.getMessage(),"Save failed",JOptionPane.ERROR_MESSAGE);}
    }
    String savedResultForTest(){return savedResult;}
    void show(String card){((CardLayout)screens.getLayout()).show(screens,card);}
    static void installEditingKeys(){
        if(!System.getProperty("os.name").startsWith("Mac"))return;
        for(String key:List.of("TextField.focusInputMap","TextArea.focusInputMap","FormattedTextField.focusInputMap","PasswordField.focusInputMap")){
            InputMap map=(InputMap)UIManager.get(key);if(map==null)continue;
            map.put(KeyStroke.getKeyStroke("meta A"),javax.swing.text.DefaultEditorKit.selectAllAction);
            map.put(KeyStroke.getKeyStroke("meta C"),javax.swing.text.DefaultEditorKit.copyAction);
            map.put(KeyStroke.getKeyStroke("meta V"),javax.swing.text.DefaultEditorKit.pasteAction);
            map.put(KeyStroke.getKeyStroke("meta X"),javax.swing.text.DefaultEditorKit.cutAction);
        }
    }
    static JButton button(String label,char mnemonic){JButton b=new JButton(label);b.setMnemonic(mnemonic);b.setForeground(Color.WHITE);b.setBackground(NAVY);b.setFocusPainted(true);b.setBorder(new EmptyBorder(11,20,11,20));return b;}
    static JPanel actions(JButton... buttons){JPanel p=new JPanel(new FlowLayout(FlowLayout.RIGHT,12,0));p.setOpaque(false);p.setBorder(new EmptyBorder(22,0,0,0));for(JButton b:buttons)p.add(b);return p;}
    static JPanel page(String title,String subtitle){JPanel p=new JPanel(new BorderLayout(0,24));p.setBackground(Color.WHITE);p.setBorder(new EmptyBorder(26,30,26,30));JPanel heading=new JPanel(new BorderLayout(0,10));heading.setOpaque(false);JLabel h=new JLabel(title);h.setFont(DISPLAY);h.setForeground(NAVY);heading.add(h,BorderLayout.NORTH);JLabel sub=new JLabel("<html>"+subtitle+"</html>");sub.setFont(BODY);sub.setForeground(GRAY);heading.add(sub,BorderLayout.CENTER);p.add(heading,BorderLayout.NORTH);return p;}
    static JTextArea textArea(String s){JTextArea t=new JTextArea(s);t.setEditable(false);t.setLineWrap(true);t.setWrapStyleWord(true);t.setMargin(new Insets(12,12,12,12));t.setFont(BODY);return t;}
    static JPanel note(String title,String description){JPanel p=new JPanel(new BorderLayout(0,10));p.setBackground(BLUE);p.setBorder(new EmptyBorder(20,22,20,22));JLabel h=new JLabel(title);h.setFont(BODY.deriveFont(Font.BOLD,18));h.setForeground(NAVY);p.add(h,BorderLayout.NORTH);JLabel d=new JLabel("<html>"+description+"</html>");d.setForeground(GRAY);p.add(d,BorderLayout.CENTER);p.setAlignmentX(Component.LEFT_ALIGNMENT);return p;}
    public static BufferedImage icon(int size){BufferedImage image=new BufferedImage(size,size,BufferedImage.TYPE_INT_ARGB);Graphics2D g=image.createGraphics();g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON);g.scale(size/256.0,size/256.0);g.setColor(BLUE);g.fillRoundRect(0,0,256,256,56,56);Path2D tooth=new Path2D.Double();tooth.moveTo(128,60);tooth.curveTo(66,24,43,69,64,117);tooth.curveTo(77,148,64,225,94,222);tooth.curveTo(115,220,107,157,128,156);tooth.curveTo(149,157,141,220,162,222);tooth.curveTo(192,225,179,148,192,117);tooth.curveTo(213,69,190,24,128,60);g.setColor(Color.WHITE);g.fill(tooth);g.setColor(NAVY);g.setStroke(new BasicStroke(8,BasicStroke.CAP_ROUND,BasicStroke.JOIN_ROUND));g.draw(tooth);g.setColor(TEAL);g.setStroke(new BasicStroke(6,BasicStroke.CAP_ROUND,BasicStroke.JOIN_ROUND));g.drawLine(101,102,121,119);g.drawLine(121,119,159,80);g.dispose();return image;}
}
