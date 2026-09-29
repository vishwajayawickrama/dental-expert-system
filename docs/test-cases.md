# DentalExplain acceptance tests and question counts

**Release:** Application 1.2.0, knowledge 0.4.0. The 20 synthetic cases pass software checks; clinical expectations remain **pending dentist review**. They cover 14 diagnostic presentations and six validation/lifecycle edge cases. The report retains a testing summary; full cases remain here, outside the report appendices.

The shared catalogue contains **27 questions: two setup, eight symptom and 17 findings questions**. Dentition, region and biting-pain fields are removed and rejected at the boundary. Measurements remain separate; no diagnostic rule or premise is removed. Unspecified answers remain Unknown. None explicitly records absence in a checkbox group; unchecked findings otherwise remain Unknown. Not applicable is unusable evidence.

Routing uses forward deductions and unresolved prerequisites across all five conditions. It skips unanswered alternatives after sufficient support and questions belonging only to blocked rules. Explicit applicable answers remain visible; parent changes clear inapplicable children. All 14 diagnostic targets also pass after routing removes inactive inputs, allowing coexisting candidates.

## Question-count measurement

The reproducible catalogue-order walkthrough answers a field only if it is active when reached, including explicit Unknown where the fixture provides no value. Counts include setup. The final-visible count is measured after those answers; the two metrics differ when later answers make earlier fields inapplicable. These are automated ordered walkthrough counts, not a hard cap, a minimum, or a count of all controls momentarily shown. Unknown and more complex presentations may require additional fields.

| Case | Ordered answers, including setup | Final visible questions | More than 15 ordered answers? |
| --- | ---: | ---: | --- |
| TC01 | 13 | 12 | No |
| TC02 | 13 | 12 | No |
| TC03 | 13 | 12 | No |
| TC04 | 21 | 18 | Yes |
| TC05 | 22 | 19 | Yes |
| TC06 | 23 | 20 | Yes |
| TC07 | 19 | 15 | Yes |
| TC08 | 20 | 17 | Yes |
| TC09 | 20 | 17 | Yes |
| TC10 | 14 | 14 | No |
| TC11 | 14 | 14 | No |
| TC12 | 14 | 14 | No |
| TC13 | 18 | 16 | Yes |
| TC14 | 18 | 16 | Yes |
| TC15 | Not applicable: boundary/reset fixture | Not applicable | Not applicable |
| TC16 | Not applicable: boundary/reset fixture | Not applicable | Not applicable |
| TC17 | Not applicable: boundary/reset fixture | Not applicable | Not applicable |
| TC18 | Not applicable: boundary/reset fixture | Not applicable | Not applicable |
| TC19 | Not applicable: boundary/reset fixture | Not applicable | Not applicable |
| TC20 | Not applicable: boundary/reset fixture | Not applicable | Not applicable |

TC01–TC03 use 13 ordered answers and TC10–TC12 use 14. TC04–TC09 and TC13–TC14 exceed 15. Separate clinical findings and all five conditions take priority over a fixed limit. TC15–TC19 are programmatic edge cases; TC20 verifies the blank reset state rather than a completed consultation.

## Complete case records

### TC01 Caries in a primary tooth

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Softened tooth tissue observed? (soft_tissue) | Softened tissue observed | `yes` |
| Cavitated lesion observed? (cavity) | Cavity observed | `yes` |
| Dentist-interpreted coronal carious lesion? (radiographic_caries) | Coronal carious lesion observed | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Apical/furcation pathology or pathological resorption? (apical_pathology) | No apical or furcation pathology | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Sites bleeding on probing (bop_percent) | 0% | `0` |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Age group (age_group) | 6-12 years | `child` |
| Affected tooth type (tooth_type) | Primary tooth | `primary` |

