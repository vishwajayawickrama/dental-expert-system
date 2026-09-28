:- module(dental_domain, [domain_fact/5, rule/5, condition/2, source/3, knowledge_version/1]).
knowledge_version('0.1.0').
source(nidcr, 'NIDCR: Tooth decay', 'https://www.nidcr.nih.gov/health-info/tooth-decay').
source(aae, 'AAE: Diagnostic terminology', 'https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf').
source(aapd, 'AAPD: Pediatric pulp diagnosis', 'https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf').
source(aap, 'AAP: Gum disease information', 'https://www.perio.org/for-patients/gum-disease-information/').
source(efp, 'EFP: Periodontitis case definition', 'https://www.efp.org/fileadmin/uploads/efp/Documents/Campaigns/New_Classification/Guidance_Notes/report-02.pdf').
source(efp_g, 'EFP: Periodontal health and gingival diseases consensus', 'https://www.efp.org/fileadmin/uploads/efp/Documents/Campaigns/New_Classification/Reports/Consensus_report__Workgroup_1__Chapple_et_al-2018-Journal_of_Clinical_Periodontology.pdf').
condition(caries, 'Dental caries').
condition(reversible_pulpitis, 'Reversible pulpitis').
condition(irreversible_pulpitis, 'Symptomatic irreversible pulpitis').
condition(gingivitis, 'Gingivitis').
condition(periodontitis, 'Periodontitis').

% Thirty reusable clinical statements. IDs, labels, questions and observations
% are metadata, not additional domain facts. All require dentist review.
domain_fact(f01, affected_tissue(caries, mineralized_tooth), 'Caries damages mineralized tooth tissue.', nidcr, pending).
domain_fact(f02, may_be_asymptomatic(caries), 'Early caries may have no pain.', nidcr, pending).
domain_fact(f03, supports(cavitation, caries), 'A cavity supports a caries assessment.', nidcr, pending).
domain_fact(f04, supports(softened_tissue, caries), 'Softened tooth tissue supports a caries assessment.', nidcr, pending).
domain_fact(f05, supports(radiographic_lesion, caries), 'A dentist-interpreted radiographic lesion can support caries.', nidcr, pending).
domain_fact(f06, supports(discoloration, caries), 'White, brown or dark surface changes may accompany decay.', nidcr, pending).
domain_fact(f07, applicable_dentition(caries, both), 'Caries can occur in primary and permanent teeth.', nidcr, pending).
domain_fact(f08, affected_tissue(reversible_pulpitis, vital_pulp), 'Reversible pulpitis affects vital inflamed pulp.', aae, pending).
domain_fact(f09, pain_pattern(reversible_pulpitis, brief_provoked), 'Brief provoked pain can support reversible pulpitis.', aapd, pending).
domain_fact(f10, contradicts(spontaneous_pain, reversible_pattern), 'Spontaneous pain conflicts with this reversible-pulpitis pattern.', aapd, pending).
domain_fact(f11, supports(spontaneous_pain, irreversible_pulpitis), 'Spontaneous pain can support symptomatic irreversible pulpitis.', aae, pending).
domain_fact(f12, supports(lingering_pain, irreversible_pulpitis), 'Lingering thermal pain can support symptomatic irreversible pulpitis.', aae, pending).
domain_fact(f13, affected_tissue(irreversible_pulpitis, vital_pulp), 'Irreversible pulpitis terminology refers to inflamed vital pulp.', aae, pending).
domain_fact(f14, unreliable_pulp_test(primary), 'Thermal and electric pulp tests are unreliable in primary teeth.', aapd, pending).
domain_fact(f15, unreliable_pulp_test(immature), 'Thermal and electric pulp tests are unreliable in immature permanent teeth.', aapd, pending).
domain_fact(f16, overlapping_primary_findings(irreversible_pulpitis, necrosis), 'Primary-tooth symptoms may not distinguish irreversible pulpitis from necrosis.', aapd, pending).
domain_fact(f17, pulpal_trigger(cold), 'Cold can provoke pulpal discomfort.', aae, pending).
domain_fact(f18, pulpal_trigger(sweet), 'Sweet stimuli can provoke discomfort in decay-related presentations.', nidcr, pending).
domain_fact(f19, pulpal_trigger(hot), 'Heat can provoke pulpal discomfort.', aae, pending).
domain_fact(f20, affected_tissue(gingivitis, gingiva), 'Gingivitis concerns gingival inflammation.', aap, pending).
domain_fact(f21, associated(plaque, gingival_inflammation), 'Plaque is associated with gingival inflammation.', aap, pending).
domain_fact(f22, supports(red_swollen_gums, gingival_inflammation), 'Red or swollen gums support gingival inflammation.', aap, pending).
domain_fact(f23, supports(gum_bleeding, gingival_inflammation), 'Gum bleeding supports gingival inflammation.', aap, pending).
domain_fact(f24, intact_periodontium(gingivitis, 0), 'Gingivitis on an intact periodontium has no attachment loss.', efp_g, pending).
domain_fact(f25, prior_destruction_changes_assessment, 'Previous periodontal destruction changes assessment of gingival inflammation.', efp_g, pending).
domain_fact(f26, defining_feature(periodontitis, support_loss), 'Periodontitis involves loss of tooth-supporting tissue.', efp, pending).
domain_fact(f27, interdental_case_teeth(2), 'Interdental attachment loss at two nonadjacent teeth supports the case definition.', efp, pending).
domain_fact(f28, buccal_cal_threshold(3), 'The alternative case definition uses buccal/oral attachment loss of at least 3 mm.', efp, pending).
domain_fact(f29, buccal_pocket_threshold(3), 'The alternative definition also requires pocket depth greater than 3 mm.', efp, pending).
domain_fact(f30, exclude_nonperiodontal_causes, 'Attachment loss from nonperiodontal causes must be excluded.', efp, pending).

