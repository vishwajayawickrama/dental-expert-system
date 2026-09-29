package dental;

import org.jpl7.*;
import java.nio.file.*;
import java.util.*;

/** Structured, serialized JPL boundary; clinical labels never become query text. */
public final class Bridge {
    public record Option(Term value, String label) { public String toString(){return label;} }
    public record Question(String key,String section,String type,String label,List<Option> options,Term visibility) {}
    public record Result(String status,List<String> candidates,List<String> missing,List<String> messages) {}
    public final List<Question> questions;
    public final Map<String,String> conditions=new LinkedHashMap<>();
    public final String version;
    private final Map<String,Term[]> catalogue=new LinkedHashMap<>();
    public final Path root;
    public Bridge() throws Exception {
        root=Path.of(System.getProperty("dental.home", ".")).toAbsolutePath().normalize();
        Path runtime=root.resolve("runtime");
        if(!Files.exists(runtime)) runtime=root.resolve(".runtime/SWI-Prolog.app/Contents");
        Path jvm=Path.of(System.getProperty("java.home"),"lib/server/libjvm.dylib");
        System.load(jvm.toString());
        System.load(runtime.resolve("Frameworks/libgmp.10.dylib").toString());
        System.load(runtime.resolve("Frameworks/libz.1.dylib").toString());
        System.load(runtime.resolve("Frameworks/libswipl.10.dylib").toString());
        JPL.setNativeLibraryPath(runtime.resolve("PlugIns/swipl/libjpl.dylib").toString());
        String home=runtime.resolve("Resources/swipl").toString();
        JPL.setDefaultInitArgs(new String[]{"swipl","--quiet","--nosignals","--home="+home,"-x",home+"/boot.prc"});
        if(!JPL.init() && JPL.getActualInitArgs()==null) throw new IllegalStateException("SWI-Prolog initialization failed");
        query(new Compound("consult",new Term[]{new Atom(root.resolve("knowledge/engine.pl").toString())}));
        for(String kind:List.of("questions","facts","rules","conditions","version","question_sources")) catalogue.put(kind,query(qualified("catalog",new Atom(kind),new Variable("Records"))).get("Records").listToTermArray());
        List<Question> qs=new ArrayList<>();
        for(Term q:catalog("questions")) {
            List<Option> options=new ArrayList<>();
            for(Term o:q.arg(5).listToTermArray()) options.add(new Option(o.arg(1),o.arg(2).name()));
            qs.add(new Question(q.arg(1).name(),q.arg(2).name(),q.arg(3).name(),q.arg(4).name(),List.copyOf(options),q.arg(6)));
        }
        questions=List.copyOf(qs);
        for(Term c:catalog("conditions")) conditions.put(c.arg(1).name(),c.arg(2).name());
        version=catalog("version")[0].name();
    }
    private synchronized Map<String,Term> query(Term goal) {
        Query q=new Query(goal);
        try {Map<String,Term> result=q.oneSolution();if(result==null)throw new IllegalStateException("Prolog operation failed");return result;}
        finally {q.close();}
    }
    private Term qualified(String name,Term... args){return new Compound(":",new Term[]{new Atom("dental_engine"),new Compound(name,args)});}
    public Term[] catalog(String kind){return catalogue.get(kind).clone();}
    private Term observations(Map<String,Term> answers){
        return Term.termArrayToList(answers.entrySet().stream().map(e->new Compound("obs",new Term[]{new Atom(e.getKey()),e.getValue()})).toArray(Term[]::new));
    }
    public List<String> activeQuestions(Map<String,Term> answers,String stage){
        return names(query(qualified("active_questions",observations(answers),new Atom(stage),new Variable("Ids"))).get("Ids"));
    }
    public Result assess(Map<String,Term> answers){

        Term r=query(qualified("assess",observations(answers),new Variable("Result"))).get("Result");
        return new Result(r.arg(1).name(),names(r.arg(2)),names(r.arg(3)),names(r.arg(4)));
    }
    static List<String> names(Term list){return Arrays.stream(list.listToTermArray()).map(Term::name).toList();}
}
