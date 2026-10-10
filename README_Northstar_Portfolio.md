# Digital Loan Application Optimization

### Business Analysis Portfolio Project | Northstar Financial Services

> \*\*Project type:\*\* Simulated end-to-end Business Analysis case study  
> \*\*Industry:\*\* Financial services / digital lending  
> \*\*Core focus:\*\* Process improvement, data analysis, requirements engineering, solution design, and UAT

## Project overview

Northstar Financial Services experienced a decline in customers completing its online loan application after a V2 release. This project investigates the decline, uses synthetic data to examine potential contributing factors, and develops a future-state process and requirements for improving the application journey while preserving mandatory compliance controls.

**Important:** Northstar is a fictional organization and the dataset is synthetic. Findings and test outcomes are for portfolio demonstration; they are not claims about a real financial institution or production deployment.

## Business problem and objective

The stated business problem is a decline in online loan application completion from approximately **72% to 54%** following V2. The business objective is to restore completion to **above 70%**, without weakening mandatory compliance validation.

The project investigates upload failures, processing duration, session timeouts, service errors, abandonment, and mobile/web differences. The analysis is used to develop and assess solution options—not to assume a cause before reviewing evidence.

## Approach and BA deliverables

|Workstream|What it demonstrates|Key artifacts|
|-|-|-|
|Project initiation|Problem framing, scope, objectives, assumptions, constraints|`01\_Project\_Initiation/01\_Project\_Charter/`|
|Stakeholder analysis|Stakeholder identification and engagement planning|`02\_Stakeholder\_Analysis/01\_Stakeholder\_Register/`|
|Elicitation|Planning elicitation and documenting findings|`03\_Elicitation/`|
|Data analysis|SQL-based investigation using synthetic application, upload, compliance, and system-event data|`04\_Data\_Analysis/02\_Source\_Data/`; `04\_Data\_Analysis/03\_SQL\_Analysis/`|
|Root-cause assessment|Evidence matrix and technical validation|`04\_Data\_Analysis/04\_Root\_Cause\_Analysis/`|
|Requirements and process analysis|Future-state requirements, To-Be BPMN, and As-Is/To-Be comparison|`05\_Requirements/`|
|Solution design|Solution approach, components, requirements mapping, architecture, and impact analysis|`06\_Solution\_Design/`|
|Acceptance and traceability|Acceptance criteria and requirements traceability matrix|`07\_Acceptance\_Criteria\_and\_RTM/`|
|Validation and UAT|Test planning and execution records, defect management, release readiness, and performance-test preparation|`08\_Validation\_and\_UAT/`|

## Analysis highlights

The SQL analysis explores differences between V1 and V2 and examines associations between upload failures, timeouts, service errors, and abandonment. Current analysis outputs indicate:

* Overall completion declined materially after V2.
* Upload failure rates increased after V2.
* Upload duration increased after V2.
* Session timeouts and service errors increased after V2.
* Completion declined on both mobile and web, so the evidence does not support treating the issue as mobile-only.

These are **observed patterns in synthetic portfolio data**. Association does not by itself establish causation. The root-cause artifacts document the supporting evidence and the technical hypotheses requiring validation.

## Proposed solution direction

The future-state design focuses on improving document-processing resilience and customer recovery while retaining required compliance controls. The requirements and solution artifacts cover controlled handling of retryable and non-retryable failures, clearer customer status and recovery, avoiding unnecessary duplicate processing, and reusing a prior compliance result only when explicitly defined eligibility conditions are satisfied.

Any reuse of a prior validation result must not bypass a mandatory fresh check or reuse a stale result after a compliance-relevant change.

## Validation and current status

Validation and UAT artifacts are available in `08\_Validation\_and\_UAT/`.

* The simulated critical defect involving reuse of a stale compliance validation result was reported as fixed, with relevant retests passed and Compliance verification recorded.
* Performance acceptance remains unresolved: the measurement definition and thresholds require approval.
* **TC-012 remains blocked** until the performance criteria are approved and the test can be assessed against them.
* The remaining required UAT scenarios must have their execution outcomes recorded before UAT can be considered complete.
* No production release or achievement of the >70% business target is claimed.

The release recommendation must be based on recorded evidence, required approvals, and the project's release criteria. Schedule pressure alone is not a reason to bypass a mandatory gate.

Repository map
Digital-Loan-Application-Optimization/
├── 01\_Project\_Initiation/
├── 02\_Stakeholder\_Analysis/
├── 03\_Elicitation/
├── 04\_Data\_Analysis/
│   ├── 02\_Source\_Data/
│   ├── 03\_SQL\_Analysis/
│   └── 04\_Root\_Cause\_Analysis/
├── 05\_Requirements/
├── 06\_Solution\_Design/
├── 07\_Acceptance\_Criteria\_and\_RTM/
├── 08\_Validation\_and\_UAT/
└── README.md
```

## Skills demonstrated

* Business problem definition and scope management
* Stakeholder analysis and elicitation planning
* SQL-based exploratory analysis and evidence interpretation
* Root-cause hypothesis development and validation
* BPMN process modeling and As-Is/To-Be comparison
* Functional and non-functional requirements
* Acceptance criteria and requirements traceability
* Solution mapping and impact analysis
* UAT planning, defect retesting, risk tracking, and release-readiness assessment

## How to review this project

For a quick review, start with:

1. `01\_Project\_Initiation/01\_Project\_Charter/` — understand the business problem and scope.
2. `04\_Data\_Analysis/03\_SQL\_Analysis/` and `04\_Data\_Analysis/04\_Root\_Cause\_Analysis/` — review the analysis and evidence.
3. `05\_Requirements/02\_Future\_State\_Process/` — inspect the To-Be process model.
4. `06\_Solution\_Design/` and `07\_Acceptance\_Criteria\_and\_RTM/` — follow the proposed solution into testable requirements.
5. `08\_Validation\_and\_UAT/` — review test evidence, open blockers, and release-readiness status.

\---

*Portfolio note: This is a simulated case study built to demonstrate BA methods. All data and scenario outcomes should be interpreted within that context.*

