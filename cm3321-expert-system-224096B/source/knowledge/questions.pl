:- module(dental_questions, [question/6, valid_answer/2, expand_observations/2, stage/2, visible_question/2, request_key/3]).

% Shared UI schema. These records are not counted as domain facts.
question(age_group,setup,select,'Age group',[option(unknown,'Unknown'),option(young_child,'0-5 years'),option(child,'6-12 years'),option(adolescent,'13-17 years'),option(adult,'18-64 years'),option(older_adult,'65-120 years')],always).
question(tooth_type,setup,select,'Affected tooth type',[option('unknown','Unknown'),option('primary','Primary tooth'),option('permanent','Permanent tooth'),option('na','Not applicable')],always).
question(tooth_pain,symptoms,radio,'Is tooth pain present?',[option('unknown','Unknown'),option('yes','Tooth pain reported'),option('no','No tooth pain reported'),option('na','Not applicable')],always).
question(triggers,symptoms,multi,'What triggers the tooth pain?',[option('unknown','Unknown'),option('cold','Cold'),option('sweet','Sweet'),option('hot','Hot'),option('biting','Biting'),option('none','None'),option('na','Not applicable')],when(tooth_pain,yes)).
question(persistence,symptoms,select,'Pain after the trigger stops',[option('unknown','Unknown'),option('brief','Brief; stops promptly'),option('lingering','Lingering; continues'),option('episodic','Unprovoked episodes'),option('na','Not applicable')],when(tooth_pain,yes)).
question(spontaneous,symptoms,radio,'Spontaneous tooth pain?',[option('unknown','Unknown'),option('yes','Pain starts without a trigger'),option('no','No spontaneous pain'),option('na','Not applicable')],when(tooth_pain,yes)).
question(sleep_pain,symptoms,radio,'Tooth pain interrupts sleep?',[option('unknown','Unknown'),option('yes','Pain interrupts sleep'),option('no','No sleep interruption'),option('na','Not applicable')],when(tooth_pain,yes)).
question(gum_symptoms,symptoms,multi,'Gum symptoms',[option(unknown,'Unknown'),option(bleeding,'Bleeding when brushing or flossing'),option(redness,'Red or swollen gum margins'),option(none,'None reported'),option(na,'Not applicable')],always).
question(warning_signs,symptoms,multi,'Warning signs',[option(unknown,'Unknown'),option(swelling,'Facial swelling'),option(drainage,'Pus or drainage'),option(fever,'Fever reported'),option(none,'None reported'),option(na,'Not applicable')],always).
question(jaw_clicking,symptoms,radio,'Jaw clicking?',[option('unknown','Unknown'),option('yes','Jaw clicking reported'),option('no','No jaw clicking reported'),option('na','Not applicable')],always).
question(cavity,examination,radio,'Cavitated lesion observed?',[option('unknown','Unknown'),option('yes','Cavity observed'),option('no','No cavity observed'),option('na','Not applicable')],always).
question(soft_tissue,examination,radio,'Softened tooth tissue observed?',[option('unknown','Unknown'),option('yes','Softened tissue observed'),option('no','No softened tissue observed'),option('na','Not applicable')],soft_possible).
question(discoloration,examination,radio,'Decay-related surface discoloration?',[option('unknown','Unknown'),option('yes','Decay-related discoloration observed'),option('no','No decay-related discoloration'),option('na','Not applicable')],always).
question(root_maturity,examination,select,'Permanent root maturity',[option('unknown','Unknown'),option('immature','Immature'),option('mature','Mature'),option('na','Not applicable')],all([when(tooth_pain,yes),when(tooth_type,permanent)])).
question(thermal_response,examination,select,'Recorded thermal response',[option('unknown','Unknown'),option('brief','Brief response'),option('lingering','Exaggerated, lingering response'),option('absent','No response'),option('na','Not applicable')],all([when(tooth_pain,yes),when(tooth_type,permanent),when(root_maturity,mature)])).
question(percussion,examination,radio,'Percussion or palpation tenderness?',[option('unknown','Unknown'),option('yes','Tender to percussion or palpation'),option('no','Not tender'),option('na','Not applicable')],when(tooth_pain,yes)).
question(radiographic_caries,examination,radio,'Dentist-interpreted coronal carious lesion?',[option('unknown','Unknown'),option('yes','Coronal carious lesion observed'),option('no','No coronal carious lesion'),option('na','Not applicable')],always).
question(apical_pathology,examination,radio,'Apical/furcation pathology or pathological resorption?',[option('unknown','Unknown'),option('yes','Apical or furcation pathology observed'),option('no','No apical or furcation pathology'),option('na','Not applicable')],when(tooth_pain,yes)).
question(plaque,periodontal,radio,'Plaque or calculus present?',[option('unknown','Unknown'),option('yes','Plaque or calculus present'),option('no','No plaque or calculus'),option('na','Not applicable')],always).
question(prior_destruction,periodontal,radio,'Previous periodontal destruction?',[option('unknown','Unknown'),option('yes','Previous destruction documented'),option('no','No previous destruction documented'),option('na','Not applicable')],gingivitis_possible).
question(pocket_mm,periodontal,select,'Maximum probing depth',[option('unknown','Unknown'),option(0,'0 mm'),option(0.5,'0.5 mm'),option(1,'1 mm'),option(1.5,'1.5 mm'),option(2,'2 mm'),option(2.5,'2.5 mm'),option(3,'3 mm'),option(3.5,'3.5 mm'),option(4,'4 mm'),option(4.5,'4.5 mm'),option(5,'5 mm'),option(5.5,'5.5 mm'),option(6,'6 mm'),option(6.5,'6.5 mm'),option(7,'7 mm'),option(7.5,'7.5 mm'),option(8,'8 mm'),option(8.5,'8.5 mm'),option(9,'9 mm'),option(9.5,'9.5 mm'),option(10,'10 mm'),option(10.5,'10.5 mm'),option(11,'11 mm'),option(11.5,'11.5 mm'),option(12,'12 mm'),option(12.5,'12.5 mm'),option(13,'13 mm'),option(13.5,'13.5 mm'),option(14,'14 mm'),option(14.5,'14.5 mm'),option(15,'15 mm'),option('na','Not applicable')],always).
question(cal_mm,periodontal,select,'Maximum interdental attachment loss',[option('unknown','Unknown'),option(0,'0 mm'),option(0.5,'0.5 mm'),option(1,'1 mm'),option(1.5,'1.5 mm'),option(2,'2 mm'),option(2.5,'2.5 mm'),option(3,'3 mm'),option(3.5,'3.5 mm'),option(4,'4 mm'),option(4.5,'4.5 mm'),option(5,'5 mm'),option(5.5,'5.5 mm'),option(6,'6 mm'),option(6.5,'6.5 mm'),option(7,'7 mm'),option(7.5,'7.5 mm'),option(8,'8 mm'),option(8.5,'8.5 mm'),option(9,'9 mm'),option(9.5,'9.5 mm'),option(10,'10 mm'),option(10.5,'10.5 mm'),option(11,'11 mm'),option(11.5,'11.5 mm'),option(12,'12 mm'),option(12.5,'12.5 mm'),option(13,'13 mm'),option(13.5,'13.5 mm'),option(14,'14 mm'),option(14.5,'14.5 mm'),option(15,'15 mm'),option('na','Not applicable')],always).
question(buccal_cal_mm,periodontal,select,'Maximum buccal/oral attachment loss',[option('unknown','Unknown'),option(0,'0 mm'),option(0.5,'0.5 mm'),option(1,'1 mm'),option(1.5,'1.5 mm'),option(2,'2 mm'),option(2.5,'2.5 mm'),option(3,'3 mm'),option(3.5,'3.5 mm'),option(4,'4 mm'),option(4.5,'4.5 mm'),option(5,'5 mm'),option(5.5,'5.5 mm'),option(6,'6 mm'),option(6.5,'6.5 mm'),option(7,'7 mm'),option(7.5,'7.5 mm'),option(8,'8 mm'),option(8.5,'8.5 mm'),option(9,'9 mm'),option(9.5,'9.5 mm'),option(10,'10 mm'),option(10.5,'10.5 mm'),option(11,'11 mm'),option(11.5,'11.5 mm'),option(12,'12 mm'),option(12.5,'12.5 mm'),option(13,'13 mm'),option(13.5,'13.5 mm'),option(14,'14 mm'),option(14.5,'14.5 mm'),option(15,'15 mm'),option('na','Not applicable')],always).
question(bop_percent,periodontal,select,'Sites bleeding on probing',[option('unknown','Unknown'),option(0,'0%'),option(5,'5%'),option(10,'10%'),option(15,'15%'),option(20,'20%'),option(25,'25%'),option(30,'30%'),option(35,'35%'),option(40,'40%'),option(45,'45%'),option(50,'50%'),option(55,'55%'),option(60,'60%'),option(65,'65%'),option(70,'70%'),option(75,'75%'),option(80,'80%'),option(85,'85%'),option(90,'90%'),option(95,'95%'),option(100,'100%'),option('na','Not applicable')],always).
question(nonadjacent_teeth,periodontal,radio,'Interdental loss at two nonadjacent teeth?',[option('unknown','Unknown'),option('yes','Loss at two nonadjacent teeth'),option('no','Pattern not present'),option('na','Not applicable')],interdental_possible).
question(two_teeth,periodontal,radio,'Buccal/oral loss at two teeth?',[option('unknown','Unknown'),option('yes','Loss at two teeth'),option('no','Pattern not present'),option('na','Not applicable')],buccal_possible).
question(nonperiodontal_causes,periodontal,radio,'Could another local cause account for the attachment loss?',[option('unknown','Unknown'),option('yes','Alternative local cause identified'),option('no','Alternative local causes excluded'),option('na','Not applicable')],loss_possible).


