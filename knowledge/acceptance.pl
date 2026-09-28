:- module(dental_acceptance,[case/4,run_acceptance/0]).
:- use_module(engine).
:- discontiguous case/4.
:- use_module(questions).
:- use_module(library(plunit)).

% Synthetic fixtures corresponding to docs/test-cases.md. Missing measurements
% remain unknown. These records are test data, never counted as domain facts.
common_tooth([obs(region,single_tooth),obs(cavity,yes),obs(soft_tissue,unknown),obs(radiographic_caries,yes),obs(fracture,no),obs(facial_swelling,no),obs(drainage,no),obs(fever,no),obs(percussion,no),obs(apical_pathology,no),obs(gum_bleeding,no),obs(red_gums,no),obs(history,none),obs(gum_tenderness,no),obs(mobility,no),obs(plaque,yes),obs(pocket_mm,3),obs(cal_mm,0),obs(bop_percent,0),obs(bone_loss,no)]).
asymptomatic([obs(tooth_pain,no),obs(spontaneous,no),obs(sleep_pain,no),obs(biting_pain,no),obs(symptom_duration,na)]).
reversible([obs(tooth_pain,yes),obs(pain_severity,mild),obs(symptom_duration,days),obs(spontaneous,no),obs(sleep_pain,no),obs(biting_pain,no),obs(persistence,brief)]).
irreversible([obs(tooth_pain,yes),obs(pain_severity,severe),obs(symptom_duration,days),obs(spontaneous,yes),obs(sleep_pain,yes),obs(biting_pain,no),obs(persistence,lingering)]).
gums([obs(tooth_pain,no),obs(spontaneous,no),obs(sleep_pain,no),obs(gum_bleeding,yes),obs(red_gums,yes),obs(plaque,yes),obs(facial_swelling,no),obs(drainage,no),obs(fever,no),obs(history,none),obs(cal_mm,0),obs(pocket_mm,3),obs(prior_destruction,no),obs(gum_tenderness,yes),obs(biting_pain,no),obs(cavity,no),obs(fracture,no),obs(percussion,no),obs(mobility,no)]).
combine(A,B,C,Obs) :- append([A,B,C],Obs).
case(tc01,O,candidates,caries) :- common_tooth(Raw),select(obs(soft_tissue,unknown),Raw,T),A=[obs(soft_tissue,yes)|T],asymptomatic(B),combine(A,B,[obs(age_group,child),obs(dentition,mixed),obs(tooth_type,primary),obs(tooth,85)],O).
case(tc02,O,candidates,caries) :- common_tooth(Raw),select(obs(soft_tissue,unknown),Raw,T),A=[obs(soft_tissue,yes)|T],asymptomatic(B),combine(A,B,[obs(age_group,child),obs(dentition,permanent),obs(tooth_type,permanent),obs(tooth,16),obs(root_maturity,unknown)],O).
case(tc03,O,candidates,caries) :- common_tooth(Raw),select(obs(soft_tissue,unknown),Raw,T),A=[obs(soft_tissue,yes)|T],asymptomatic(B),combine(A,B,[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,permanent),obs(tooth,36),obs(root_maturity,mature),obs(thermal_response,brief)],O).
case(tc04,O,candidates,reversible_pulpitis) :- common_tooth(A),reversible(B),combine(A,B,[obs(age_group,child),obs(dentition,mixed),obs(tooth_type,primary),obs(tooth,75),obs(triggers,[sweet])],O).
case(tc05,O,candidates,reversible_pulpitis) :- common_tooth(A),reversible(B),combine(A,B,[obs(age_group,adolescent),obs(dentition,permanent),obs(tooth_type,permanent),obs(tooth,17),obs(root_maturity,immature),obs(triggers,[cold])],O).
case(tc06,O,candidates,reversible_pulpitis) :- common_tooth(A),reversible(B),combine(A,B,[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,permanent),obs(tooth,46),obs(root_maturity,mature),obs(thermal_response,brief),obs(electric_response,present),obs(triggers,[cold,sweet])],O).
case(tc07,O,candidates,irreversible_pulpitis) :- common_tooth(A),irreversible(B),combine(A,B,[obs(age_group,child),obs(dentition,mixed),obs(tooth_type,primary),obs(tooth,65),obs(triggers,unknown)],O).
case(tc08,O,candidates,irreversible_pulpitis) :- common_tooth(A),irreversible(B),combine(A,B,[obs(age_group,adolescent),obs(dentition,permanent),obs(tooth_type,permanent),obs(tooth,36),obs(root_maturity,mature),obs(thermal_response,lingering),obs(electric_response,present),obs(triggers,[cold])],O).
case(tc09,O,candidates,irreversible_pulpitis) :- common_tooth(A),irreversible(B),combine(A,B,[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,permanent),obs(tooth,16),obs(root_maturity,mature),obs(thermal_response,lingering),obs(electric_response,present),obs(triggers,[cold,hot])],O).
case(tc10,O,candidates,gingivitis) :- gums(A),combine(A,[],[obs(age_group,child),obs(dentition,mixed),obs(tooth_type,na),obs(tooth,na),obs(region,general_gums),obs(symptom_duration,weeks),obs(bop_percent,30)],O).
case(tc11,O,candidates,gingivitis) :- gums(A),combine(A,[],[obs(age_group,adolescent),obs(dentition,permanent),obs(tooth_type,na),obs(tooth,na),obs(region,general_gums),obs(symptom_duration,weeks),obs(bop_percent,40)],O).
case(tc12,O,candidates,gingivitis) :- gums(A),combine(A,[],[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,na),obs(tooth,na),obs(region,anterior_gums),obs(symptom_duration,months),obs(bop_percent,35)],O).
periodontal([obs(dentition,permanent),obs(region,multiple_teeth),obs(tooth_type,permanent),obs(tooth_pain,no),obs(gum_bleeding,yes),obs(red_gums,yes),obs(plaque,yes),obs(nonadjacent_teeth,yes),obs(two_teeth,yes),obs(nonperiodontal_causes,no),obs(prior_destruction,unknown),obs(spontaneous,no),obs(sleep_pain,no),obs(biting_pain,no),obs(cavity,no),obs(fracture,no),obs(percussion,no),obs(gum_tenderness,yes),obs(bone_loss,yes),obs(facial_swelling,no),obs(drainage,no),obs(fever,no),obs(history,none)]).
case(tc13,O,candidates,periodontitis) :- periodontal(A),combine(A,[],[obs(age_group,adult),obs(tooth,16),obs(second_tooth,36),obs(cal_mm,4),obs(pocket_mm,6),obs(buccal_cal_mm,unknown),obs(mobility,no),obs(symptom_duration,months)],O).
case(tc14,O,candidates,periodontitis) :- periodontal(A),combine(A,[],[obs(age_group,older_adult),obs(tooth,26),obs(second_tooth,46),obs(cal_mm,6),obs(pocket_mm,7),obs(buccal_cal_mm,unknown),obs(mobility,yes),obs(symptom_duration,long_term)],O).
case(tc15,[obs(tooth_pain,yes),obs(triggers,[cold]),obs(tooth_type,permanent),obs(tooth,36),obs(pain_severity,mild),obs(symptom_duration,days)],incomplete,none).
case(tc16,[obs(age_group,-2)],invalid,none).
case(tc17,[obs(age_group,child),obs(tooth_pain,yes),obs(triggers,[cold]),obs(tooth_type,unknown),obs(pain_severity,moderate),obs(symptom_duration,days),obs(facial_swelling,no),obs(drainage,no),obs(fever,no)],incomplete,none).
case(tc18,[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,permanent),obs(tooth,46),obs(tooth_pain,no),obs(spontaneous,yes)],conflict,none).
case(tc19,[obs(age_group,adult),obs(dentition,permanent),obs(region,jaw_joint),obs(tooth,na),obs(tooth_type,na),obs(symptom_duration,months),obs(gum_tenderness,no),obs(facial_swelling,no),obs(drainage,no),obs(fever,no),obs(jaw_clicking,yes),obs(tooth_pain,no),obs(gum_bleeding,no),obs(red_gums,no)],outside_scope,none).
case(tc20,[],incomplete,none).

