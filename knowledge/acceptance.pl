:- module(dental_acceptance,[case/4,run_acceptance/0]).
:- use_module(engine).
:- discontiguous case/4.
:- use_module(questions).
:- use_module(library(plunit)).

% Synthetic fixtures corresponding to docs/test-cases.md. Missing measurements
% remain unknown. These records are test data, never counted as domain facts.
common_tooth([obs(region,single_tooth),obs(cavity,yes),obs(soft_tissue,unknown),obs(radiographic_caries,yes),obs(warning_signs,none),obs(percussion,no),obs(apical_pathology,no),obs(gum_symptoms,none),obs(plaque,yes),obs(pocket_mm,3),obs(cal_mm,0),obs(bop_percent,0)]).
asymptomatic([obs(tooth_pain,no),obs(spontaneous,no),obs(sleep_pain,no),obs(biting_pain,no)]).
reversible([obs(tooth_pain,yes),obs(spontaneous,no),obs(sleep_pain,no),obs(biting_pain,no),obs(persistence,brief)]).
irreversible([obs(tooth_pain,yes),obs(spontaneous,yes),obs(sleep_pain,yes),obs(biting_pain,no),obs(persistence,lingering)]).
gums([obs(tooth_pain,no),obs(spontaneous,no),obs(sleep_pain,no),obs(gum_symptoms,[bleeding,redness]),obs(plaque,yes),obs(warning_signs,none),obs(cal_mm,0),obs(pocket_mm,3),obs(prior_destruction,no),obs(biting_pain,no),obs(cavity,no),obs(percussion,no)]).
combine(A,B,C,Obs) :- append([A,B,C],Obs).
case(tc01,O,candidates,caries) :- common_tooth(Raw),select(obs(soft_tissue,unknown),Raw,T),A=[obs(soft_tissue,yes)|T],asymptomatic(B),combine(A,B,[obs(age_group,child),obs(dentition,mixed),obs(tooth_type,primary)],O).
case(tc02,O,candidates,caries) :- common_tooth(Raw),select(obs(soft_tissue,unknown),Raw,T),A=[obs(soft_tissue,yes)|T],asymptomatic(B),combine(A,B,[obs(age_group,child),obs(dentition,permanent),obs(tooth_type,permanent),obs(root_maturity,unknown)],O).
case(tc03,O,candidates,caries) :- common_tooth(Raw),select(obs(soft_tissue,unknown),Raw,T),A=[obs(soft_tissue,yes)|T],asymptomatic(B),combine(A,B,[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,permanent),obs(root_maturity,mature),obs(thermal_response,brief)],O).
case(tc04,O,candidates,reversible_pulpitis) :- common_tooth(A),reversible(B),combine(A,B,[obs(age_group,child),obs(dentition,mixed),obs(tooth_type,primary),obs(triggers,[sweet])],O).
case(tc05,O,candidates,reversible_pulpitis) :- common_tooth(A),reversible(B),combine(A,B,[obs(age_group,adolescent),obs(dentition,permanent),obs(tooth_type,permanent),obs(root_maturity,immature),obs(triggers,[cold])],O).
case(tc06,O,candidates,reversible_pulpitis) :- common_tooth(A),reversible(B),combine(A,B,[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,permanent),obs(root_maturity,mature),obs(thermal_response,brief),obs(triggers,[cold,sweet])],O).
case(tc07,O,candidates,irreversible_pulpitis) :- common_tooth(A),irreversible(B),combine(A,B,[obs(age_group,child),obs(dentition,mixed),obs(tooth_type,primary),obs(triggers,unknown)],O).
case(tc08,O,candidates,irreversible_pulpitis) :- common_tooth(A),irreversible(B),combine(A,B,[obs(age_group,adolescent),obs(dentition,permanent),obs(tooth_type,permanent),obs(root_maturity,mature),obs(thermal_response,lingering),obs(triggers,[cold])],O).
case(tc09,O,candidates,irreversible_pulpitis) :- common_tooth(A),irreversible(B),combine(A,B,[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,permanent),obs(root_maturity,mature),obs(thermal_response,lingering),obs(triggers,[cold,hot])],O).
case(tc10,O,candidates,gingivitis) :- gums(A),combine(A,[],[obs(age_group,child),obs(dentition,mixed),obs(tooth_type,na),obs(region,general_gums),obs(bop_percent,30)],O).
case(tc11,O,candidates,gingivitis) :- gums(A),combine(A,[],[obs(age_group,adolescent),obs(dentition,permanent),obs(tooth_type,na),obs(region,general_gums),obs(bop_percent,40)],O).
case(tc12,O,candidates,gingivitis) :- gums(A),combine(A,[],[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,na),obs(region,anterior_gums),obs(bop_percent,35)],O).
periodontal([obs(dentition,permanent),obs(region,multiple_teeth),obs(tooth_type,permanent),obs(tooth_pain,no),obs(gum_symptoms,[bleeding,redness]),obs(plaque,yes),obs(nonadjacent_teeth,yes),obs(two_teeth,yes),obs(nonperiodontal_causes,no),obs(prior_destruction,unknown),obs(spontaneous,no),obs(sleep_pain,no),obs(biting_pain,no),obs(cavity,no),obs(percussion,no),obs(warning_signs,none)]).
case(tc13,O,candidates,periodontitis) :- periodontal(A),combine(A,[],[obs(age_group,adult),obs(cal_mm,4),obs(pocket_mm,6),obs(buccal_cal_mm,unknown)],O).
case(tc14,O,candidates,periodontitis) :- periodontal(A),combine(A,[],[obs(age_group,older_adult),obs(cal_mm,6),obs(pocket_mm,7),obs(buccal_cal_mm,unknown)],O).
case(tc15,[obs(tooth_pain,yes),obs(triggers,[cold]),obs(tooth_type,permanent)],incomplete,none).
case(tc16,[obs(age_group,-2)],invalid,none).
case(tc17,[obs(age_group,child),obs(tooth_pain,yes),obs(triggers,[cold]),obs(tooth_type,unknown),obs(warning_signs,none)],incomplete,none).
case(tc18,[obs(age_group,adult),obs(dentition,permanent),obs(tooth_type,permanent),obs(tooth_pain,no),obs(spontaneous,yes)],conflict,none).
case(tc19,[obs(age_group,adult),obs(dentition,permanent),obs(region,jaw_joint),obs(tooth_type,na),obs(warning_signs,none),obs(jaw_clicking,yes),obs(tooth_pain,no),obs(gum_symptoms,none)],outside_scope,none).
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
test(no_supported) :- assess([obs(age_group,adult),obs(tooth_pain,no),obs(cavity,no),obs(soft_tissue,no),obs(radiographic_caries,no),obs(gum_symptoms,none),obs(plaque,no),obs(cal_mm,0),obs(buccal_cal_mm,0)],result(no_supported_condition,[],[],_)).
test(reject_removed) :- forall(member(K,[tooth,second_tooth,pain_severity,symptom_duration,gum_tenderness,history,fracture,electric_response,mobility,bone_loss,gum_bleeding,red_gums,facial_swelling,drainage,fever]),assess([obs(K,unknown)],result(invalid,[],[K],_))).
test(age_groups) :- forall(member(A,[young_child,child,adolescent,adult,older_adult]),(assess([obs(age_group,A)],result(incomplete,[],M,_)),\+memberchk(age_group,M))).
test(missing_age_group) :- assess([],result(incomplete,[],[age_group],_)).
test(unknown_age_group) :- assess([obs(age_group,unknown)],result(incomplete,[],[age_group],_)).
test(reject_numeric_group) :- forall(member(A,[-2,16,20.5,121]),assess([obs(age_group,A)],result(invalid,[],[age_group],_))).
test(reject_group_atom) :- assess([obs(age_group,teenager)],result(invalid,[],[age_group],_)).
test(reject_legacy_age) :- assess([obs(age,16)],result(invalid,[],[age],_)).
test(reject_removed_focus) :- assess([obs(focus,tooth)],result(invalid,[],[focus],_)).
test(question_count) :- catalog(questions,Q),length(Q,30).
test(forward_missing) :- case(tc06,O,_,_),select(obs(persistence,brief),O,Rest),assess(Rest,result(candidates,C,M,_)),memberchk(caries,C),\+memberchk(reversible_pulpitis,C),memberchk(persistence,M).
test(known_negative_blocks_missing) :- case(tc06,O,_,_),select(obs(tooth_pain,yes),O,Rest),select(obs(persistence,brief),Rest,R2),assess([obs(tooth_pain,no)|R2],result(candidates,_,M,_)),\+memberchk(persistence,M).
test(na_does_not_satisfy) :- case(tc06,O,_,_),select(obs(persistence,brief),O,Rest),assess([obs(persistence,na)|Rest],result(candidates,C,M,_)),\+memberchk(reversible_pulpitis,C),memberchk(persistence,M).
test(pending_termination) :- case(tc06,O,_,_),select(obs(persistence,brief),O,Rest),call_with_time_limit(2,assess(Rest,_)).
test(age_does_not_choose_diagnosis) :- case(tc06,O,_,_),select(obs(age_group,adult),O,Rest),assess(O,R),forall(member(A,[young_child,child,adolescent,adult,older_adult]),assess([obs(age_group,A)|Rest],R)).
test(stage_counts) :- findall(K,(dental_questions:question(K,S,_,_,_,_),stage(S,setup)),A),length(A,4),findall(K,(dental_questions:question(K,S,_,_,_,_),stage(S,symptoms)),B),length(B,9),findall(K,(dental_questions:question(K,S,_,_,_,_),stage(S,findings)),C),length(C,17).
test(combined_unknown) :- expand_observations([obs(gum_symptoms,[bleeding]),obs(warning_signs,[swelling])],O),memberchk(obs(gum_bleeding,yes),O),memberchk(obs(red_gums,unknown),O),memberchk(obs(facial_swelling,yes),O),memberchk(obs(fever,unknown),O).
test(combined_none) :- expand_observations([obs(gum_symptoms,none),obs(warning_signs,none)],O),memberchk(obs(red_gums,no),O),memberchk(obs(fever,no),O).
test(combined_na) :- expand_observations([obs(gum_symptoms,na)],O),memberchk(obs(gum_bleeding,na),O).
test(combined_exclusive) :- forall(member(K,[gum_symptoms,warning_signs]),assess([obs(K,[none,unknown])],result(invalid,[],[K],_))).
test(symptom_routing) :- active_questions([],symptoms,A),length(A,4),\+memberchk(triggers,A),active_questions([obs(tooth_pain,yes)],symptoms,B),length(B,9).
test(soft_routing) :- active_questions([obs(cavity,no),obs(discoloration,no)],findings,A),\+memberchk(soft_tissue,A),active_questions([obs(cavity,unknown),obs(discoloration,no)],findings,B),memberchk(soft_tissue,B).
test(root_routing) :- active_questions([obs(tooth_pain,yes),obs(tooth_type,permanent),obs(root_maturity,mature)],findings,A),memberchk(thermal_response,A),memberchk(percussion,A),active_questions([obs(tooth_pain,no),obs(tooth_type,permanent),obs(root_maturity,mature)],findings,B),\+memberchk(root_maturity,B),\+memberchk(thermal_response,B),\+memberchk(percussion,B).
test(periodontal_routing) :- active_questions([obs(cal_mm,0),obs(buccal_cal_mm,0)],findings,A),\+memberchk(nonadjacent_teeth,A),\+memberchk(two_teeth,A),\+memberchk(nonperiodontal_causes,A),active_questions([obs(cal_mm,unknown),obs(buccal_cal_mm,na)],findings,B),memberchk(nonadjacent_teeth,B),memberchk(two_teeth,B),memberchk(nonperiodontal_causes,B).
test(scope_skips_findings) :- active_questions([obs(warning_signs,[fever])],findings,[]),case(tc19,O,_,_),active_questions(O,findings,[]).
test(parent_missing_first) :- assess([obs(age_group,adult),obs(tooth_type,permanent)],result(incomplete,[],M,_)),memberchk(tooth_pain,M),\+memberchk(triggers,M),\+memberchk(thermal_response,M).
test(symptom_free_caries) :- assess([obs(age_group,adult),obs(tooth_pain,no),obs(gum_symptoms,none),obs(radiographic_caries,yes)],result(candidates,C,_,_)),memberchk(caries,C).
test(periodontal_without_symptoms) :- assess([obs(age_group,adult),obs(tooth_pain,no),obs(gum_symptoms,none),obs(plaque,yes),obs(bop_percent,30),obs(cal_mm,0),obs(pocket_mm,3),obs(prior_destruction,no)],result(candidates,C,_,_)),memberchk(gingivitis,C).
test(question_specific_labels) :- forall(question(_,_,radio,_,Options,_),(\+memberchk(option(yes,'Yes'),Options),\+memberchk(option(no,'No'),Options))).
test(blocked_periodontal_followup) :- active_questions([obs(buccal_cal_mm,4),obs(cal_mm,0),obs(pocket_mm,3)],findings,A),\+memberchk(two_teeth,A),\+memberchk(nonperiodontal_causes,A).
test(scope_without_setup) :- assess([obs(warning_signs,[swelling])],result(outside_scope,[],[],_)).
test(routing_boundary,[throws(error(domain_error(consultation_input,tooth),_))]) :- active_questions([obs(tooth,16)],symptoms,_).
:- end_tests(engine).
