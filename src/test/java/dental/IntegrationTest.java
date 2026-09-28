package dental;
import org.jpl7.*;
import javax.swing.*;
import java.util.*;
import java.util.concurrent.*;
import java.awt.image.BufferedImage;
import java.nio.file.*;
import javax.imageio.ImageIO;

public final class IntegrationTest {
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
    public static void main(String[] args)throws Exception{
        UIManager.setLookAndFeel(UIManager.getCrossPlatformLookAndFeelClassName());
        for(Object key:new ArrayList<>(UIManager.getDefaults().keySet()))if(UIManager.get(key) instanceof java.awt.Font)UIManager.put(key,new javax.swing.plaf.FontUIResource(App.BODY));
        Bridge b=new Bridge();query(new Compound("consult",new Term[]{new Atom(b.root.resolve("knowledge/acceptance.pl").toString())}));
        Term all=new Compound(":",new Term[]{new Atom("dental_acceptance"),new Compound("case",new Term[]{new Variable("ID"),new Variable("O"),new Variable("Status"),new Variable("Target")})});
        Map<String,Term>[] cases;Query fixtureQuery=new Query(all);try{cases=fixtureQuery.allSolutions();}finally{fixtureQuery.close();}
        require(cases.length==20,"Exactly 20 acceptance fixtures");int assessments=0;
        for(var c:cases){String id=c.get("ID").name(),expected=c.get("Status").name(),target=c.get("Target").name();Map<String,Term> input=observations(c.get("O"));Bridge.Result f=b.assess(input);require(f.status().equals(expected),id+" status "+f);assessments++;
            if(!target.equals("none"))require(f.candidates().contains(target),id+" target missing");
            else require(f.candidates().isEmpty(),id+" prohibited conclusion");
            query(new Compound(":",new Term[]{new Atom("dental_acceptance"),new Compound("verify",new Term[]{new Atom(expected),new Atom(target),new Compound("result",new Term[]{new Atom(f.status()),Term.termArrayToList(f.candidates().stream().map(Atom::new).toArray(Term[]::new)),Term.termArrayToList(f.missing().stream().map(Atom::new).toArray(Term[]::new)),Term.termArrayToList(f.messages().stream().map(Atom::new).toArray(Term[]::new))})})}));
            System.out.println("JPL "+id+": PASS");
        }
        require(b.version.equals("0.2.0"),"Knowledge version");
        require(b.questions.size()==43,"43 questions");
        require(b.questions.stream().noneMatch(q->Set.of("age","focus").contains(q.key())),"Removed clinical identifiers");
        require(b.questions.stream().filter(qs->qs.key().equals("symptom_duration")).findFirst().orElseThrow().options().get(1).label().equals("1-7 days"),"Duration labels intact");
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
            AnswerControl triggers=controls.get("triggers");triggers.buttons.get("cold").doClick();triggers.buttons.get("hot").doClick();require(triggers.value().listToTermArray().length==2,"Substantive selections");
            triggers.buttons.get("none").doClick();require(triggers.value().name().equals("none"),"None exclusivity");triggers.buttons.get("cold").doClick();require(!triggers.buttons.get("none").isSelected(),"Substantive clears None");
            triggers.buttons.get("na").doClick();require(triggers.value().name().equals("na"),"N/A exclusivity");triggers.buttons.get("unknown").doClick();require(triggers.value().name().equals("unknown"),"Unknown exclusivity");
        });
        App[] app={null};SwingUtilities.invokeAndWait(()->app[0]=new App());
        for(int i=0;i<100;i++){boolean[] ready={false};SwingUtilities.invokeAndWait(()->ready[0]=app[0].fields.size()==b.questions.size());if(ready[0])break;Thread.sleep(50);}
        SwingUtilities.invokeAndWait(()->{
            App a=app[0];require(a.fields.size()==43,"Application initialization");a.fields.get("age_group").setValue(new Atom("adolescent"));a.fields.get("tooth_type").setValue(new Atom("permanent"));a.fields.get("root_maturity").setValue(new Atom("mature"));a.refreshVisibility();a.fields.get("thermal_response").setValue(new Atom("lingering"));
            a.show("questionnaire");a.show("setup");require(a.fields.get("age_group").value().name().equals("adolescent"),"Back navigation preserved");
            a.fields.get("tooth_type").setValue(new Atom("primary"));a.refreshVisibility();require(a.fields.get("thermal_response").value().name().equals("unknown"),"Hidden response cleared");require(!a.answers().containsKey("thermal_response"),"Hidden response excluded");
            for(int[] size:List.of(new int[]{1180,850},new int[]{960,680}))for(String screen:List.of("setup","questionnaire","knowledge"))render(a,screen,size[0],size[1]);
            a.fields.get("tooth_pain").setValue(new Atom("no"));a.fields.get("radiographic_caries").setValue(new Atom("yes"));a.assess();
        });
        for(int i=0;i<100;i++){boolean[] done={false};SwingUtilities.invokeAndWait(()->done[0]=app[0].savedResultForTest()!=null);if(done[0])break;Thread.sleep(50);}
        SwingUtilities.invokeAndWait(()->{
            App a=app[0];String saved=a.savedResultForTest();require(saved!=null&&saved.contains("age_group = adolescent | 13-17 years")&&saved.contains("Method: Forward chaining")&&!saved.contains("Goal:"),"Saved age group and forward-only method");
            for(int[] size:List.of(new int[]{1180,850},new int[]{960,680}))render(a,"results",size[0],size[1]);
            // Reset executes before the worker callback reaches EDT; a delayed result must be discarded.
            a.assess();a.reset();require(a.answers().get("age_group").name().equals("unknown"),"Reset inputs");
        });
        Thread.sleep(300);SwingUtilities.invokeAndWait(()->{require(app[0].savedResultForTest()==null,"No delayed result after reset");app[0].dispose();});
        System.out.println("PASS: "+assessments+" JPL assessments; 43 control schemas; exclusivity, conditional clearing, navigation and delayed-result reset.");System.exit(0);
    }
}
