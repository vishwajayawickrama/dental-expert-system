# DentalExplain: 20 acceptance test cases

**Status:** Implemented and executed against knowledge v0.2.0 using SWI-Prolog and the Java/JPL bridge. All 20 cases passed the software assertions using forward chaining. Clinical expectations remain **Pending dentist review**; software passes do not establish clinical accuracy.

These are synthetic cases, not real patient records. They cover 14 diagnostic presentations and 6 input/lifecycle edge cases. The [proposal](project-proposal.md) defines the scope; the [architecture](architecture.md) defines Java Swing, JPL, and SWI-Prolog integration.

## Answer conventions and execution

- **No:** an explicitly negative answer or examination finding.
- **Unknown:** information is unavailable; it must not be converted into No. An omitted answer stays Unknown.
- **Not applicable:** the question does not apply to this presentation.
- Dentist rows are synthetic observations entered by a professional; the application will not interpret images or conduct examinations. FDI numbers identify teeth.
- Ages, durations, severity descriptions, and measurement values are authored test data, not universal diagnostic thresholds. Dentition is explicitly supplied rather than inferred from age.
- Primary/immature-tooth thermal and electric results are not relied upon. Candidate pulpitis results remain provisional, particularly when necrosis has not been excluded. This follows [AAPD diagnostic guidance](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf).

For TC01–TC14, start a fresh consultation, enter the controlled selections and run forward chaining. Each result must include its expected target and respect prohibited outcomes. Coexisting supported conditions, such as caries with pulpitis, are allowed. For TC15–TC19 check the validation or follow-up response; TC20 checks reset. Equivalent message wording is acceptable. No condition is entered as evidence or selected as a goal. Software passes do not replace dentist review.


## Mapping the catalogue to controlled inputs

The question-and-answer tables describe synthetic clinical observations. The executable fixtures use only identifiers from `knowledge/questions.pl`; unspecified findings remain Unknown. Narrative details without a corresponding supported question (such as exact radiographic depth or pulp exposure) are contextual descriptions and are not parsed or inferred. Do not enter the expected condition as evidence.

- Age values in the original synthetic scenarios map to one of five predefined age groups; exact ages are no longer submitted. FDI identifiers map to the non-editable dropdown values. Tooth type and root maturity are supplied explicitly. TC01/TC04/TC07 use mixed dentition with a primary affected tooth; TC05 supplies an immature permanent tooth.
- Reported severity maps to Mild, Moderate or Severe. Brief post-trigger pain maps to `brief`; prolonged pain maps to `lingering`. A few days maps to 1-7 days, weeks to 1-4 weeks, months to 1-6 months, and TC14's longer history to Over 6 months. The duration categories are input labels, not diagnostic thresholds.
- Cold, Hot and Sweet map to the corresponding checkbox identifiers. Explicitly absent relevant history maps to None reported. Omitted triggers stay Unknown; TC07's spontaneous presentation does not silently establish that all triggers are absent.
- A probing range is represented by its supplied maximum: 1-3 mm becomes 3 mm, TC13's 5-6 mm becomes 6 mm and TC14's 6-7 mm becomes 7 mm. Supplied attachment loss is represented similarly. TC10/TC11/TC12 use bleeding-on-probing values 30%/40%/35%. Findings not measured remain Unknown.
- TC16 bypasses the UI and submits `obs(age_group,-2)` to Prolog and JPL validation boundaries. Numeric values are invalid for this atom-valued field, even if they describe a valid exact age; the UI permits only the listed groups.
- TC17 first requests affected tooth type. Additional examination requests can follow after it is supplied; the engine does not invent a conclusion while this required field is unavailable.
- TC20's blank-input fixture verifies the post-reset engine response. Separate Prolog tests assess TC11 then blank inputs using forward chaining. Swing lifecycle tests verify clearing and rejection of a delayed worker result. The native UI also exercises New consultation after a completed candidate assessment.

