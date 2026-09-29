package dental;
import org.jpl7.*;
import javax.swing.*;
import java.util.*;
import java.util.concurrent.*;
import java.awt.image.BufferedImage;
import java.nio.file.*;
import javax.imageio.ImageIO;

public final class IntegrationTest {
    static JButton findButton(java.awt.Container root,String label){
        for(java.awt.Component c:root.getComponents()){
            if(c instanceof JButton button&&button.getText().equals(label))return button;
            if(c instanceof java.awt.Container child){JButton found=findButton(child,label);if(found!=null)return found;}
        }return null;
    }
    static void require(boolean b,String message){if(!b)throw new AssertionError(message);}
    static Map<String,Term> observations(Term list){Map<String,Term> map=new LinkedHashMap<>();for(Term o:list.listToTermArray())map.put(o.arg(1).name(),o.arg(2));return map;}
    static void query(Term goal){Query q=new Query(goal);try{require(q.hasSolution(),"Query failed: "+goal);}finally{q.close();}}
    static void render(App app,String screen,int width,int height){
        app.setSize(width,height);app.show(screen);app.setVisible(true);app.validate();
        BufferedImage image=new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);
        var graphics=image.createGraphics();app.getContentPane().printAll(graphics);graphics.dispose();
        try{Path path=Path.of("build/ui-screenshots/component-"+screen+"-"+width+"x"+height+".png");Files.createDirectories(path.getParent());ImageIO.write(image,"png",path.toFile());}
        catch(Exception e){throw new AssertionError("Layout capture",e);}
    }
    static void settled(App app)throws Exception{
        for(int i=0;i<200;i++){boolean[] done={false};SwingUtilities.invokeAndWait(()->done[0]=app.fields.size()==27&&!app.routingPending);if(done[0])return;Thread.sleep(25);}
        throw new AssertionError("Routing did not settle");
    }
    static void set(App app,String key,String value){app.fields.get(key).setValue(new Atom(value));}
    public static void main