run_acceptance :-
    forall(case(ID,O,Expected,Target),
      (assess(O,R),verify(Expected,Target,R),
       format('~w | Forward: ~q | PASS~n',[ID,R]))),
    run_tests.
verify(S,none,result(S,[],_,_)) :- !.
verify(S,T,result(S,C,_,_)) :- memberchk(T,C),
    (T==caries -> \+ memberchk(reversible_pulpitis,C),\+ memberchk(irreversible_pulpitis,C)
    ; T==reversible_pulpitis -> \+ memberchk(irreversible_pulpitis,C)
    ; T==irreversible_pulpitis -> \+ memberchk(reversible_pulpitis,C)
    ; T==gingivitis -> \+ memberchk(periodontitis,C)
    ; T==periodontitis -> \+ memberchk(gingivitis,C)).

:- begin_tests(engine).
test(counts) :- catalog(facts,F),length(F,30),catalog(rules,R),length(R,25).
test(schema_values) :- forall((dental_questions:question(K,_,T,_,Options,_),member(option(V,_),Options)),(T==multi,\+memberchk(V,[none,unknown,na])->valid_answer(K,[V]);valid_answer(K,V))).
test(unknown_distinct) :- expand_observations([obs(triggers,[cold])],O),memberchk(obs(trigger_cold,yes),O),memberchk(obs(trigger_hot,unknown),O).
test(none_distinct) :- expand_observations([obs(triggers,none)],O),memberchk(obs(trigger_cold,no),O).
test(na_distinct) :- expand_observations([obs(triggers,na)],O),memberchk(obs(trigger_cold,na),O).
test(reject_mixed_checkbox) :- assess([obs(age_group,adult),obs(triggers,[cold,none])],result(invalid,[],_,_)).
test(reject_arbitrary_atom) :- assess([obs(age_group,adult),obs(cavity,probably)],result(invalid,[],_,_)).
test(reject_duplicate) :- assess([obs(age_group,adult),obs(age_group,child)],result(invalid,[],_,_)).
test(termination_duplicates) :- case(tc06,O,_,_),expand_observations(O,E),call_with_time_limit(2,forward_closure(E,C)),sort(C,C),memberchk(candidate(reversible_pulpitis),C).
test(coexisting) :- case(tc06,O,_,_),assess(O,result(candidates,C,_,_)),memberchk(caries,C),memberchk(reversible_pulpitis,C).
test(reset_stateless) :- case(tc11,O,_,_),assess(O,result(candidates,_,_,_)),assess([],result(incomplete,[],[age_group],_)).
test(no_supported) :- assess([obs(age_group,adult),obs(tooth_pain,no),obs(cavity,no),obs(soft_tissue,no),obs(radiographic_caries,no),obs(gum_bleeding,no),obs(red_gums,no),obs(plaque,no),obs(cal_mm,0),obs(buccal_cal_mm,0)],result(no_supported_condition,[],[],_)).
test(tooth_mismatch) :- assess([obs(age_group,child),obs(tooth,85),obs(tooth_type,permanent)],result(conflict,[],[],_)).
test(duplicate_teeth) :- assess([obs(age_group,adult),obs(region,multiple_teeth),obs(tooth,16),obs(second_tooth,16)],result(conflict,[],[],_)).
test(age_groups) :- forall(member(A,[young_child,child,adolescent,adult,older_adult]),(assess([obs(age_group,A)],result(incomplete,[],M,_)),\+memberchk(age_group,M))).
test(missing_age_group) :- assess([],result(incomplete,[],[age_group],_)).
test(unknown_age_group) :- assess([obs(age_group,unknown)],result(incomplete,[],[age_group],_)).
test(reject_numeric_group) :- forall(member(A,[-2,16,20.5,121]),assess([obs(age_group,A)],result(invalid,[],[age_group],_))).
test(reject_group_atom) :- assess([obs(age_group,teenager)],result(invalid,[],[age_group],_)).
test(reject_legacy_age) :- assess([obs(age,16)],result(invalid,[],[age],_)).
test(reject_removed_focus) :- assess([obs(focus,tooth)],result(invalid,[],[focus],_)).
test(question_count) :- catalog(questions,Q),length(Q,43).
test(forward_missing) :- case(tc06,O,_,_),select(obs(persistence,brief),O,Rest),assess(Rest,result(candidates,C,M,_)),memberchk(caries,C),\+memberchk(reversible_pulpitis,C),memberchk(persistence,M).
test(known_negative_blocks_missing) :- case(tc06,O,_,_),select(obs(tooth_pain,yes),O,Rest),select(obs(persistence,brief),Rest,R2),assess([obs(tooth_pain,no)|R2],result(candidates,_,M,_)),\+memberchk(persistence,M).
test(na_does_not_satisfy) :- case(tc06,O,_,_),select(obs(persistence,brief),O,Rest),assess([obs(persistence,na)|Rest],result(candidates,C,M,_)),\+memberchk(reversible_pulpitis,C),memberchk(persistence,M).
test(pending_termination) :- case(tc06,O,_,_),select(obs(persistence,brief),O,Rest),call_with_time_limit(2,assess(Rest,_)).
test(age_does_not_choose_diagnosis) :- case(tc06,O,_,_),select(obs(age_group,adult),O,Rest),assess(O,R),forall(member(A,[young_child,child,adolescent,adult,older_adult]),assess([obs(age_group,A)|Rest],R)).
:- end_tests(engine).
