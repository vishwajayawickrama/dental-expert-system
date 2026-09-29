# DentalExplain: 20 acceptance test cases

**Status:** Implemented and executed against knowledge v0.3.0 using SWI-Prolog and the Java/JPL bridge. All 20 cases passed the software assertions using forward chaining. Clinical expectations remain **Pending dentist review**; software passes do not establish clinical accuracy.

These are synthetic cases, not real patient records. They cover 14 diagnostic presentations and 6 input/lifecycle edge cases. The [proposal](project-proposal.md) defines the scope; the [architecture](architecture.md) defines Java Swing, JPL, and SWI-Prolog integration.

Appendix D of the [submission report](report/DentalExplain%20Report.pdf) lists every supplied fixture input and the reassessed actual software response for all 20 cases.

## Controlled inputs and execution

Setup has four fields, followed by **Reported symptoms (step 1)** and **Relevant dental findings (step 2)**. The 30-question shared catalogue contains 4 setup, 9 symptom and 17 examination questions. Tables below use actual predefined choices and stable mappings from `questions.pl` and the synthetic fixtures in `acceptance.pl`. Unspecified active questions default to Unknown. Inactive questions are not asked, are cleared to Unknown and are excluded from assessment. Exact ages in scenario titles describe the original synthetic examples; only age group is submitted. FDI numbers and unused history, severity and duration information are no longer inputs.

Positive and negative answer labels are specific to each question. Unknown is unavailable information; Not applicable is unusable for a required premise. Neither becomes a negative answer. Gum symptoms and Warning signs are combined checkbox questions. Selected findings are present; unchecked findings stay Unknown. None reported explicitly records absence of all listed findings. None, Unknown and Not applicable are exclusive with substantive selections. Trigger checkboxes use the same convention.

For TC01–TC14 enter setup, complete step 1, then supply the applicable step-2 findings and assess with forward chaining. Every expected target must remain present, with permitted coexisting candidates and no prohibited candidate. The Java tests also assess all 14 after Prolog routing removes inactive inputs. This verifies the adaptive flow preserves the diagnostic targets rather than filtering conditions by symptoms.

TC16 sends `obs(age_group,-2)` directly to the validation boundary; the UI cannot enter it. TC18 submits contradictory pain observations directly; the UI hides and clears spontaneous pain when tooth pain is absent. TC20 combines TC11 → blank engine assessment with Swing reset and delayed-callback tests. The native walkthrough separately checks both steps, displayed results and reset. All clinical expectations remain pending qualified-dentist review; these are synthetic software cases, not patient records.

Clinical measurements use the supplied maximum: probing/attachment loss 0–15 mm in 0.5 mm steps; bleeding on probing 0–100% in 5% steps. Values and age bands are case data, not arbitrary diagnostic thresholds. Dentition and root maturity are supplied independently of age. No diagnosis is entered as an answer. Per-case source links support the proposed patterns but do not approve the software's clinical combinations.

## Catalogue

