package dental;

import org.jpl7.*;
import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.util.List;

/** A schema-driven field. Only knowledge-workspace search and save filenames accept text. */
public final class AnswerControl extends JPanel {
    final Bridge.Question question;
    final JComboBox<Bridge.Option> combo;
    final Map<String,AbstractButton> buttons=new LinkedHashMap<>();
    private boolean changing;
    private final Runnable changed;
    public AnswerControl(Bridge.Question q,Runnable changed) {
        question=q;this.changed=changed;
        setOpaque(false);setLayout(new BorderLayout(0,7));
        JLabel label=new JLabel(q.label());label.setFont(App.BODY.deriveFont(Font.BOLD));
        label.setForeground(App.NAVY);add(label,BorderLayout.NORTH);
        label.setToolTipText(q.key());getAccessibleContext().setAccessibleName(q.label());
        if(q.type().equals("select")){
            combo=new JComboBox<>(q.options().toArray(Bridge.Option[]::new));combo.setEditable(false);
            combo.setMaximumRowCount(14);combo.setPreferredSize(new Dimension(300,34));
            label.setLabelFor(combo);combo.getAccessibleContext().setAccessibleName(q.label());
            combo.addActionListener(e->notifyChange());add(combo,BorderLayout.CENTER);
        }else{
            combo=null;JPanel choices=new JPanel(new GridLayout(0,2,16,4));choices.setOpaque(false);
            ButtonGroup group=new ButtonGroup();
            for(Bridge.Option option:q.options()){
                AbstractButton button=q.type().equals("radio")?new JRadioButton(option.label()):new JCheckBox(option.label());
                button.setOpaque(false);button.setFont(App.BODY);button.setBorder(BorderFactory.createEmptyBorder(4,0,4,14));
                button.getAccessibleContext().setAccessibleName(q.label()+": "+option.label());
                buttons.put(option.value().name(),button);choices.add(button);
                if(q.type().equals("radio"))group.add(button);
                button.addActionListener(e->{
                    if(changing)return;
                    if(q.type().equals("multi")){
                        changing=true;
                        String key=option.value().name();
                        if(button.isSelected()){
                            for(var other:buttons.entrySet())if(!other.getKey().equals(key)&&(special(key)||special(other.getKey())))other.getValue().setSelected(false);
                        }
                        if(buttons.values().stream().noneMatch(AbstractButton::isSelected))buttons.get("unknown").setSelected(true);
                        changing=false;
                    }
                    notifyChange();
                });
            }
            add(choices,BorderLayout.CENTER);
        }
        reset();
    }
    static boolean special(String s){return Set.of("unknown","none","na").contains(s);}
    void notifyChange(){if(!changing)changed.run();}
    public Term value(){
        if(combo!=null)return ((Bridge.Option)combo.getSelectedItem()).value();
        List<String> chosen=buttons.entrySet().stream().filter(e->e.getValue().isSelected()).map(Map.Entry::getKey).toList();
        if(question.type().equals("radio")||chosen.size()==1&&special(chosen.getFirst()))return new Atom(chosen.isEmpty()?"unknown":chosen.getFirst());
        return Term.termArrayToList(chosen.stream().map(Atom::new).toArray(Term[]::new));
    }
    public void setValue(Term value){
        changing=true;
        if(combo!=null){for(int i=0;i<combo.getItemCount();i++)if(combo.getItemAt(i).value().equals(value)){combo.setSelectedIndex(i);break;}}
        else{
            Set<String> selected=new HashSet<>();
            if(value.isAtom())selected.add(value.name());else for(Term t:value.listToTermArray())selected.add(t.name());
            buttons.forEach((k,b)->b.setSelected(selected.contains(k)));
        }
        changing=false;
    }
    public void reset(){setValue(new Atom("unknown"));}
    public String displayed(){
        if(combo!=null)return combo.getSelectedItem().toString();
        return String.join(", ",buttons.values().stream().filter(AbstractButton::isSelected).map(AbstractButton::getText).toList());
    }
}
