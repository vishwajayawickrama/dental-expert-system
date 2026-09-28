:- module(dental_engine, [assess/4, forward_closure/2, backward_support/4, catalog/2]).
:- use_module(domain).
:- use_module(questions).
:- use_module(library(lists)).

% Stateless boundary: inputs and deductions belong to this call only.
assess(Input, Mode, Goal, Result) :-
    ( invalid_input(Input,Mode,Goal,Key) ->
        Result=result(invalid,[],[Key],['Choose a valid predefined value. Age must be between 0 and 120.'])
    ; expand_observations(Input,Obs),
      ( conflict(Obs,Message) -> Result=result(conflict,[],[],[Message])
      ; missing_setup(Obs,Missing) -> Result=result(incomplete,[],Missing,['Complete the required consultation inputs.'])
      ; outside_scope(Obs,Message) -> Result=result(outside_scope,[],[],[Message])
      ; assess_valid(Obs,Mode,Goal,Result) ) ).

invalid_input(Input,_,_,input) :- \+ is_list(Input),!.
invalid_input(Input,_,_,input) :- member(Item,Input), \+ (Item=obs(K,_),atom(K),ground(Item)),!.
invalid_input(Input,_,_,K) :- member(obs(K,V),Input), \+ valid_answer(K,V),!.
invalid_input(Input,_,_,K) :- select(obs(K,_),Input,Rest),memberchk(obs(K,_),Rest),!.
invalid_input(_,Mode,_,mode) :- \+ (atom(Mode), memberchk(Mode,[forward,backward])),!.
invalid_input(_,_,Goal,goal) :- \+ (atom(Goal), (Goal==all ; condition(Goal,_))),!.

value(Obs,Key,V) :- (memberchk(obs(Key,Found),Obs) -> V=Found ; V=unknown).
conflict(Obs,'Tooth-pain answers conflict. Clarify whether pain is present.') :-
    value(Obs,tooth_pain,no),member(Key,[spontaneous,sleep_pain,biting_pain]),value(Obs,Key,yes),!.
conflict(Obs,'Tooth identifier and tooth type conflict. Check the affected tooth.') :-
    value(Obs,tooth,T),integer(T),value(Obs,tooth_type,Type),
    (T>=51,Type==permanent ; T=<48,Type==primary),!.
conflict(Obs,'The two affected tooth identifiers are identical. Check the selections.') :-
    value(Obs,region,multiple_teeth),value(Obs,tooth,T),integer(T),value(Obs,second_tooth,T),!.
conflict(Obs,'Dentition and affected tooth type conflict. Check both selections.') :-
    value(Obs,dentition,D),value(Obs,tooth_type,T),
    (D==primary,T==permanent ; D==permanent,T==primary),!.
missing_setup(Obs,[age]) :- value(Obs,age,unknown),!.
missing_setup(Obs,[tooth_type]) :- value(Obs,tooth_pain,yes),value(Obs,tooth_type,T),memberchk(T,[unknown,na]),!.
outside_scope(Obs,'This jaw presentation is outside the supported tooth-pain and gum-symptom scope.') :-
    value(Obs,jaw_clicking,yes),value(Obs,tooth_pain,no),value(Obs,gum_bleeding,no),value(Obs,red_gums,no),!.
outside_scope(Obs,'Swelling, drainage or fever requires assessment beyond this limited condition catalogue.') :-
    member(K,[facial_swelling,drainage,fever]),value(Obs,K,yes),!.

assess_valid(Obs,Mode,Goal,result(Status,Candidates,Missing,Messages)) :-
    targets(Goal,AllTargets), scoped_targets(Obs,Mode,AllTargets,Targets),
    (Mode==forward -> forward_closure(Obs,Derived),findall(C,(member(C,Targets),memberchk(candidate(C),Derived)),Candidates)
    ; findall(C,(member(C,Targets),backward_support(Obs,candidate(C),yes,_)),Candidates)),
    findall(K,(member(C,Targets),\+ memberchk(C,Candidates),backward_support(Obs,candidate(C),unknown,Keys),member(K,Keys)),RawMissing),
    sort(RawMissing,Missing),
    (Candidates\=[] -> Status=candidates,Messages=['Candidate conditions only. Clinical knowledge review is pending.']
    ; Missing\=[] -> Status=incomplete,Messages=['Additional predefined findings are needed to assess this presentation.']
    ; Status=no_supported_condition,Messages=['No supported candidate follows from the supplied findings. This does not exclude other conditions.']).