% Twenty-five production rules. They derive intermediate clinical patterns and
% candidate conditions; they never prescribe treatment or establish certainty.
rule(r01, [eq(cavity,yes),eq(soft_tissue,yes)], carious_lesion, nidcr, pending).
rule(r02, [eq(radiographic_caries,yes)], carious_lesion, nidcr, pending).
rule(r03, [eq(discoloration,yes),eq(soft_tissue,yes)], carious_lesion, nidcr, pending).
rule(r04, [derived(carious_lesion),kb(applicable_dentition(caries,both))], candidate(caries), nidcr, pending).
rule(r05, [eq(tooth_pain,yes),eq(trigger_cold,yes),kb(pulpal_trigger(cold))], provoked_pain, aae, pending).
rule(r06, [eq(tooth_pain,yes),eq(trigger_sweet,yes),kb(pulpal_trigger(sweet))], provoked_pain, nidcr, pending).
rule(r07, [eq(tooth_pain,yes),eq(trigger_hot,yes),kb(pulpal_trigger(hot))], provoked_pain, aae, pending).
rule(r08, [derived(provoked_pain),eq(persistence,brief)], brief_provoked_pain, aapd, pending).
rule(r09, [derived(brief_provoked_pain),derived(carious_lesion),eq(spontaneous,no),eq(sleep_pain,no),eq(percussion,no),eq(apical_pathology,no),eq(facial_swelling,no),eq(drainage,no),eq(fever,no)], reversible_pattern, aapd, pending).
rule(r10, [derived(reversible_pattern),eq(tooth_type,primary),kb(unreliable_pulp_test(primary))], candidate(reversible_pulpitis), aapd, pending).
rule(r11, [derived(reversible_pattern),eq(tooth_type,permanent),eq(root_maturity,immature),kb(unreliable_pulp_test(immature))], candidate(reversible_pulpitis), aapd, pending).
rule(r12, [derived(reversible_pattern),eq(tooth_type,permanent),eq(root_maturity,mature),eq(thermal_response,brief)], candidate(reversible_pulpitis), aae, pending).
rule(r13, [eq(tooth_pain,yes),eq(spontaneous,yes),kb(supports(spontaneous_pain,irreversible_pulpitis))], irreversible_pattern, aae, pending).
rule(r14, [derived(provoked_pain),eq(persistence,lingering),kb(supports(lingering_pain,irreversible_pulpitis))], irreversible_pattern, aae, pending).
rule(r15, [derived(irreversible_pattern),derived(carious_lesion),eq(tooth_type,primary),eq(sleep_pain,yes)], candidate(irreversible_pulpitis), aapd, pending).
rule(r16, [derived(irreversible_pattern),derived(carious_lesion),eq(tooth_type,permanent),eq(root_maturity,mature),eq(thermal_response,lingering)], candidate(irreversible_pulpitis), aae, pending).
rule(r17, [derived(irreversible_pattern),derived(carious_lesion),eq(tooth_type,permanent),eq(root_maturity,immature),eq(sleep_pain,yes)], candidate(irreversible_pulpitis), aapd, pending).
rule(r18, [eq(gum_bleeding,yes),eq(plaque,yes)], gingival_inflammation, aap, pending).
rule(r19, [eq(red_gums,yes),eq(plaque,yes)], gingival_inflammation, aap, pending).
rule(r20, [derived(gingival_inflammation),eq(cal_mm,0),eq(prior_destruction,no),lte(pocket_mm,3),kb(intact_periodontium(gingivitis,0))], candidate(gingivitis), efp_g, pending).
rule(r21, [gt(cal_mm,0),eq(nonadjacent_teeth,yes),eq(nonperiodontal_causes,no),kb(exclude_nonperiodontal_causes)], periodontal_destruction, efp, pending).
rule(r22, [gte(buccal_cal_mm,3),derived(deep_pocket),eq(two_teeth,yes),eq(nonperiodontal_causes,no)], periodontal_destruction, efp, pending).
rule(r23, [derived(periodontal_destruction),kb(defining_feature(periodontitis,support_loss))], candidate(periodontitis), efp, pending).
rule(r24, [gt(pocket_mm,3),kb(buccal_pocket_threshold(3))], deep_pocket, efp, pending).
rule(r25, [gte(bop_percent,10),eq(plaque,yes)], gingival_inflammation, efp_g, pending).
