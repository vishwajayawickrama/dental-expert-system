package dental;
import org.jpl7.*;
import javax.swing.*;
import java.util.*;
import java.util.concurrent.*;

public final class IntegrationTest {
    static void require(boolean b,String message){if(!b)throw new AssertionError(message);}
    static Map<String,Term> observations(Term list){Map<String,Term> map=new LinkedHashMap<>();for(Term o:list.listToTermArray())map.put(o.arg(1).name(),o.arg(2));return map;}
    static void query(Term goal){Query q=new Query(goal);try{require(q.hasSolution(),"Query failed: "+goal);}finally{q.close();}}
    public static void main(String[] args)throws Exception{
        Bridge b=new Bridge();query(new Compound("consult",new Term[]{new Atom(b.root.resolve("knowledge/acceptance.pl").toString())}));
        Term all=new Compound(":",new Term[]{new Atom("dental_acceptance"),new Compound("case",new Term[]{new Variable("ID"),new Variable("O"),new Variable("Status"),new Variable("Target")})});
        Map<String,Term>[] cases;Query fixtureQuery=new Query(all);try{cases=fixtureQuery.allSolutions();}finally{fixtureQuery.close();}
        require(cases.length==20,"Exactly 20 acceptance fixtures");int assessments=0;
        for(var c:cases){String id=c.get("ID").name(),expected=c.get("Status").name(),target=c.get("Target").name();Map<String,Term> input=observations(c.get("O"));Bridge.Result f=b.assess(input,"forward","all");require(f.status().equals(expected),id+" status "+f);assessments++;
            if(!target.equals("none")){Bridge.Result back=b.assess(input,"backward",target);require(f.candidates().contains(target)&&back.candidates().equals(List.of(target)),id+" agreement");assessments++;}
            else {require(f.candidates().isEmpty(),id+" prohibited conclusion");Bridge.Result back=b.assess(input,"backward","caries");require(back.status().equals(expected)&&back.candidates().isEmpty(),id+" backward validation");assessments++;}
            System.out.println("JPL "+id+": PASS");
        }
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
                c.reset();require(c.value().name().equals(c.question.key().equals("focus")?"full":"unknown"),"Default Unknown");
            }
            AnswerControl triggers=controls.get("triggers");triggers.buttons.get("cold").doClick();triggers.buttons.get("hot").doClick();require(triggers.value().listToTermArray().length==2,"Substantive selections");
            triggers.buttons.get("none").doClick();require(triggers.value().name().equals("none"),"None exclusivity");triggers.buttons.get("cold").doClick();require(!triggers.buttons.get("none").isSelected(),"Substantive clears None");
            triggers.buttons.get("na").doClick();require(triggers.value().name().equals("na"),"N/A exclusivity");triggers.buttons.get("unknown").doClick();require(triggers.value().name().equals("unknown"),"Unknown exclusivity");
        });
        App[] app={null};SwingUtilities.invokeAndWait(()->app[0]=new App());
        for(int i=0;i<100;i++){boolean[] ready={false};SwingUtilities.invokeAndWait(()->ready[0]=app[0].fields.size()==b.questions.size());if(ready[0])break;Thread.sleep(50);}
        SwingUtilities.invokeAndWait(()->{
            App a=app[0];require(a.fields.size()==44,"Application initialization");a.fields.get("age").setValue(new org.jpl7.Integer(16));a.fields.get("tooth_type").setValue(new Atom("permanent"));a.fields.get("root_maturity").setValue(new Atom("mature"));a.refreshVisibility();a.fields.get("thermal_response").setValue(new Atom("lingering"));
            a.show("questionnaire");a.show("setup");require(a.fields.get("age").value().intValue()==16,"Back navigation preserved");
            a.fields.get("tooth_type").setValue(new Atom("primary"));a.refreshVisibility();require(a.fields.get("thermal_response").value().name().equals("unknown"),"Hidden response cleared");require(!a.answers().containsKey("thermal_response"),"Hidden response excluded");
            // Reset executes before the worker callback reaches EDT; a delayed result must be discarded.
            a.assess();a.reset();require(a.answers().get("age").name().equals("unknown"),"Reset inputs");
        });
        Thread.sleep(300);SwingUtilities.invokeAndWait(()->{require(app[0].savedResultForTest()==null,"No delayed result after reset");app[0].dispose();});
        System.out.println("PASS: "+assessments+" JPL assessments; 44 control schemas; exclusivity, conditional clearing, navigation and delayed-result reset.");System.exit(0);
    }
}