Unchecked substantive checkbox items remain Unknown unless None is explicitly selected; Unknown, None and Not applicable are distinct. Hidden inapplicable controls are cleared and excluded by the interface. The detailed results and packaging/UI observations are recorded in [verification](verification.md).

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

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 6–12 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Mixed dentition; lower-right primary second molar (FDI 85), explicitly confirmed primary. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | No; duration/severity: Not applicable. A cavity was noticed 2 weeks ago. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Not applicable; no pain episodes. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | No bleeding, redness, swelling, or tenderness reported. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | Small cavitated occlusal lesion with softened tissue; no exposed pulp or fracture. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Unknown; thermal/electric results are not used for this primary tooth. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports a limited coronal lesion; no furcation/apical abnormality or pathological resorption. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque: small amount. Probing: 1–3 mm. Bleeding on probing: absent. Clinical attachment loss: absent on examination. Bone support: no loss reported by dentist. |

**Expected response:** Candidate dental caries.

**Prohibited outcomes:** Returning pulpitis or periodontitis as supported by these recorded inputs; excluding caries because pain is absent.

**Sources:** [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay); [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate dental caries |
| Pass / fail | **PASS — software** |

<a id="tc02"></a>

### TC02 — Caries in an adolescent permanent molar

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 6–12 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent affected tooth: upper-right first molar (FDI 16). |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | No; duration/severity: Not applicable. Food trapping noticed for 3 weeks. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Not applicable; no pain episodes. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | No bleeding, redness, swelling, or tenderness reported. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | Small cavitated fissure lesion with softened tissue; no exposed pulp or fracture. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Root maturity: Unknown. Thermal/electric tests: Unknown; not relied upon. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports a coronal lesion away from the pulp and no apical abnormality. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque: small amount. Probing: 1–3 mm. Bleeding on probing: absent. Clinical attachment loss: absent on examination. Bone support: no loss reported by dentist. |

**Expected response:** Candidate dental caries.

**Prohibited outcomes:** Returning pulpitis or periodontitis as supported by these recorded inputs; excluding caries because pain is absent.

**Sources:** [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay); [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate dental caries |
| Pass / fail | **PASS — software** |

<a id="tc03"></a>

### TC03 — Caries in an adult permanent molar

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 18–64 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent dentition; lower-left first molar (FDI 36). |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | No; duration/severity: Not applicable. Food trapping noticed for 1 month. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Not applicable; no pain episodes. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | No bleeding, redness, swelling, or tenderness reported. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | Proximal cavity with softened tissue; no fracture or exposed pulp. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Cold response brief and similar to control tooth; no lingering response. Electric test: Unknown. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports a coronal lesion and no apical abnormality. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque: small amount. Probing: 1–3 mm. Bleeding on probing: absent. Clinical attachment loss: absent on examination. Bone support: no loss reported by dentist. |

**Expected response:** Candidate dental caries.

**Prohibited outcomes:** Returning pulpitis or periodontitis as supported by these recorded inputs; excluding caries because pain is absent.

**Sources:** [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay); [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate dental caries |
| Pass / fail | **PASS — software** |

<a id="tc04"></a>

### TC04 — Reversible pulpitis candidate in a primary tooth

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 6–12 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Mixed dentition; lower-left primary second molar (FDI 75), explicitly confirmed primary. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | Yes; localized to FDI 75, mild, present for 4 days. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Sweet foods; episode resolves within about 2 seconds of removing the stimulus. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | No bleeding, redness, swelling, or tenderness reported. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | Cavitated dentin lesion; no visible pulp exposure or fracture. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Unknown; thermal/electric results are not used for this primary tooth. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports a dentin lesion, no furcation/apical abnormality, and no pathological resorption. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque: small amount. Probing: 1–3 mm. Bleeding on probing: absent. Clinical attachment loss: absent on examination. Bone support: no loss reported by dentist. |

**Expected response:** Candidate reversible pulpitis.

**Prohibited outcomes:** Returning symptomatic irreversible pulpitis as supported by these inputs; treating this as confirmed pulp status.

**Sources:** [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf); [AAPD: Vital pulp diagnosis in primary teeth](https://www.aapd.org/research/oral-health-policies--recommendations/vital_pulp_therapies_in_primary_teeth_with_deep_caries_lesions/). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and reversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc05"></a>

### TC05 — Reversible pulpitis candidate in an immature permanent tooth

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 13–17 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent affected tooth: upper-right second molar (FDI 17); dentist reports immature roots. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | Yes; localized to FDI 17, mild, present for 5 days. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Cold drinks; episode resolves within about 3 seconds of removing the stimulus. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | No bleeding, redness, swelling, or tenderness reported. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | Dentin cavity; no exposed pulp or visible fracture. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Unknown; thermal/electric testing is not relied upon for the immature tooth. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports a dentin lesion and no apical abnormality. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque: small amount. Probing: 1–3 mm. Bleeding on probing: absent. Clinical attachment loss: absent on examination. Bone support: no loss reported by dentist. |

**Expected response:** Candidate reversible pulpitis.

**Prohibited outcomes:** Returning symptomatic irreversible pulpitis as supported by these inputs; treating this as confirmed pulp status.

**Sources:** [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf); [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and reversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc06"></a>

### TC06 — Reversible pulpitis candidate in an adult tooth

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 18–64 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent dentition; lower-right first molar (FDI 46). |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | Yes; localized to FDI 46, mild, present for 1 week. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Cold drinks and sweet food; episode resolves within about 2 seconds of removal. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | No bleeding, redness, swelling, or tenderness reported. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | Dentin cavity; no fracture or exposed pulp. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Cold test reproduces brief discomfort which resolves promptly; electric response present. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports a dentin lesion without apical abnormality. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque: small amount. Probing: 1–3 mm. Bleeding on probing: absent. Clinical attachment loss: absent on examination. Bone support: no loss reported by dentist. |

**Expected response:** Candidate reversible pulpitis.

**Prohibited outcomes:** Returning symptomatic irreversible pulpitis as supported by these inputs; treating this as confirmed pulp status.

**Sources:** [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf); [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and reversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc07"></a>

### TC07 — Symptomatic irreversible pulpitis candidate in a primary tooth

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 6–12 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Mixed dentition; upper-left primary second molar (FDI 65), explicitly confirmed primary. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | Yes; localized to FDI 65, severe, present for 3 days. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Not consistently stimulus-linked; episodes last about 10 minutes. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | Yes; unprovoked episodes and sleep interruption on 2 nights. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | No bleeding, redness, swelling, or tenderness reported. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | Deep cavitated lesion; no visible fracture. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Unknown; thermal/electric results are not used for this primary tooth. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports a deep coronal lesion; no furcation/apical change or pathological resorption identified. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque: small amount. Probing: 1–3 mm. Bleeding on probing: absent. Clinical attachment loss: absent on examination. Bone support: no loss reported by dentist. |

**Expected response:** Candidate symptomatic irreversible pulpitis.

**Prohibited outcomes:** Returning only reversible pulpitis or classifying the result as confirmed; ignoring spontaneous/persistent pain.

**Case limitation:** Primary-tooth findings may overlap with necrosis. The expected label is provisional candidate support, not proof that necrosis is excluded; additional clinical assessment may be requested.

**Sources:** [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf); [AAPD: Vital pulp diagnosis in primary teeth](https://www.aapd.org/research/oral-health-policies--recommendations/vital_pulp_therapies_in_primary_teeth_with_deep_caries_lesions/). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and symptomatic irreversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc08"></a>

### TC08 — Symptomatic irreversible pulpitis candidate in an adolescent tooth

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 13–17 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent dentition; lower-left first molar (FDI 36); mature roots confirmed by dentist. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | Yes; localized to FDI 36, severe, present for 4 days. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Cold; pain persists for about 60 seconds after removal. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | Yes; unprovoked episodes and sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | No bleeding, redness, swelling, or tenderness reported. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | Deep cavity; no visible fracture. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Cold response exaggerated and lingering; electric response present. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports deep coronal involvement and no apical abnormality. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque: small amount. Probing: 1–3 mm. Bleeding on probing: absent. Clinical attachment loss: absent on examination. Bone support: no loss reported by dentist. |

**Expected response:** Candidate symptomatic irreversible pulpitis.

**Prohibited outcomes:** Returning only reversible pulpitis or classifying the result as confirmed; ignoring spontaneous/persistent pain.

**Sources:** [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf); [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and symptomatic irreversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc09"></a>

### TC09 — Symptomatic irreversible pulpitis candidate in an adult tooth

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 18–64 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent dentition; upper-right first molar (FDI 16). |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | Yes; localized to FDI 16, severe, present for 5 days. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Hot/cold drinks; discomfort lasts about 90 seconds after removal. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | Yes; spontaneous episodes interrupt sleep. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | No bleeding, redness, swelling, or tenderness reported. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | Deep cavity; no visible fracture. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Exaggerated lingering cold response; electric response present. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports deep coronal involvement and no apical abnormality. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque: small amount. Probing: 1–3 mm. Bleeding on probing: absent. Clinical attachment loss: absent on examination. Bone support: no loss reported by dentist. |

**Expected response:** Candidate symptomatic irreversible pulpitis.

**Prohibited outcomes:** Returning only reversible pulpitis or classifying the result as confirmed; ignoring spontaneous/persistent pain.

**Sources:** [AAE: Diagnostic terminology](https://www.aae.org/specialty/wp-content/uploads/sites/2/2017/07/aaeconsensusconferencerecommendeddiagnosticterminology.pdf); [NIDCR: Tooth decay](https://www.nidcr.nih.gov/health-info/tooth-decay). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidates dental caries and symptomatic irreversible pulpitis |
| Pass / fail | **PASS — software** |

<a id="tc10"></a>

### TC10 — Gingivitis candidate in mixed dentition

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 6–12 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Mixed dentition; marginal gums around several teeth, no single affected tooth. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | No tooth pain; duration/severity: Not applicable. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Gum bleeding with brushing; thermal pain: Not applicable. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous tooth pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | Yes; red/swollen margins, bleeding on brushing for 2 weeks; tenderness mild. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | No cavitated lesions or fractures identified in the examined regions. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Not applicable; no tooth-specific pulpal complaint. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Unknown; no radiograph supplied. Attachment measurements are supplied separately. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Visible plaque. Probing: 2–3 mm. Bleeding on probing: 30% of examined sites. Attachment loss: absent on examination. Prior periodontal destruction: No. |

**Expected response:** Candidate gingivitis.

**Prohibited outcomes:** Returning periodontitis without supplied evidence of periodontal destruction; inferring attachment loss from bleeding alone.

**Sources:** [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate gingivitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

<a id="tc11"></a>

### TC11 — Gingivitis candidate in an adolescent

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 13–17 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent dentition; generalized marginal gums, no single affected tooth. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | No tooth pain; duration/severity: Not applicable. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Gum bleeding when brushing; thermal pain: Not applicable. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous tooth pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | Yes; red margins and bleeding for 3 weeks; tenderness mild. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | No cavitated lesions or fractures identified in examined regions. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Not applicable; no tooth-specific pulpal complaint. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Unknown; no radiograph supplied. Attachment measurements are supplied separately. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Visible plaque. Probing: 2–3 mm. Bleeding on probing: 40% of examined sites. Attachment loss: absent on examination. Prior periodontal destruction: No. |

**Expected response:** Candidate gingivitis.

**Prohibited outcomes:** Returning periodontitis without supplied evidence of periodontal destruction; inferring attachment loss from bleeding alone.

**Sources:** [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate gingivitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

<a id="tc12"></a>

### TC12 — Gingivitis candidate in an adult

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 18–64 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent dentition; gingival margins around upper and lower anterior teeth. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | No tooth pain; duration/severity: Not applicable. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Gum bleeding on brushing/flossing; thermal pain: Not applicable. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous tooth pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | Yes; red/swollen margins and bleeding for 1 month; tenderness mild. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | No cavitated lesions or fractures identified in examined regions. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Not applicable; no tooth-specific pulpal complaint. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports no alveolar bone loss. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Visible plaque. Probing: 2–3 mm. Bleeding on probing: 35% of examined sites. Attachment loss: absent on examination. Prior periodontal destruction: No. |

**Expected response:** Candidate gingivitis.

**Prohibited outcomes:** Returning periodontitis without supplied evidence of periodontal destruction; inferring attachment loss from bleeding alone.

**Sources:** [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate gingivitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

<a id="tc13"></a>

### TC13 — Periodontitis candidate in an adult

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 18–64 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent dentition; periodontal sites around FDI 16 and 36, nonadjacent teeth. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | No toothache; duration/severity: Not applicable. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Bleeding during brushing; thermal pain: Not applicable. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous tooth pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | Yes; bleeding and recession noticed for 4 months; tenderness mild. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | No cavitated lesions or fractures in examined regions. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Not applicable; no pulpal complaint. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No tenderness to percussion or palpation; no abnormal mobility. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports alveolar bone loss around the affected nonadjacent teeth. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque/calculus present. Pockets: 5–6 mm. Interdental attachment loss: 3–4 mm at the two nonadjacent teeth. Bleeding on probing: present. Dentist records no traumatic recession, cervical lesion, endodontic lesion, root fracture, or third-molar-related cause for these attachment findings. |

**Expected response:** Candidate periodontitis.

**Prohibited outcomes:** Returning only gingivitis, deriving periodontitis from age alone, or assigning an unsupported stage/grade.

**Sources:** [AAP: Periodontitis assessment](https://www.perio.org/wp-content/uploads/2019/08/Staging-and-Grading-Periodontitis.pdf); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease); [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate periodontitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

<a id="tc14"></a>

### TC14 — Periodontitis candidate in an older adult

| Question | Answer provider | Test answer |
| --- | --- | --- |
| What is the age group? | User/parent | 65–120 years |
| What is the dentition and affected tooth or region? | User; dentist confirms | Permanent remaining teeth; affected periodontal sites around FDI 26 and 46, nonadjacent teeth. |
| Is there tooth pain? Where, how severe, and for how long? | User/parent | No toothache; duration/severity: Not applicable. |
| What triggers it and how long does an episode last after the trigger stops? | User/parent | Bleeding while brushing; thermal pain: Not applicable. |
| Does pain occur spontaneously or interrupt sleep? | User/parent | No spontaneous tooth pain or sleep interruption. |
| Is there pain when biting? | User/parent | No. |
| Do gums bleed, look red/swollen, or feel tender? | User/parent | Yes; recession/bleeding noticed for 1 year; tenderness mild. |
| Is there facial swelling, pus/drainage, or fever? | User/parent | No facial swelling, pus/drainage, or fever reported. |
| What relevant dental and medical history is reported? | User/parent | No recent trauma, restoration, extraction, previous pulp treatment, or known relevant medical condition reported. |
| What surface lesion, fracture, or exposed-dentin finding is recorded? | Dentist | No cavitated lesions or fractures in examined regions. |
| What pulp-test observations are available and appropriate for this tooth? | Dentist | Not applicable; no pulpal complaint. |
| What percussion, palpation, and mobility observations are recorded? | Dentist | No percussion/palpation tenderness. Increased mobility recorded at affected teeth. |
| What radiographic findings have already been interpreted? | Dentist | Dentist reports alveolar bone loss around affected teeth. |
| What plaque, probing, bleeding-on-probing, attachment, and bone-support findings are recorded? | Dentist | Plaque/calculus present. Pockets: 6–7 mm. Interdental attachment loss: 5–6 mm at two nonadjacent teeth. Bleeding on probing: present. Dentist records no traumatic recession, cervical lesion, endodontic lesion, root fracture, or third-molar-related cause for these attachment findings. |

**Expected response:** Candidate periodontitis.

**Prohibited outcomes:** Returning only gingivitis, deriving periodontitis from age alone, or assigning an unsupported stage/grade.

**Sources:** [AAP: Periodontitis assessment](https://www.perio.org/wp-content/uploads/2019/08/Staging-and-Grading-Periodontitis.pdf); [NIDCR: Gum disease diagnosis](https://www.nidcr.nih.gov/health-info/gum-disease); [AAP: Gum disease information](https://www.perio.org/for-patients/gum-disease-information/). These support the clinical pattern; numeric values and history are synthetic.

**Review status:** Pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Candidate periodontitis; missing discoloration, radiographic_caries and soft_tissue for unresolved caries |
| Pass / fail | **PASS — software** |

## Edge cases

<a id="tc15"></a>

### TC15 — Missing age group

**Steps:** Start a fresh consultation. Enter the symptom answers below, leave Age group Unknown, and attempt assessment.

| Question or action | Test answer / value |
| --- | --- |
| Age group | Unknown (default). |
| Dentition / tooth | Permanent affected tooth; FDI 36, reported by user. |
| Pain / duration / triggers | Yes; mild localized tooth pain for 2 days, provoked by cold; persistence Unknown. |
| Spontaneous / biting pain | Unknown / Unknown. |
| Gum symptoms / swelling / fever | Unknown / Unknown / Unknown. |
| History / professional findings | Unknown; no examination data supplied. |

**Expected response:** Please select age group before completing the assessment.

**Prohibited outcomes:** Assuming adulthood, deriving a clinical condition from default age group, or accepting missing age group as 0–5.

**Sources:** [Consultation input requirements](project-proposal.md#2-specific-domain-and-scope). Validation behavior is a project requirement, not a sourced clinical rule.

**Review status:** Pending software requirement review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Incomplete; request age group; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc16"></a>

### TC16 — Invalid numeric age-group value

**Steps:** Submit `obs(age_group,-2)` through the structured Prolog/JPL boundary and confirm rejection. The controlled UI permits only Unknown or the five listed groups; it cannot submit a numeric age.

| Question or action | Test answer / value |
| --- | --- |
| Age group | −2 (raw invalid numeric input). |
| Dentition / tooth | Unknown. |
| Pain / duration / triggers | Unknown / Unknown / Unknown. |
| Gum symptoms / history / examination | Unknown / Unknown / Unknown. |

**Expected response:** Age group must be a listed predefined value. Please correct it.

**Prohibited outcomes:** Silently converting −2 to 2 or zero, accepting the value, or returning a diagnosis.

**Sources:** [Interface input-validation responsibilities](architecture.md#java-interface-and-consultation-service). This is a software validation case.

**Review status:** Pending software requirement review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Invalid; reject numeric age_group -2; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc17"></a>

### TC17 — Required dentition and examination information unavailable

**Steps:** Start a fresh consultation. Enter all available symptoms, explicitly answer Unknown for dentition/findings, and attempt assessment.

| Question or action | Test answer / value |
| --- | --- |
| Age group | 6–12 years. |
| Dentition / affected tooth | Unknown primary/permanent; lower-left back tooth reported, FDI identity Unknown. |
| Pain / duration / severity | Yes; localized pain for 3 days; moderate. |
| Trigger / persistence | Cold drink; persistence Unknown. |
| Spontaneous / sleep / biting pain | Unknown / Unknown / Unknown. |
| Gum symptoms / swelling / drainage / fever | Unknown / No / No / No. |
| History | No recent trauma, restoration, or extraction reported; medical history Unknown. |
| Surface / pulp testing / percussion | Unknown / Unknown / Unknown. |
| Dentist-interpreted radiograph / periodontal examination | Unknown / Unknown. |

**Expected response:** Please provide the affected tooth type and available dental examination findings. Assessment incomplete.

**Prohibited outcomes:** Inferring tooth type from age, treating absent tests as negative, or returning an established diagnosis.

**Sources:** [AAPD: Primary and immature permanent teeth, pp. 487–488](https://www.aapd.org/media/Policies_Guidelines/BP_PulpTherapy.pdf); [project scope](project-proposal.md#2-specific-domain-and-scope). Exact follow-up fields are project requirements.

**Review status:** Pending software requirement review; supporting clinical data pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Incomplete; request affected tooth type; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc18"></a>

### TC18 — Contradictory tooth-pain answers

**Steps:** Enter both conflicting answers before assessment. If the UI prevents the second answer, verify it requests correction rather than silently choosing a value.

| Question or action | Test answer / value |
| --- | --- |
| Age group | 18–64 years. |
| Dentition / tooth | Permanent dentition; FDI 46 reported. |
| Is tooth pain present? | No. |
| Does tooth pain occur spontaneously? | Yes; spontaneous tooth pain for 3 days. |
| Trigger / duration / severity / biting pain | Unknown / Unknown / Unknown / Unknown. |
| Gum symptoms / history / examination | Unknown / Unknown / Unknown. |

**Expected response:** Your tooth-pain answers conflict. Please clarify whether tooth pain is present.

**Prohibited outcomes:** Selecting one conflicting answer silently or returning a diagnosis before clarification.

**Sources:** [Contradictory-input handling](architecture.md#5-failure-handling-and-verification). This is a project consistency requirement.

**Review status:** Pending software requirement review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Conflict; clarify tooth-pain answers; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc19"></a>

### TC19 — Jaw clicking outside the supported presentation scope

**Steps:** Start a fresh consultation, enter the jaw-clicking complaint with explicit negative tooth/gum symptoms, and attempt assessment.

| Question or action | Test answer / value |
| --- | --- |
| Age group | 18–64 years. |
| Dentition / region | Permanent dentition reported; jaw joint area, no affected tooth. |
| Tooth pain / thermal symptoms | No / Not applicable. |
| Gum bleeding / swelling / redness / tenderness | No / No / No / No. |
| Other complaint / duration / trigger | Jaw clicking for 2 months when opening the mouth. |
| Facial swelling / drainage / fever | No / No / No. |
| Trauma / recent restoration / extraction | No / No / No. |
| Dental examination / image findings | Unknown; not supplied. |

**Expected response:** This presentation is outside the supported tooth-pain and gum-symptom scope. No supported dental conclusion.

**Prohibited outcomes:** Diagnosing a jaw disorder, forcing one of the five dental targets, or declaring that all dental disease is excluded.

**Sources:** [Supported tooth-pain and gum-symptom scope](project-proposal.md#2-specific-domain-and-scope). This tests scope routing, not diagnosis of jaw clicking.

**Review status:** Pending software requirement review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Outside supported scope; no candidates |
| Pass / fail | **PASS — software** |

<a id="tc20"></a>

### TC20 — Reset after a completed consultation

**Steps:** Run TC11 and record its result. Click New consultation/Reset. Attempt assessment without entering new data. Run using forward chaining.

| Question or action | Test answer / value |
| --- | --- |
| Before reset | All TC11 question/answer rows; target candidate gingivitis. |
| Action | Click New consultation/Reset after the result is returned. |
| After reset: age group / dentition / tooth | Unknown / Unknown / Unknown; fields cleared. |
| After reset: symptoms / duration / triggers / history | Unknown / Unknown / Unknown / Unknown; fields cleared. |
| After reset: examination findings | Unknown; cleared. |
| After reset: prior result | No candidate displayed or reused. |

**Expected response:** Please select age group and start a new consultation. No previous candidate or input remains.

**Prohibited outcomes:** Reusing the 13–17 age group, TC11 symptoms/findings, or the previous gingivitis candidate; a delayed old result repopulating the screen.

**Sources:** [Consultation lifecycle and reset](architecture.md#3-consultation-data-flow-and-lifecycle). This is a lifecycle test using TC11 as setup, not an additional clinical case.

**Review status:** Pending software requirement review; supporting clinical data pending dentist review.

| Execution record | Forward chaining |
| --- | --- |
| Application / knowledge-base version | 1.0.0 / 0.2.0 |
| Date / tester | 2026-09-29 / automated Prolog + JPL checks |
| Actual response | Incomplete; request age group; no candidates |
| Pass / fail | **PASS — software** |

## Acceptance and maintenance

The catalogue has exactly 20 cases: TC01–TC14 are diagnostic candidates and TC15–TC20 are edge cases. Both modes use identical clinical evidence. Additional supported candidates are allowed, but prohibited outcomes fail the case. A software exception is not a valid outside-scope or incomplete-assessment response.

Record observed forward-chaining responses in the tables on every knowledge revision. Where the UI blocks an invalid input before Prolog is called, record that validation result for the attempted assessment. Do not mark an unexecuted case as passing. Record expert revisions before changing expected clinical outcomes; do not edit expectations merely to make a failing implementation pass.

The executable fixtures are in `knowledge/acceptance.pl`; Java/JPL integration and control tests are in `src/test/java/dental/IntegrationTest.java`. Run `./scripts/test.sh`. Case data do not count toward the 25 rules or 30 authored domain facts. The full test programme must also check target-platform packaging, integration failures, and reasoning termination as specified in the proposal and architecture.