- **Expected:** Dental caries must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Dental caries.
- **Missing requests:** none.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported reversible or irreversible pulpitis.
- **Ordered answers / final visible:** 13 / 12.
- **Sources:** [NIDCR](https://www.nidcr.nih.gov/health-info/tooth-decay), [AAPD](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

### TC02 Caries in a child-group permanent tooth

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Softened tooth tissue observed? (soft_tissue) | Softened tissue observed | `yes` |
| Cavitated lesion observed? (cavity) | Cavity observed | `yes` |
| Dentist-interpreted coronal carious lesion? (radiographic_caries) | Coronal carious lesion observed | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Apical/furcation pathology or pathological resorption? (apical_pathology) | No apical or furcation pathology | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Sites bleeding on probing (bop_percent) | 0% | `0` |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Age group (age_group) | 6-12 years | `child` |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |
| Permanent root maturity (root_maturity) | Unknown | `unknown` |

- **Expected:** Dental caries must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Dental caries.
- **Missing requests:** none.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported reversible or irreversible pulpitis.
- **Ordered answers / final visible:** 13 / 12.
- **Sources:** [NIDCR](https://www.nidcr.nih.gov/health-info/tooth-decay), [AAPD](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

### TC03 Caries in an adult permanent tooth

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Softened tooth tissue observed? (soft_tissue) | Softened tissue observed | `yes` |
| Cavitated lesion observed? (cavity) | Cavity observed | `yes` |
| Dentist-interpreted coronal carious lesion? (radiographic_caries) | Coronal carious lesion observed | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Apical/furcation pathology or pathological resorption? (apical_pathology) | No apical or furcation pathology | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Sites bleeding on probing (bop_percent) | 0% | `0` |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Age group (age_group) | 18-64 years | `adult` |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |
| Permanent root maturity (root_maturity) | Mature | `mature` |
| Recorded thermal response (thermal_response) | Brief response | `brief` |

- **Expected:** Dental caries must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Dental caries.
- **Missing requests:** none.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported reversible or irreversible pulpitis.
- **Ordered answers / final visible:** 13 / 12.
- **Sources:** [NIDCR](https://www.nidcr.nih.gov/health-info/tooth-decay), [AAPD](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

### TC04 Reversible pulpitis in a primary tooth

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Cavitated lesion observed? (cavity) | Cavity observed | `yes` |
| Softened tooth tissue observed? (soft_tissue) | Unknown | `unknown` |
| Dentist-interpreted coronal carious lesion? (radiographic_caries) | Coronal carious lesion observed | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Apical/furcation pathology or pathological resorption? (apical_pathology) | No apical or furcation pathology | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Sites bleeding on probing (bop_percent) | 0% | `0` |
| Is tooth pain present? (tooth_pain) | Tooth pain reported | `yes` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Pain after the trigger stops (persistence) | Brief; stops promptly | `brief` |
| Age group (age_group) | 6-12 years | `child` |
| Affected tooth type (tooth_type) | Primary tooth | `primary` |
| What triggers the tooth pain? (triggers) | Sweet | `[sweet]` |

- **Expected:** Reversible pulpitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Dental caries; Reversible pulpitis.
- **Missing requests:** none.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported irreversible pulpitis.
- **Ordered answers / final visible:** 21 / 18.
- **Sources:** [AAE](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf), [AAPD](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

### TC05 Reversible pulpitis in an immature permanent tooth

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Cavitated lesion observed? (cavity) | Cavity observed | `yes` |
| Softened tooth tissue observed? (soft_tissue) | Unknown | `unknown` |
| Dentist-interpreted coronal carious lesion? (radiographic_caries) | Coronal carious lesion observed | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Apical/furcation pathology or pathological resorption? (apical_pathology) | No apical or furcation pathology | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Sites bleeding on probing (bop_percent) | 0% | `0` |
| Is tooth pain present? (tooth_pain) | Tooth pain reported | `yes` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Pain after the trigger stops (persistence) | Brief; stops promptly | `brief` |
| Age group (age_group) | 13-17 years | `adolescent` |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |
| Permanent root maturity (root_maturity) | Immature | `immature` |
| What triggers the tooth pain? (triggers) | Cold | `[cold]` |

- **Expected:** Reversible pulpitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Dental caries; Reversible pulpitis.
- **Missing requests:** none.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported irreversible pulpitis.
- **Ordered answers / final visible:** 22 / 19.
- **Sources:** [AAE](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf), [AAPD](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

### TC06 Reversible pulpitis in a mature permanent tooth

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Cavitated lesion observed? (cavity) | Cavity observed | `yes` |
| Softened tooth tissue observed? (soft_tissue) | Unknown | `unknown` |
| Dentist-interpreted coronal carious lesion? (radiographic_caries) | Coronal carious lesion observed | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Apical/furcation pathology or pathological resorption? (apical_pathology) | No apical or furcation pathology | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Sites bleeding on probing (bop_percent) | 0% | `0` |
| Is tooth pain present? (tooth_pain) | Tooth pain reported | `yes` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Pain after the trigger stops (persistence) | Brief; stops promptly | `brief` |
| Age group (age_group) | 18-64 years | `adult` |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |
| Permanent root maturity (root_maturity) | Mature | `mature` |
| Recorded thermal response (thermal_response) | Brief response | `brief` |
| What triggers the tooth pain? (triggers) | Cold; Sweet | `[cold,sweet]` |

- **Expected:** Reversible pulpitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Dental caries; Reversible pulpitis.
- **Missing requests:** none.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported irreversible pulpitis.
- **Ordered answers / final visible:** 23 / 20.
- **Sources:** [AAE](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf), [AAPD](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

### TC07 Irreversible pulpitis candidate in a primary tooth

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Cavitated lesion observed? (cavity) | Cavity observed | `yes` |
| Softened tooth tissue observed? (soft_tissue) | Unknown | `unknown` |
| Dentist-interpreted coronal carious lesion? (radiographic_caries) | Coronal carious lesion observed | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Apical/furcation pathology or pathological resorption? (apical_pathology) | No apical or furcation pathology | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Sites bleeding on probing (bop_percent) | 0% | `0` |
| Is tooth pain present? (tooth_pain) | Tooth pain reported | `yes` |
| Spontaneous tooth pain? (spontaneous) | Pain starts without a trigger | `yes` |
| Tooth pain interrupts sleep? (sleep_pain) | Pain interrupts sleep | `yes` |
| Pain after the trigger stops (persistence) | Lingering; continues | `lingering` |
| Age group (age_group) | 6-12 years | `child` |
| Affected tooth type (tooth_type) | Primary tooth | `primary` |
| What triggers the tooth pain? (triggers) | Unknown | `unknown` |

- **Expected:** Symptomatic irreversible pulpitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Dental caries; Symptomatic irreversible pulpitis.
- **Missing requests:** none.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported reversible pulpitis.
- **Ordered answers / final visible:** 19 / 15.
- **Sources:** [AAE](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf), [AAPD](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

### TC08 Irreversible pulpitis in an adolescent permanent tooth

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Cavitated lesion observed? (cavity) | Cavity observed | `yes` |
| Softened tooth tissue observed? (soft_tissue) | Unknown | `unknown` |
| Dentist-interpreted coronal carious lesion? (radiographic_caries) | Coronal carious lesion observed | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Apical/furcation pathology or pathological resorption? (apical_pathology) | No apical or furcation pathology | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Sites bleeding on probing (bop_percent) | 0% | `0` |
| Is tooth pain present? (tooth_pain) | Tooth pain reported | `yes` |
| Spontaneous tooth pain? (spontaneous) | Pain starts without a trigger | `yes` |
| Tooth pain interrupts sleep? (sleep_pain) | Pain interrupts sleep | `yes` |
| Pain after the trigger stops (persistence) | Lingering; continues | `lingering` |
| Age group (age_group) | 13-17 years | `adolescent` |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |
| Permanent root maturity (root_maturity) | Mature | `mature` |
| Recorded thermal response (thermal_response) | Exaggerated, lingering response | `lingering` |
| What triggers the tooth pain? (triggers) | Cold | `[cold]` |

- **Expected:** Symptomatic irreversible pulpitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Dental caries; Symptomatic irreversible pulpitis.
- **Missing requests:** none.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported reversible pulpitis.
- **Ordered answers / final visible:** 20 / 17.
- **Sources:** [AAE](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf), [AAPD](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

### TC09 Irreversible pulpitis in an adult permanent tooth

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Cavitated lesion observed? (cavity) | Cavity observed | `yes` |
| Softened tooth tissue observed? (soft_tissue) | Unknown | `unknown` |
| Dentist-interpreted coronal carious lesion? (radiographic_caries) | Coronal carious lesion observed | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Apical/furcation pathology or pathological resorption? (apical_pathology) | No apical or furcation pathology | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Sites bleeding on probing (bop_percent) | 0% | `0` |
| Is tooth pain present? (tooth_pain) | Tooth pain reported | `yes` |
| Spontaneous tooth pain? (spontaneous) | Pain starts without a trigger | `yes` |
| Tooth pain interrupts sleep? (sleep_pain) | Pain interrupts sleep | `yes` |
| Pain after the trigger stops (persistence) | Lingering; continues | `lingering` |
| Age group (age_group) | 18-64 years | `adult` |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |
| Permanent root maturity (root_maturity) | Mature | `mature` |
| Recorded thermal response (thermal_response) | Exaggerated, lingering response | `lingering` |
| What triggers the tooth pain? (triggers) | Cold; Hot | `[cold,hot]` |

- **Expected:** Symptomatic irreversible pulpitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Dental caries; Symptomatic irreversible pulpitis.
- **Missing requests:** none.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported reversible pulpitis.
- **Ordered answers / final visible:** 20 / 17.
- **Sources:** [AAE](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf), [AAPD](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

### TC10 Gingivitis in the child group

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Gum symptoms (gum_symptoms) | Bleeding when brushing or flossing; Red or swollen gum margins | `[bleeding,redness]` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Previous periodontal destruction? (prior_destruction) | No previous destruction documented | `no` |
| Cavitated lesion observed? (cavity) | No cavity observed | `no` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Age group (age_group) | 6-12 years | `child` |
| Affected tooth type (tooth_type) | Not applicable | `na` |
| Sites bleeding on probing (bop_percent) | 30% | `30` |

- **Expected:** Gingivitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Gingivitis.
- **Missing requests:** discoloration, radiographic_caries, soft_tissue.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported periodontitis.
- **Ordered answers / final visible:** 14 / 14.
- **Sources:** [EFP_G](https://www.efp.org/fileadmin/uploads/efp/Documents/Campaigns/New_Classification/Reports/Consensus_report__Workgroup_1__Chapple_et_al-2018-Journal_of_Clinical_Periodontology.pdf).

### TC11 Gingivitis in the adolescent group

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Gum symptoms (gum_symptoms) | Bleeding when brushing or flossing; Red or swollen gum margins | `[bleeding,redness]` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Previous periodontal destruction? (prior_destruction) | No previous destruction documented | `no` |
| Cavitated lesion observed? (cavity) | No cavity observed | `no` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Age group (age_group) | 13-17 years | `adolescent` |
| Affected tooth type (tooth_type) | Not applicable | `na` |
| Sites bleeding on probing (bop_percent) | 40% | `40` |

- **Expected:** Gingivitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Gingivitis.
- **Missing requests:** discoloration, radiographic_caries, soft_tissue.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported periodontitis.
- **Ordered answers / final visible:** 14 / 14.
- **Sources:** [EFP_G](https://www.efp.org/fileadmin/uploads/efp/Documents/Campaigns/New_Classification/Reports/Consensus_report__Workgroup_1__Chapple_et_al-2018-Journal_of_Clinical_Periodontology.pdf).

### TC12 Gingivitis in the adult group

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Gum symptoms (gum_symptoms) | Bleeding when brushing or flossing; Red or swollen gum margins | `[bleeding,redness]` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Warning signs (warning_signs) | None reported | `none` |
| Maximum interdental attachment loss (cal_mm) | 0 mm | `0` |
| Maximum probing depth (pocket_mm) | 3 mm | `3` |
| Previous periodontal destruction? (prior_destruction) | No previous destruction documented | `no` |
| Cavitated lesion observed? (cavity) | No cavity observed | `no` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Age group (age_group) | 18-64 years | `adult` |
| Affected tooth type (tooth_type) | Not applicable | `na` |
| Sites bleeding on probing (bop_percent) | 35% | `35` |

- **Expected:** Gingivitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Gingivitis.
- **Missing requests:** discoloration, radiographic_caries, soft_tissue.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported periodontitis.
- **Ordered answers / final visible:** 14 / 14.
- **Sources:** [EFP_G](https://www.efp.org/fileadmin/uploads/efp/Documents/Campaigns/New_Classification/Reports/Consensus_report__Workgroup_1__Chapple_et_al-2018-Journal_of_Clinical_Periodontology.pdf).

### TC13 Periodontitis in the adult group

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Gum symptoms (gum_symptoms) | Bleeding when brushing or flossing; Red or swollen gum margins | `[bleeding,redness]` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Interdental loss at two nonadjacent teeth? (nonadjacent_teeth) | Loss at two nonadjacent teeth | `yes` |
| Buccal/oral loss at two teeth? (two_teeth) | Loss at two teeth | `yes` |
| Could another local cause account for the attachment loss? (nonperiodontal_causes) | Alternative local causes excluded | `no` |
| Previous periodontal destruction? (prior_destruction) | Unknown | `unknown` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Cavitated lesion observed? (cavity) | No cavity observed | `no` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Warning signs (warning_signs) | None reported | `none` |
| Age group (age_group) | 18-64 years | `adult` |
| Maximum interdental attachment loss (cal_mm) | 4 mm | `4` |
| Maximum probing depth (pocket_mm) | 6 mm | `6` |
| Maximum buccal/oral attachment loss (buccal_cal_mm) | Unknown | `unknown` |

- **Expected:** Periodontitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Periodontitis.
- **Missing requests:** discoloration, radiographic_caries, soft_tissue.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported intact-periodontium gingivitis.
- **Ordered answers / final visible:** 18 / 16.
- **Sources:** [EFP](https://www.efp.org/fileadmin/uploads/efp/Documents/Campaigns/New_Classification/Guidance_Notes/report-02.pdf).

### TC14 Periodontitis in the older-adult group

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Gum symptoms (gum_symptoms) | Bleeding when brushing or flossing; Red or swollen gum margins | `[bleeding,redness]` |
| Plaque or calculus present? (plaque) | Plaque or calculus present | `yes` |
| Interdental loss at two nonadjacent teeth? (nonadjacent_teeth) | Loss at two nonadjacent teeth | `yes` |
| Buccal/oral loss at two teeth? (two_teeth) | Loss at two teeth | `yes` |
| Could another local cause account for the attachment loss? (nonperiodontal_causes) | Alternative local causes excluded | `no` |
| Previous periodontal destruction? (prior_destruction) | Unknown | `unknown` |
| Spontaneous tooth pain? (spontaneous) | No spontaneous pain | `no` |
| Tooth pain interrupts sleep? (sleep_pain) | No sleep interruption | `no` |
| Cavitated lesion observed? (cavity) | No cavity observed | `no` |
| Percussion or palpation tenderness? (percussion) | Not tender | `no` |
| Warning signs (warning_signs) | None reported | `none` |
| Age group (age_group) | 65-120 years | `older_adult` |
| Maximum interdental attachment loss (cal_mm) | 6 mm | `6` |
| Maximum probing depth (pocket_mm) | 7 mm | `7` |
| Maximum buccal/oral attachment loss (buccal_cal_mm) | Unknown | `unknown` |

- **Expected:** Periodontitis must be included; coexisting supported candidates permitted.
- **Actual:** candidates; candidates: Periodontitis.
- **Missing requests:** discoloration, radiographic_caries, soft_tissue.
- **Message:** Candidate conditions only. Clinical knowledge review is pending.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Unsupported intact-periodontium gingivitis.
- **Ordered answers / final visible:** 18 / 16.
- **Sources:** [EFP](https://www.efp.org/fileadmin/uploads/efp/Documents/Campaigns/New_Classification/Guidance_Notes/report-02.pdf).

### TC15 Missing age group

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Is tooth pain present? (tooth_pain) | Tooth pain reported | `yes` |
| What triggers the tooth pain? (triggers) | Cold | `[cold]` |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |

- **Expected:** incomplete.
- **Actual:** incomplete; candidates: none.
- **Missing requests:** age_group.
- **Message:** Complete the required consultation inputs.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Any supported candidate.
- **Sources:** Implemented validation and consultation lifecycle requirements.

### TC16 Invalid numeric age-group input

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Age group (age_group) | -2 | `-2` |

- **Expected:** invalid.
- **Actual:** invalid; candidates: none.
- **Missing requests:** age_group.
- **Message:** Choose a valid predefined value, including a listed age group.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Any supported candidate.
- **Sources:** Implemented validation and consultation lifecycle requirements.

### TC17 Missing affected tooth information

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Age group (age_group) | 6-12 years | `child` |
| Is tooth pain present? (tooth_pain) | Tooth pain reported | `yes` |
| What triggers the tooth pain? (triggers) | Cold | `[cold]` |
| Affected tooth type (tooth_type) | Unknown | `unknown` |
| Warning signs (warning_signs) | None reported | `none` |

- **Expected:** incomplete.
- **Actual:** incomplete; candidates: none.
- **Missing requests:** tooth_type.
- **Message:** Complete the required consultation inputs.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Any supported candidate.
- **Sources:** Implemented validation and consultation lifecycle requirements.

### TC18 Contradictory tooth-pain answers

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Age group (age_group) | 18-64 years | `adult` |
| Affected tooth type (tooth_type) | Permanent tooth | `permanent` |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Spontaneous tooth pain? (spontaneous) | Pain starts without a trigger | `yes` |

- **Expected:** conflict.
- **Actual:** conflict; candidates: none.
- **Missing requests:** none.
- **Message:** Tooth-pain answers conflict. Clarify whether pain is present.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Any supported candidate.
- **Sources:** Implemented validation and consultation lifecycle requirements.

### TC19 Jaw-only presentation outside scope

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| Age group (age_group) | 18-64 years | `adult` |
| Affected tooth type (tooth_type) | Not applicable | `na` |
| Warning signs (warning_signs) | None reported | `none` |
| Jaw clicking? (jaw_clicking) | Jaw clicking reported | `yes` |
| Is tooth pain present? (tooth_pain) | No tooth pain reported | `no` |
| Gum symptoms (gum_symptoms) | None reported | `none` |

- **Expected:** outside_scope.
- **Actual:** outside_scope; candidates: none.
- **Missing requests:** none.
- **Message:** This jaw presentation is outside the supported tooth-pain and gum-symptom scope.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Any supported candidate.
- **Sources:** Implemented validation and consultation lifecycle requirements.

### TC20 Blank consultation after reset

Procedure: complete TC11, choose New consultation, then assess the blank state. Swing tests separately confirm that selections, displayed results and delayed callbacks are cleared.

| Question | Supplied controlled choice | Stable value |
| --- | --- | --- |
| All questions | Unknown after reset | No observations |

- **Expected:** incomplete.
- **Actual:** incomplete; candidates: none.
- **Missing requests:** age_group.
- **Message:** Complete the required consultation inputs.
- **Software status:** PASS. **Clinical review:** pending.
- **Prohibited:** Any supported candidate.
- **Sources:** Implemented validation and consultation lifecycle requirements.

## Additional verification

The Prolog suite contains 51 checks, including allowed values, removed identifiers, duplicate inputs, checkbox exclusivity, uncertainty, fixed-point termination, missing prerequisites, blocked rules, supported-condition question skipping and all ordered walkthroughs. Java/JPL assesses all 20 fixtures and 14 routed diagnostic cases. Swing checks all 27 controls, Back navigation, conditional clearing, scope bypass, result readability, New consultation and discarded delayed callbacks. Native screenshots and platform packaging results are recorded separately in the verification document.

## External-runtime release 1.3.0 verification — 29 September 2026

All 20 cases and the existing routing/interface checks passed with externally installed Java 21 and SWI-Prolog/JPL 10.0.2 on macOS ARM64, Windows x64 and Ubuntu 24.04 x64. [Workflow evidence](https://github.com/vishwajayawickrama/dental-expert-system/actions/runs/36574386759). Inputs, target candidates, question counts and clinical-review status are unchanged.