valid_answer(Key, Value) :- question(Key,_,Type,_,Options,_), (Type == multi -> valid_multi(Value,Options) ; member(option(Allowed,_),Options), same_value(Value,Allowed)).
same_value(A,B) :- (number(A),number(B) -> A =:= B ; A == B).
valid_multi(Value,Options) :- memberchk(Value,[unknown,na,none]), member(option(Value,_),Options), !.
valid_multi(Value,Options) :- is_list(Value), Value \= [], sort(Value,Sorted), length(Value,N),length(Sorted,N), forall(member(V,Value),(atom(V),\+ memberchk(V,[unknown,na,none]),memberchk(option(V,_),Options))).
% Public checkbox choices expand only after public-schema validation.
expand_observations(Obs,Expanded) :-
    findall(obs(Key,V),(checkbox_item(Group,Item,Key),value(Obs,Group,Selection),selection_value(Selection,Item,V)),Extras),
    append(Obs,Extras,Expanded).
checkbox_item(triggers,cold,trigger_cold).
checkbox_item(triggers,sweet,trigger_sweet).
checkbox_item(triggers,hot,trigger_hot).
checkbox_item(gum_symptoms,bleeding,gum_bleeding).
checkbox_item(gum_symptoms,redness,red_gums).
checkbox_item(warning_signs,swelling,facial_swelling).
checkbox_item(warning_signs,drainage,drainage).
checkbox_item(warning_signs,fever,fever).
selection_value(none,_,no) :- !.
selection_value(na,_,na) :- !.
selection_value(List,Item,yes) :- is_list(List),memberchk(Item,List),!.
selection_value(_,_,unknown).