| ID | Presentation | Expected response |
| --- | --- | --- |
| [TC01](#tc01) | Caries in a primary molar, age 6 | Candidate dental caries |
| [TC02](#tc02) | Caries in an adolescent permanent molar, age 12 | Candidate dental caries |
| [TC03](#tc03) | Caries in an adult permanent molar, age 35 | Candidate dental caries |
| [TC04](#tc04) | Reversible pulpitis candidate in a primary tooth, age 8 | Candidate reversible pulpitis |
| [TC05](#tc05) | Reversible pulpitis candidate in an immature permanent tooth, age 14 | Candidate reversible pulpitis |
| [TC06](#tc06) | Reversible pulpitis candidate in an adult tooth, age 42 | Candidate reversible pulpitis |
| [TC07](#tc07) | Symptomatic irreversible pulpitis candidate in a primary tooth, age 9 | Candidate symptomatic irreversible pulpitis |
| [TC08](#tc08) | Symptomatic irreversible pulpitis candidate in an adolescent tooth, age 17 | Candidate symptomatic irreversible pulpitis |
| [TC09](#tc09) | Symptomatic irreversible pulpitis candidate in an adult tooth, age 50 | Candidate symptomatic irreversible pulpitis |
| [TC10](#tc10) | Gingivitis candidate in mixed dentition, age 10 | Candidate gingivitis |
| [TC11](#tc11) | Gingivitis candidate in an adolescent, age 16 | Candidate gingivitis |
| [TC12](#tc12) | Gingivitis candidate in an adult, age 45 | Candidate gingivitis |
| [TC13](#tc13) | Periodontitis candidate in an adult, age 38 | Candidate periodontitis |
| [TC14](#tc14) | Periodontitis candidate in an older adult, age 68 | Candidate periodontitis |
| [TC15](#tc15) | Missing age group | Please select age group before completing the assessment. |
| [TC16](#tc16) | Invalid numeric age-group value | Age group must be a listed predefined value. Please correct it. |
| [TC17](#tc17) | Required dentition and examination information unavailable | Please provide the affected tooth type and available dental examination findings. Assessment incomplete. |
| [TC18](#tc18) | Contradictory tooth-pain answers | Your tooth-pain answers conflict. Please clarify whether tooth pain is present. |
| [TC19](#tc19) | Jaw clicking outside the supported presentation scope | This presentation is outside the supported tooth-pain and gum-symptom scope. No supported dental conclusion. |
| [TC20](#tc20) | Reset after a completed consultation | Please select age group and start a new consultation. No previous candidate or input remains. |

## Diagnostic cases

<a id="tc01"></a>

### TC01 — Caries in a primary molar

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 6-12 years (`child`) |
| Dentition (`dentition`) | Setup | Mixed (`mixed`) |
| Affected tooth type (`tooth_type`) | Setup | Primary tooth (`primary`) |
| Affected region (`region`) | Setup | Single tooth (`single_tooth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | No tooth pain reported (`no`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Not asked; cleared to Unknown |
| Pain after the trigger stops (`persistence`) | Step 1 | Not asked; cleared to Unknown |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Not asked; cleared to Unknown |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Not asked; cleared to Unknown |
| Pain when biting? (`biting_pain`) | Step 1 | Not asked; cleared to Unknown |
| Gum symptoms (`gum_symptoms`) | Step 1 | None reported (`none`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | Cavity observed (`yes`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Softened tissue observed (`yes`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not asked; cleared to Unknown |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Coronal carious lesion observed (`yes`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | Not asked; cleared to Unknown |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 0% (`0`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate dental caries.

**Prohibited outcomes:** Returning pulpitis or periodontitis as supported by these recorded inputs; excluding caries because pain is absent.

**Sources:** [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay); [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate dental caries |
| Pass / fail | **PASS — software** |

<a id="tc02"></a>

### TC02 — Caries in an adolescent permanent molar

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 6-12 years (`child`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Permanent tooth (`permanent`) |
| Affected region (`region`) | Setup | Single tooth (`single_tooth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | No tooth pain reported (`no`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Not asked; cleared to Unknown |
| Pain after the trigger stops (`persistence`) | Step 1 | Not asked; cleared to Unknown |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Not asked; cleared to Unknown |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Not asked; cleared to Unknown |
| Pain when biting? (`biting_pain`) | Step 1 | Not asked; cleared to Unknown |
| Gum symptoms (`gum_symptoms`) | Step 1 | None reported (`none`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | Cavity observed (`yes`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Softened tissue observed (`yes`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not asked; cleared to Unknown |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Coronal carious lesion observed (`yes`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | Not asked; cleared to Unknown |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 0% (`0`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate dental caries.

**Prohibited outcomes:** Returning pulpitis or periodontitis as supported by these recorded inputs; excluding caries because pain is absent.

**Sources:** [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay); [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate dental caries |
| Pass / fail | **PASS — software** |

<a id="tc03"></a>

### TC03 — Caries in an adult permanent molar

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 18-64 years (`adult`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Permanent tooth (`permanent`) |
| Affected region (`region`) | Setup | Single tooth (`single_tooth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | No tooth pain reported (`no`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Not asked; cleared to Unknown |
| Pain after the trigger stops (`persistence`) | Step 1 | Not asked; cleared to Unknown |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Not asked; cleared to Unknown |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Not asked; cleared to Unknown |
| Pain when biting? (`biting_pain`) | Step 1 | Not asked; cleared to Unknown |
| Gum symptoms (`gum_symptoms`) | Step 1 | None reported (`none`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | Cavity observed (`yes`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Softened tissue observed (`yes`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not asked; cleared to Unknown |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Coronal carious lesion observed (`yes`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | Not asked; cleared to Unknown |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 0% (`0`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate dental caries.

**Prohibited outcomes:** Returning pulpitis or periodontitis as supported by these recorded inputs; excluding caries because pain is absent.

**Sources:** [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay); [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate dental caries |
| Pass / fail | **PASS — software** |

<a id="tc04"></a>

### TC04 — Reversible pulpitis candidate in a primary tooth

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 6-12 years (`child`) |
| Dentition (`dentition`) | Setup | Mixed (`mixed`) |
| Affected tooth type (`tooth_type`) | Setup | Primary tooth (`primary`) |
| Affected region (`region`) | Setup | Single tooth (`single_tooth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | Tooth pain reported (`yes`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Sweet (`[sweet]`) |
| Pain after the trigger stops (`persistence`) | Step 1 | Brief; stops promptly (`brief`) |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | No spontaneous pain (`no`) |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | No sleep interruption (`no`) |
| Pain when biting? (`biting_pain`) | Step 1 | No pain on biting (`no`) |
| Gum symptoms (`gum_symptoms`) | Step 1 | None reported (`none`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | Cavity observed (`yes`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not tender (`no`) |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Coronal carious lesion observed (`yes`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | No apical or furcation pathology (`no`) |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 0% (`0`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate reversible pulpitis.

**Prohibited outcomes:** Returning symptomatic irreversible pulpitis as supported by these inputs; treating this as confirmed pulp status.

**Sources:** [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf); [AAPD: Vital pulp diagnosis in primary teeth](https://www.aapd.org/research/oral-health-policies--recommendations/vital_pulp_therapies_in_primary_teeth_with_deep_caries_lesions/). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and reversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc05"></a>

### TC05 — Reversible pulpitis candidate in an immature permanent tooth

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 13-17 years (`adolescent`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Permanent tooth (`permanent`) |
| Affected region (`region`) | Setup | Single tooth (`single_tooth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | Tooth pain reported (`yes`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Cold (`[cold]`) |
| Pain after the trigger stops (`persistence`) | Step 1 | Brief; stops promptly (`brief`) |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | No spontaneous pain (`no`) |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | No sleep interruption (`no`) |
| Pain when biting? (`biting_pain`) | Step 1 | No pain on biting (`no`) |
| Gum symptoms (`gum_symptoms`) | Step 1 | None reported (`none`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | Cavity observed (`yes`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Immature (`immature`) |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not tender (`no`) |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Coronal carious lesion observed (`yes`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | No apical or furcation pathology (`no`) |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 0% (`0`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate reversible pulpitis.

**Prohibited outcomes:** Returning symptomatic irreversible pulpitis as supported by these inputs; treating this as confirmed pulp status.

**Sources:** [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf); [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and reversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc06"></a>

### TC06 — Reversible pulpitis candidate in an adult tooth

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 18-64 years (`adult`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Permanent tooth (`permanent`) |
| Affected region (`region`) | Setup | Single tooth (`single_tooth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | Tooth pain reported (`yes`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Cold; Sweet (`[cold,sweet]`) |
| Pain after the trigger stops (`persistence`) | Step 1 | Brief; stops promptly (`brief`) |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | No spontaneous pain (`no`) |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | No sleep interruption (`no`) |
| Pain when biting? (`biting_pain`) | Step 1 | No pain on biting (`no`) |
| Gum symptoms (`gum_symptoms`) | Step 1 | None reported (`none`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | Cavity observed (`yes`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Mature (`mature`) |
| Recorded thermal response (`thermal_response`) | Step 2 | Brief response (`brief`) |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not tender (`no`) |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Coronal carious lesion observed (`yes`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | No apical or furcation pathology (`no`) |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 0% (`0`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate reversible pulpitis.

**Prohibited outcomes:** Returning symptomatic irreversible pulpitis as supported by these inputs; treating this as confirmed pulp status.

**Sources:** [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf); [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and reversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc07"></a>

### TC07 — Symptomatic irreversible pulpitis candidate in a primary tooth

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 6-12 years (`child`) |
| Dentition (`dentition`) | Setup | Mixed (`mixed`) |
| Affected tooth type (`tooth_type`) | Setup | Primary tooth (`primary`) |
| Affected region (`region`) | Setup | Single tooth (`single_tooth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | Tooth pain reported (`yes`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Unknown (`unknown`) |
| Pain after the trigger stops (`persistence`) | Step 1 | Lingering; continues (`lingering`) |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Pain starts without a trigger (`yes`) |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Pain interrupts sleep (`yes`) |
| Pain when biting? (`biting_pain`) | Step 1 | No pain on biting (`no`) |
| Gum symptoms (`gum_symptoms`) | Step 1 | None reported (`none`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | Cavity observed (`yes`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not tender (`no`) |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Coronal carious lesion observed (`yes`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | No apical or furcation pathology (`no`) |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 0% (`0`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate symptomatic irreversible pulpitis.

**Prohibited outcomes:** Returning only reversible pulpitis or classifying the result as confirmed; ignoring spontaneous/persistent pain.

**Case limitation:** Primary-tooth findings may overlap with necrosis. The expected label is provisional candidate support, not proof that necrosis is excluded; additional clinical assessment may be requested.

**Sources:** [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf); [AAPD: Vital pulp diagnosis in primary teeth](https://www.aapd.org/research/oral-health-policies--recommendations/vital_pulp_therapies_in_primary_teeth_with_deep_caries_lesions/). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and symptomatic irreversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc08"></a>

### TC08 — Symptomatic irreversible pulpitis candidate in an adolescent tooth

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 13-17 years (`adolescent`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Permanent tooth (`permanent`) |
| Affected region (`region`) | Setup | Single tooth (`single_tooth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | Tooth pain reported (`yes`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Cold (`[cold]`) |
| Pain after the trigger stops (`persistence`) | Step 1 | Lingering; continues (`lingering`) |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Pain starts without a trigger (`yes`) |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Pain interrupts sleep (`yes`) |
| Pain when biting? (`biting_pain`) | Step 1 | No pain on biting (`no`) |
| Gum symptoms (`gum_symptoms`) | Step 1 | None reported (`none`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | Cavity observed (`yes`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Mature (`mature`) |
| Recorded thermal response (`thermal_response`) | Step 2 | Exaggerated, lingering response (`lingering`) |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not tender (`no`) |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Coronal carious lesion observed (`yes`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | No apical or furcation pathology (`no`) |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 0% (`0`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate symptomatic irreversible pulpitis.

**Prohibited outcomes:** Returning only reversible pulpitis or classifying the result as confirmed; ignoring spontaneous/persistent pain.

**Sources:** [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf); [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and symptomatic irreversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc09"></a>

### TC09 — Symptomatic irreversible pulpitis candidate in an adult tooth

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 18-64 years (`adult`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Permanent tooth (`permanent`) |
| Affected region (`region`) | Setup | Single tooth (`single_tooth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | Tooth pain reported (`yes`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Cold; Hot (`[cold,hot]`) |
| Pain after the trigger stops (`persistence`) | Step 1 | Lingering; continues (`lingering`) |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Pain starts without a trigger (`yes`) |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Pain interrupts sleep (`yes`) |
| Pain when biting? (`biting_pain`) | Step 1 | No pain on biting (`no`) |
| Gum symptoms (`gum_symptoms`) | Step 1 | None reported (`none`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | Cavity observed (`yes`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Mature (`mature`) |
| Recorded thermal response (`thermal_response`) | Step 2 | Exaggerated, lingering response (`lingering`) |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not tender (`no`) |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Coronal carious lesion observed (`yes`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | No apical or furcation pathology (`no`) |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 0% (`0`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate symptomatic irreversible pulpitis.

**Prohibited outcomes:** Returning only reversible pulpitis or classifying the result as confirmed; ignoring spontaneous/persistent pain.

**Sources:** [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf); [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and symptomatic irreversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc10"></a>

### TC10 — Gingivitis candidate in mixed dentition

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 6-12 years (`child`) |
| Dentition (`dentition`) | Setup | Mixed (`mixed`) |
| Affected tooth type (`tooth_type`) | Setup | Not applicable (`na`) |
| Affected region (`region`) | Setup | Generalized gums (`general_gums`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | No tooth pain reported (`no`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Not asked; cleared to Unknown |
| Pain after the trigger stops (`persistence`) | Step 1 | Not asked; cleared to Unknown |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Not asked; cleared to Unknown |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Not asked; cleared to Unknown |
| Pain when biting? (`biting_pain`) | Step 1 | Not asked; cleared to Unknown |
| Gum symptoms (`gum_symptoms`) | Step 1 | Bleeding when brushing or flossing; Red or swollen gum margins (`[bleeding,redness]`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | No cavity observed (`no`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not asked; cleared to Unknown |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Unknown (`unknown`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | Not asked; cleared to Unknown |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | No previous destruction documented (`no`) |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 30% (`30`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate gingivitis.

**Prohibited outcomes:** Returning periodontitis without supplied evidence of periodontal destruction; inferring attachment loss from bleeding alone.

**Sources:** [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate gingivitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

<a id="tc11"></a>

### TC11 — Gingivitis candidate in an adolescent

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 13-17 years (`adolescent`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Not applicable (`na`) |
| Affected region (`region`) | Setup | Generalized gums (`general_gums`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | No tooth pain reported (`no`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Not asked; cleared to Unknown |
| Pain after the trigger stops (`persistence`) | Step 1 | Not asked; cleared to Unknown |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Not asked; cleared to Unknown |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Not asked; cleared to Unknown |
| Pain when biting? (`biting_pain`) | Step 1 | Not asked; cleared to Unknown |
| Gum symptoms (`gum_symptoms`) | Step 1 | Bleeding when brushing or flossing; Red or swollen gum margins (`[bleeding,redness]`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | No cavity observed (`no`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not asked; cleared to Unknown |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Unknown (`unknown`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | Not asked; cleared to Unknown |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | No previous destruction documented (`no`) |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 40% (`40`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate gingivitis.

**Prohibited outcomes:** Returning periodontitis without supplied evidence of periodontal destruction; inferring attachment loss from bleeding alone.

**Sources:** [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate gingivitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

<a id="tc12"></a>

### TC12 — Gingivitis candidate in an adult

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 18-64 years (`adult`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Not applicable (`na`) |
| Affected region (`region`) | Setup | Anterior gums (`anterior_gums`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | No tooth pain reported (`no`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Not asked; cleared to Unknown |
| Pain after the trigger stops (`persistence`) | Step 1 | Not asked; cleared to Unknown |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Not asked; cleared to Unknown |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Not asked; cleared to Unknown |
| Pain when biting? (`biting_pain`) | Step 1 | Not asked; cleared to Unknown |
| Gum symptoms (`gum_symptoms`) | Step 1 | Bleeding when brushing or flossing; Red or swollen gum margins (`[bleeding,redness]`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | No cavity observed (`no`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not asked; cleared to Unknown |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Unknown (`unknown`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | Not asked; cleared to Unknown |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | No previous destruction documented (`no`) |
| Maximum probing depth (`pocket_mm`) | Step 2 | 3 mm (`3`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 0 mm (`0`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | 35% (`35`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Not asked; cleared to Unknown |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Not asked; cleared to Unknown |

**Expected response:** Candidate gingivitis.

**Prohibited outcomes:** Returning periodontitis without supplied evidence of periodontal destruction; inferring attachment loss from bleeding alone.

**Sources:** [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate gingivitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

<a id="tc13"></a>

### TC13 — Periodontitis candidate in an adult

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 18-64 years (`adult`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Permanent tooth (`permanent`) |
| Affected region (`region`) | Setup | Multiple teeth (`multiple_teeth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | No tooth pain reported (`no`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Not asked; cleared to Unknown |
| Pain after the trigger stops (`persistence`) | Step 1 | Not asked; cleared to Unknown |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Not asked; cleared to Unknown |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Not asked; cleared to Unknown |
| Pain when biting? (`biting_pain`) | Step 1 | Not asked; cleared to Unknown |
| Gum symptoms (`gum_symptoms`) | Step 1 | Bleeding when brushing or flossing; Red or swollen gum margins (`[bleeding,redness]`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | No cavity observed (`no`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not asked; cleared to Unknown |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Unknown (`unknown`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | Not asked; cleared to Unknown |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 6 mm (`6`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 4 mm (`4`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | Unknown (`unknown`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Loss at two nonadjacent teeth (`yes`) |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Loss at two teeth (`yes`) |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Alternative local causes excluded (`no`) |

**Expected response:** Candidate periodontitis.

**Prohibited outcomes:** Returning only gingivitis, deriving periodontitis from age alone, or assigning an unsupported stage/grade.

**Sources:** [AAP: Periodontitis assessment](https://www.perio.org/wp-content/uploads/2019/08/Staging-and-Grading-Periodontitis.pdf); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease); [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate periodontitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

<a id="tc14"></a>

### TC14 — Periodontitis candidate in an older adult

| Question / identifier | Stage | Controlled test answer |
| --- | --- | --- |
| Age group (`age_group`) | Setup | 65-120 years (`older_adult`) |
| Dentition (`dentition`) | Setup | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Setup | Permanent tooth (`permanent`) |
| Affected region (`region`) | Setup | Multiple teeth (`multiple_teeth`) |
| Is tooth pain present? (`tooth_pain`) | Step 1 | No tooth pain reported (`no`) |
| What triggers the tooth pain? (`triggers`) | Step 1 | Not asked; cleared to Unknown |
| Pain after the trigger stops (`persistence`) | Step 1 | Not asked; cleared to Unknown |
| Spontaneous tooth pain? (`spontaneous`) | Step 1 | Not asked; cleared to Unknown |
| Tooth pain interrupts sleep? (`sleep_pain`) | Step 1 | Not asked; cleared to Unknown |
| Pain when biting? (`biting_pain`) | Step 1 | Not asked; cleared to Unknown |
| Gum symptoms (`gum_symptoms`) | Step 1 | Bleeding when brushing or flossing; Red or swollen gum margins (`[bleeding,redness]`) |
| Warning signs (`warning_signs`) | Step 1 | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Step 1 | Unknown (`unknown`) |
| Cavitated lesion observed? (`cavity`) | Step 2 | No cavity observed (`no`) |
| Softened tooth tissue observed? (`soft_tissue`) | Step 2 | Unknown (`unknown`) |
| Decay-related surface discoloration? (`discoloration`) | Step 2 | Unknown (`unknown`) |
| Permanent root maturity (`root_maturity`) | Step 2 | Not asked; cleared to Unknown |
| Recorded thermal response (`thermal_response`) | Step 2 | Not asked; cleared to Unknown |
| Percussion or palpation tenderness? (`percussion`) | Step 2 | Not asked; cleared to Unknown |
| Dentist-interpreted coronal carious lesion? (`radiographic_caries`) | Step 2 | Unknown (`unknown`) |
| Apical/furcation pathology or pathological resorption? (`apical_pathology`) | Step 2 | Not asked; cleared to Unknown |
| Plaque or calculus present? (`plaque`) | Step 2 | Plaque or calculus present (`yes`) |
| Previous periodontal destruction? (`prior_destruction`) | Step 2 | Not asked; cleared to Unknown |
| Maximum probing depth (`pocket_mm`) | Step 2 | 7 mm (`7`) |
| Maximum interdental attachment loss (`cal_mm`) | Step 2 | 6 mm (`6`) |
| Maximum buccal/oral attachment loss (`buccal_cal_mm`) | Step 2 | Unknown (`unknown`) |
| Sites bleeding on probing (`bop_percent`) | Step 2 | Unknown (`unknown`) |
| Interdental loss at two nonadjacent teeth? (`nonadjacent_teeth`) | Step 2 | Loss at two nonadjacent teeth (`yes`) |
| Buccal/oral loss at two teeth? (`two_teeth`) | Step 2 | Loss at two teeth (`yes`) |
| Could another local cause account for the attachment loss? (`nonperiodontal_causes`) | Step 2 | Alternative local causes excluded (`no`) |

**Expected response:** Candidate periodontitis.

**Prohibited outcomes:** Returning only gingivitis, deriving periodontitis from age alone, or assigning an unsupported stage/grade.

**Sources:** [AAP: Periodontitis assessment](https://www.perio.org/wp-content/uploads/2019/08/Staging-and-Grading-Periodontitis.pdf); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease); [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate periodontitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

## Edge cases

<a id="tc15"></a>

### TC15 — Missing age group

**Steps:** Start a fresh consultation. Enter the symptom answers below, leave Age group Unknown, and attempt assessment.

| Question / identifier | Controlled test answer / boundary value |
| --- | --- |
| Age group (`age_group`) | Unknown (`unknown`) |
| Affected tooth type (`tooth_type`) | Permanent tooth (`permanent`) |
| Is tooth pain present? (`tooth_pain`) | Tooth pain reported (`yes`) |
| What triggers the tooth pain? (`triggers`) | Cold (`[cold]`) |

**Expected response:** Please select age group before completing the assessment.

**Prohibited outcomes:** Assuming adulthood, deriving a clinical condition from default age group, or accepting missing age group as 0–5.

**Sources:** [Consultation input requirements](project-proposal.md#2-specific-domain-and-scope). Validation behavior is a project requirement, not a sourced clinical rule.

**Review status:** Pending software requirement review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Incomplete; request age group; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc16"></a>

### TC16 — Invalid numeric age-group value

**Steps:** Submit `obs(age_group,-2)` through the structured Prolog/JPL boundary and confirm rejection. The controlled UI permits only Unknown or the five listed groups; it cannot submit a numeric age.

| Question / identifier | Controlled test answer / boundary value |
| --- | --- |
| Age group (`age_group`) | Invalid programmatic value: -2 (`-2`) |

**Expected response:** Age group must be a listed predefined value. Please correct it.

**Prohibited outcomes:** Silently converting −2 to 2 or zero, accepting the value, or returning a diagnosis.

**Sources:** [Interface input-validation responsibilities](architecture.md#java-interface-and-consultation-service). This is a software validation case.

**Review status:** Pending software requirement review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Invalid; reject numeric age_group -2; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc17"></a>

### TC17 — Required dentition and examination information unavailable

**Steps:** Start a fresh consultation. Enter all available symptoms, explicitly answer Unknown for dentition/findings, and attempt assessment.

| Question / identifier | Controlled test answer / boundary value |
| --- | --- |
| Age group (`age_group`) | 6-12 years (`child`) |
| Affected tooth type (`tooth_type`) | Unknown (`unknown`) |
| Is tooth pain present? (`tooth_pain`) | Tooth pain reported (`yes`) |
| What triggers the tooth pain? (`triggers`) | Cold (`[cold]`) |
| Warning signs (`warning_signs`) | None reported (`none`) |

**Expected response:** Please provide the affected tooth type and available dental examination findings. Assessment incomplete.

**Prohibited outcomes:** Inferring tooth type from age, treating absent tests as negative, or returning an established diagnosis.

**Sources:** [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf); [project scope](project-proposal.md#2-specific-domain-and-scope). Exact follow-up fields are project requirements.

**Review status:** Pending software requirement review; supporting clinical data pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Incomplete; request affected tooth type; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc18"></a>

### TC18 — Contradictory tooth-pain answers

**Steps:** Submit the contradictory observations directly to Prolog/JPL. The UI prevents this combination by clearing and hiding spontaneous pain after selecting No tooth pain reported. The boundary must return conflict when both observations are supplied programmatically.

| Question / identifier | Controlled test answer / boundary value |
| --- | --- |
| Age group (`age_group`) | 18-64 years (`adult`) |
| Dentition (`dentition`) | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Permanent tooth (`permanent`) |
| Is tooth pain present? (`tooth_pain`) | No tooth pain reported (`no`) |
| Spontaneous tooth pain? (`spontaneous`) | Pain starts without a trigger (`yes`) |

**Expected response:** Your tooth-pain answers conflict. Please clarify whether tooth pain is present.

**Prohibited outcomes:** Accepting the conflicting programmatic observations or returning a diagnosis before clarification.

**Sources:** [Contradictory-input handling](architecture.md#5-failure-handling-and-verification). This is a project consistency requirement.

**Review status:** Pending software requirement review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Conflict; clarify tooth-pain answers; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc19"></a>

### TC19 — Jaw clicking outside the supported presentation scope

**Steps:** Start a fresh consultation, enter the jaw-clicking complaint with explicit negative tooth/gum symptoms, and attempt assessment.

| Question / identifier | Controlled test answer / boundary value |
| --- | --- |
| Age group (`age_group`) | 18-64 years (`adult`) |
| Dentition (`dentition`) | Permanent (`permanent`) |
| Affected tooth type (`tooth_type`) | Not applicable (`na`) |
| Affected region (`region`) | Jaw joint (`jaw_joint`) |
| Is tooth pain present? (`tooth_pain`) | No tooth pain reported (`no`) |
| Gum symptoms (`gum_symptoms`) | None reported (`none`) |
| Warning signs (`warning_signs`) | None reported (`none`) |
| Jaw clicking? (`jaw_clicking`) | Jaw clicking reported (`yes`) |

**Expected response:** This presentation is outside the supported tooth-pain and gum-symptom scope. No supported dental conclusion.

**Prohibited outcomes:** Diagnosing a jaw disorder, forcing one of the five dental targets, or declaring that all dental disease is excluded.

**Sources:** [Supported tooth-pain and gum-symptom scope](project-proposal.md#2-specific-domain-and-scope). This tests scope routing, not diagnosis of jaw clicking.

**Review status:** Pending software requirement review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Outside supported scope; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc20"></a>

### TC20 — Reset after a completed consultation

**Steps:** Run TC11 and record its result. Click New consultation/Reset. Attempt assessment without entering new data. Run using forward chaining.

| Question / identifier | Controlled test answer / boundary value |
| --- | --- |
| Age group (`age_group`) | Unknown (`unknown`) |
| Dentition (`dentition`) | Unknown (`unknown`) |
| Affected tooth type (`tooth_type`) | Unknown (`unknown`) |
| Affected region (`region`) | Unknown (`unknown`) |

**Expected response:** Please select age group and start a new consultation. No previous candidate or input remains.

**Prohibited outcomes:** Reusing the 13–17 age group, TC11 symptoms/findings, or the previous gingivitis candidate; a delayed old result repopulating the screen.

**Sources:** [Consultation lifecycle and reset](architecture.md#3-consultation-data-flow-and-lifecycle). This is a lifecycle test using TC11 as setup, not an additional clinical case.

**Review status:** Pending software requirement review; supporting clinical data pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.3.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Incomplete; request age group; no candidates |
| Pass / fail | **PASS — software** |

## Acceptance and maintenance

The catalogue has exactly 20 cases: TC01–TC14 are diagnostic candidates and TC15–TC20 are edge cases. Every assessment uses forward chaining. Additional supported candidates are allowed, but prohibited outcomes fail the case. A software exception is not a valid outside-scope or incomplete-assessment response.

Record observed forward-chaining responses in the tables on every knowledge revision. Where the UI blocks an invalid input before Prolog is called, record that validation result for the attempted assessment. Do not mark an unexecuted case as passing. Record expert revisions before changing expected clinical outcomes; do not edit expectations merely to make a failing implementation pass.

The executable fixtures are in `knowledge/acceptance.pl`; Java/JPL integration and control tests are in `src/test/java/dental/IntegrationTest.java`. Run `./scripts/test.sh`. Case data do not count toward the 25 rules or 30 authored domain facts. The full test programme must also check target-platform packaging, integration failures, and reasoning termination as specified in the proposal and architecture.