(String[] args)throws Exception{
        UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
        for(Object key:new ArrayList<>(UIManager.getDefaults().keySet()))if(UIManager.get(key) instanceof java.awt.Font)UIManager.put(key,new javax.swing.plaf.FontUIResource(App.BODY));
require(RuntimeLayout.platform("Windows 11","amd64").equals("windows-x64"),"Windows layout");
require(RuntimeLayout.platform("Linux","x86_64").equals("linux-x64"),"Linux layout");
require(RuntimeLayout.platform("Mac OS X","aarch64").equals("macos-arm64"),"Mac layout");
try{RuntimeLayout.platform("Linux","aarch64");throw new AssertionError("Unsupported architecture accepted");}catch(IllegalStateException expected){}
try{RuntimeLayout.find(Path.of("build"),"missing-dental-library");throw new AssertionError("Missing dependency accepted");}catch(IllegalStateException expected){}
Bridge b=new Bridge();query(new Compound("consult",new Term[]{new Atom(b.root.resolve("knowledge/acceptance.pl").toString())}));
        Term all=new Compound(":",new Term[]{new Atom("dental_acceptance"),new Compound("case",new Term[]{new Variable("ID"),new Variable("O"),new Variable("Status"),new Variable("Target")})});
        Map<String,Term>[] cases;Query fixtureQuery=new Query(all);try{cases=fixtureQuery.allSolutions();}finally{fixtureQuery.close();}
        require(cases.length==20,"Exactly 20 acceptance fixtures");int assessments=0;
        for(var c:cases){String id=c.get("ID").name(),expected=c.get("Status").name(),target=c.get("Target").name();Map<String,Term> input=observations(c.get("O"));Bridge.Result f=b.assess(input);require(f.status().equals(expected),id+" status "+f);assessments++;
            if(!target.equals("none"))require(f.candidates().contains(target),id+" target missing");
            else require(f.candidates().isEmpty(),id+" prohibited conclusion");
            query(new Compound(":",new Term[]{new Atom("dental_acceptance"),new Compound("verify",new Term[]{new Atom(expected),new Atom(target),new Compound("result",new Term[]{new Atom(f.status()),Term.termArrayToList(f.candidates().stream().map(Atom::new).toArray(Term[]::new)),Term.termArrayToList(f.missing().stream().map(Atom::new).toArray(Term[]::new)),Term.termArrayToList(f.messages().stream().map(Atom::new).toArray(Term[]::new))})})}));
            if(!target.equals("none")){
                Set<String> active=new LinkedHashSet<>();for(String stage:List.of("setup","symptoms","findings"))active.addAll(b.activeQuestions(input,stage));
                Map<String,Term> routed=new LinkedHashMap<>();input.forEach((key,value)->{if(active.contains(key))routed.put(key,value);});
                Bridge.Result r=b.assess(routed);require(r.status().equals(expected)&&r.candidates().contains(target),id+" adaptive route changed expected target");
            }
            System.out.println("JPL "+id+": PASS");

        }
        require(b.version.equals("0.4.0"),"Knowledge version");
        require(b.questions.size()==27,"30 questions");
        require(b.questions.stream().noneMatch(q->Set.of("age","focus").contains(q.key())),"Removed clinical identifiers");
        SwingUtilities.invokeAndWait(()->{
            Map<String,AnswerControl> controls=new LinkedHashMap<>();for(Bridge.Question q:b.questions)controls.put(q.key(),new AnswerControl(q,()->{}));
            for(AnswerControl c:controls.values()){
                if(c.combo!=null)require(!c.combo.isEditable(),c.question.key()+" editable");
                require(c.getAccessibleContext().getAccessibleName()!=null,"Accessible label");
                for(Bridge.Option o:c.question.options()){
                    Term value=c.question.type().equals("multi")&&!AnswerControl.special(o.value().name())?Term.termArrayToList(new Term[]{o.value()}):o.value();
                    c.setValue(value);require(c.value().equals(value),"Roundtrip "+c.question.key()+" "+value);
                }
                c.reset();require(c.value().name().equals("unknown"),"Default Unknown");
            }
            for(String key:List.of("triggers","gum_symptoms","warning_signs")){
                AnswerControl control=controls.get(key);
                List<String> items=control.buttons.keySet().stream().filter(k->!AnswerControl.special(k)).toList();
                control.buttons.get(items.get(0)).doClick();control.buttons.get(items.get(1)).doClick();require(control.value().listToTermArray().length==2,"Multiple findings "+key);
                control.buttons.get("none").doClick();require(control.value().name().equals("none"),"None exclusivity "+key);
                control.buttons.get(items.get(0)).doClick();require(!control.buttons.get("none").isSelected(),"Finding clears None "+key);
                control.buttons.get("na").doClick();require(control.value().name().equals("na"),"NA exclusivity "+key);
                control.buttons.get("unknown").doClick();require(control.value().name().equals("unknown"),"Unknown exclusivity "+key);
            }
        });
        App[] handle={null};SwingUtilities.invokeAndWait(()->handle[0]=new App());App a=handle[0];settled(a);
        SwingUtilities.invokeAndWait(()->{
            require(a.fields.size()==27,"Application initialization");set(a,"age_group","adolescent");set(a,"tooth_type","permanent");set(a,"tooth_pain","yes");set(a,"root_maturity","mature");a.navigate("symptoms");
        });settled(a);
        SwingUtilities.invokeAndWait(()->{
            set(a,"thermal_response","lingering");set(a,"sleep_pain","yes");a.navigate("findings");
        });settled(a);
        SwingUtilities.invokeAndWait(()->{a.navigate("symptoms");});settled(a);
        SwingUtilities.invokeAndWait(()->{require(a.fields.get("sleep_pain").value().name().equals("yes"),"Step 1 answer preserved");require(a.fields.get("thermal_response").value().name().equals("lingering"),"Step 2 answer preserved");a.navigate("setup");});settled(a);
        SwingUtilities.invokeAndWait(()->{require(a.fields.get("age_group").value().name().equals("adolescent"),"Setup preserved");set(a,"tooth_type","primary");a.refreshVisibility();});settled(a);
        SwingUtilities.invokeAndWait(()->{
            require(a.fields.get("thermal_response").value().name().equals("unknown"),"Hidden thermal cleared");require(!a.answers().containsKey("thermal_response"),"Hidden thermal excluded");
            set(a,"tooth_pain","no");a.refreshVisibility();
        });settled(a);
        SwingUtilities.invokeAndWait(()->{
            require(a.fields.get("sleep_pain").value().name().equals("unknown"),"Hidden symptom cleared");require(!a.answers().containsKey("sleep_pain"),"Hidden symptom excluded");
            set(a,"cavity","no");set(a,"discoloration","no");set(a,"soft_tissue","yes");a.fields.get("cal_mm").setValue(new org.jpl7.Integer(0));a.fields.get("buccal_cal_mm").setValue(new org.jpl7.Integer(0));set(a,"two_teeth","yes");a.refreshVisibility();
        });settled(a);
        SwingUtilities.invokeAndWait(()->{
            require(!a.answers().containsKey("soft_tissue")&&a.fields.get("soft_tissue").value().name().equals("unknown"),"Softened tissue cleared");
            require(!a.answers().containsKey("two_teeth")&&a.fields.get("two_teeth").value().name().equals("unknown"),"Periodontal follow-up cleared");
            for(int[] size:List.of(new int[]{1180,850},new int[]{960,680}))for(String screen:List.of("setup","symptoms","findings","knowledge"))render(a,screen,size[0],size[1]);
            set(a,"radiographic_caries","yes");a.assess();
        });settled(a);
        SwingUtilities.invokeAndWait(()->{
            require(a.displayedResultForTest().contains("Dental caries"),"Displayed symptom-free caries result");
            require(findButton(a,"Edit answers")==null&&findButton(a,"Save result")==null,"Removed result actions");
            for(int[] size:List.of(new int[]{1180,850},new int[]{960,680}))render(a,"results",size[0],size[1]);
            findButton(a,"New consultation").doClick();
        });settled(a);
        SwingUtilities.invokeAndWait(()->{require(a.currentScreen.equals("setup")&&a.displayedResultForTest().isEmpty(),"New consultation clears displayed result");require(a.fields.values().stream().allMatch(f->f.value().isAtom()&&f.value().name().equals("unknown")),"New consultation clears all answers");set(a,"warning_signs","none");a.fields.get("warning_signs").setValue(Term.termArrayToList(new Term[]{new Atom("fever")}));a.continueToFindings();});settled(a);
        SwingUtilities.invokeAndWait(()->{require(a.currentScreen.equals("results")&&a.resultTitleForTest().equals("Outside the supported scope"),"Warning signs bypass examination");a.reset();a.show("setup");});settled(a);
        SwingUtilities.invokeAndWait(()->{set(a,"age_group","adult");set(a,"tooth_pain","no");set(a,"gum_symptoms","none");set(a,"jaw_clicking","yes");a.continueToFindings();});settled(a);
        SwingUtilities.invokeAndWait(()->{require(a.currentScreen.equals("results")&&a.resultTitleForTest().equals("Outside the supported scope"),"Jaw-only bypasses examination");a.reset();});settled(a);
        // Queue edits, navigation and an assessment, then reset before any callback.
        SwingUtilities.invokeAndWait(()->{set(a,"age_group","adult");set(a,"tooth_pain","yes");a.refreshVisibility();a.navigate("symptoms");a.assess();a.reset();a.show("setup");});settled(a);
        SwingUtilities.invokeAndWait(()->{
            require(a.displayedResultForTest().isEmpty()&&a.currentScreen.equals("setup"),"No delayed result/navigation after reset");
            require(a.fields.values().stream().allMatch(f->f.value().isAtom()&&f.value().name().equals("unknown")),"Reset all inputs");a.dispose();
        });
        System.out.println("PASS: "+assessments+" JPL assessments; 27 control schemas; combined exclusivity, authoritative routing, two-step navigation, hidden clearing, scope bypass, removed result actions, new-consultation reset and delayed-callback reset.");System.exit(0);
    }
}