scoped_targets(Obs,forward,All,Targets) :- !, value(Obs,focus,Focus),
    (Focus==tooth -> include(tooth_target,All,Targets)
    ; Focus==gums -> include(gum_target,All,Targets)
    ; Targets=All).
scoped_targets(_,_,Targets,Targets).
tooth_target(C) :- memberchk(C,[caries,reversible_pulpitis,irreversible_pulpitis]).
gum_target(C) :- memberchk(C,[gingivitis,periodontitis]).
targets(all,Targets) :- !,findall(C,condition(C,_),Targets).
targets(C,[C]).

% A real data-driven fixed point, independent of backward_support/4.
forward_closure(Obs,Closure) :- forward_step(Obs,[],Closure).
forward_step(Obs,Old,Closure) :-
    findall(C,(rule(_,Premises,C,_,_),forall(member(P,Premises),satisfied(P,Obs,Old))),New),
    append(Old,New,Combined),sort(Combined,Next),
    (Next==Old -> Closure=Next ; forward_step(Obs,Next,Closure)).
satisfied(derived(C),_,Derived) :- memberchk(C,Derived).
satisfied(kb(F),_,_) :- domain_fact(_,F,_,_,_).
satisfied(P,Obs,_) :- input_test(P,Obs,yes,_).

% Goal-driven recursive evaluation; no call to forward_closure/2.
backward_support(Obs,Goal,State,Missing) :- prove(Goal,Obs,[],State,Missing).
prove(Goal,_,Seen,no,[]) :- memberchk(Goal,Seen),!.
prove(Goal,Obs,Seen,State,Missing) :-
    findall(S-M,(rule(_,Premises,Goal,_,_),prove_all(Premises,Obs,[Goal|Seen],S,M)),Branches),
    disjunction(Branches,State,Missing).
prove_all([],_,_,yes,[]).
prove_all([P|Ps],Obs,Seen,State,Missing) :-
    prove_premise(P,Obs,Seen,S1,M1),prove_all(Ps,Obs,Seen,S2,M2),
    ((S1==no ; S2==no) -> State=no,Missing=[]
    ; S1==yes,S2==yes -> State=yes,Missing=[]
    ; State=unknown,append(M1,M2,M),sort(M,Missing)).
prove_premise(derived(C),Obs,Seen,S,M) :- !,prove(C,Obs,Seen,S,M).
prove_premise(kb(F),_,_,S,[]) :- !,(domain_fact(_,F,_,_,_) -> S=yes ; S=no).
prove_premise(P,Obs,_,S,M) :- input_test(P,Obs,S,M).
disjunction(Branches,yes,[]) :- member(yes-_,Branches),!.
disjunction(Branches,unknown,Missing) :-
    findall(K,(member(unknown-Keys,Branches),member(K,Keys)),All),All\=[],!,sort(All,Missing).
disjunction(_,no,[]).

input_test(Test,Obs,State,Missing) :-
    Test=..[Op,Key,Expected],value(Obs,Key,Actual),
    (memberchk(Actual,[unknown,na]) -> State=unknown,public_key(Key,K),Missing=[K]
    ; comparison(Op,Actual,Expected) -> State=yes,Missing=[]
    ; State=no,Missing=[]).
comparison(eq,A,B) :- (number(A),number(B) -> A=:=B ; A==B).
comparison(gt,A,B) :- number(A),A>B.
comparison(gte,A,B) :- number(A),A>=B.
comparison(lte,A,B) :- number(A),A=<B.
public_key(K,triggers) :- memberchk(K,[trigger_cold,trigger_sweet,trigger_hot]),!.
public_key(K,K).

catalog(questions,Records) :- findall(question(K,S,T,L,O,W),question(K,S,T,L,O,W),Records).
catalog(facts,Records) :- findall(fact(I,F,L,U,R),(domain_fact(I,F,L,Source,R),source(Source,_,U)),Records).
catalog(rules,Records) :- findall(rule(I,P,C,U,R),(rule(I,P,C,Source,R),source(Source,_,U)),Records).
catalog(conditions,Records) :- findall(condition(C,L),condition(C,L),Records).
catalog(version,[V]) :- knowledge_version(V).

% Question provenance is schema metadata, separate from the thirty domain facts.
catalog(question_sources,Records) :- findall(question_source(K,U,pending),(question(K,S,_,_,_,_),question_source(S,Source),source(Source,_,U)),Records).
question_source(setup,aapd).
question_source(symptoms,aae).
question_source(history,aapd).
question_source(examination,aapd).
question_source(periodontal,efp_g).
