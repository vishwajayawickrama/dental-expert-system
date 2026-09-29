:- use_module('../knowledge/acceptance').
:- use_module('../knowledge/domain').
:- use_module('../knowledge/questions').
:- use_module('../knowledge/engine').
:- use_module(library(http/json)).

term_text(T,S) :- term_string(T,S,[quoted(true)]).
option_data(option(V,L),_{value:S,label:L}) :- term_text(V,S).
observation_data(obs(K,V),_{key:K,value:S}) :- term_text(V,S).

export_report_data :-
    findall(_{id:I,term:T,description:L,source:S,review:R},
      (domain_fact(I,F,L,S,R),term_text(F,T)),Facts),
    findall(_{id:I,premises:P,conclusion:C,source:S,review:R},
      (rule(I,Ps,Co,S,R),maplist(term_text,Ps,P),term_text(Co,C)),Rules),
    findall(_{id:K,section:S,type:T,label:L,options:Options},
      (question(K,S,T,L,O,_),maplist(option_data,O,Options)),Questions),
    findall(_{id:I,title:L,url:U},source(I,L,U),Sources),
    findall(_{id:I,expected_status:Status,target:Target,inputs:Inputs,
              active:Active,status:Actual,candidates:C,missing:M,messages:Messages,pass:Passed},
      (dental_acceptance:case(I,O,Status,Target),assess(O,result(Actual,C,M,Messages)),
       maplist(observation_data,O,Inputs),
       catch(findall(K,(member(Stage,[setup,symptoms,findings]),active_questions(O,Stage,Ks),member(K,Ks)),Raw),_,Raw=[]),sort(Raw,Active),
       (dental_acceptance:verify(Status,Target,result(Actual,C,M,Messages))->Passed=true;Passed=false)),Cases),
    findall(_{id:I,ordered_questions:N,final_visible:V},
      (dental_acceptance:case(I,_,_,Target),Target\==none,walkthrough(I,N,V,_)),Counts),
    json_write_dict(current_output,_{version:'0.4.0',facts:Facts,rules:Rules,questions:Questions,sources:Sources,cases:Cases,question_counts:Counts},[width(0)]),nl.