% Routing metadata is not domain knowledge and does not filter diagnoses.
stage(setup,setup).
stage(symptoms,symptoms).
stage(examination,findings).
stage(periodontal,findings).
value(Obs,K,V) :- (memberchk(obs(K,A),Obs) -> V=A ; V=unknown).
uncertain(V) :- memberchk(V,[unknown,na]).
possible_above(Obs,K,Threshold) :- value(Obs,K,V),(uncertain(V);number(V),V>Threshold).
visible_question(Obs,K) :- question(K,_,_,_,_,Condition),visible(Condition,Obs).
visible(always,_).
visible(when(K,V),Obs) :- value(Obs,K,V).
visible(all(Conditions),Obs) :- forall(member(C,Conditions),visible(C,Obs)).
visible(soft_possible,Obs) :- \+ (value(Obs,cavity,no),value(Obs,discoloration,no)).
visible(interdental_possible,Obs) :- possible_above(Obs,cal_mm,0).
visible(buccal_possible,Obs) :- possible_above(Obs,buccal_cal_mm,2.5),possible_above(Obs,pocket_mm,3).
visible(loss_possible,Obs) :- (visible(interdental_possible,Obs);visible(buccal_possible,Obs)).
visible(gingivitis_possible,Obs) :-
    \+ value(Obs,plaque,no),value(Obs,cal_mm,C),(uncertain(C);number(C),C=:=0),
    value(Obs,pocket_mm,P),(uncertain(P);number(P),P=<3),
    (\+ value(Obs,gum_symptoms,none);possible_above(Obs,bop_percent,5)).

% Ask an unanswered gate before its hidden descendants. This is UI dependency
% routing; the inference engine still scans all production rules forward.
request_key(Obs,K,Request) :-
    (checkbox_item(Group,_,K) -> Public=Group ; Public=K),
    (question(Public,_,_,_,_,Condition),missing_gate(Condition,Obs,Gate) -> Request=Gate ; Request=Public).
missing_gate(when(K,_),Obs,K) :- value(Obs,K,V),uncertain(V).
missing_gate(all(Conditions),Obs,K) :- member(C,Conditions),missing_gate(C,Obs,K),!.
