# Agent Roles & Delegation — Specialized Agent Personas

Version: 1.0.0
Status: Normative
Scope: `.agents/governance/**`

This document defines the specialized agent roles available within the Agent
Harness OS. Roles provide structured personas with scoped responsibilities,
enabling focused, high-quality outputs at each stage of the SDLC.

Inspired by MetaGPT's `Code = SOP(Team)` philosophy where software is produced
by materializing Standard Operating Procedures and applying them to teams
of specialized agents, and ECC's 36 specialized agents with YAML-defined
capabilities and permissions.

---

## 1) Core Principle: Code = SOP(Team)

Software quality is maximized when each role:
1. Has a **single, clear responsibility**
2. Produces **structured output** that serves as input to the next role
3. Follows a **defined SOP** (Standard Operating Procedure)
4. Operates within its **declared trust tier**

---

## 2) Role Catalog

### Planning & Design Roles

#### Planner
| Attribute | Value |
|:---|:---|
| **Responsibility** | Task decomposition, timeline estimation, backlog management |
| **Trust Tier** | T0 (ReadOnly) |
| **SOP Input** | User requirement, existing backlog |
| **SOP Output** | Task breakdown in TODO.md, priority assignments |
| **Watches For** | New requirements, scope changes |
| **Invocation** | "Operating as: planner" |

#### Architect
| Attribute | Value |
|:---|:---|
| **Responsibility** | System design, API contracts, component boundaries |
| **Trust Tier** | T0 (ReadOnly) |
| **SOP Input** | Task breakdown, existing codebase analysis |
| **SOP Output** | Design document, API specifications, data models |
| **Watches For** | Architectural changes, new component proposals |
| **Invocation** | "Operating as: architect" |

---

### Implementation Roles

#### Implementer
| Attribute | Value |
|:---|:---|
| **Responsibility** | Code writing, feature implementation, bug fixes |
| **Trust Tier** | T1 (WorkspaceWrite) |
| **SOP Input** | Design document, test specifications |
| **SOP Output** | Source code, implementation notes |
| **Watches For** | Implementation tasks, assigned work items |
| **Invocation** | "Operating as: implementer" |

#### Tester
| Attribute | Value |
|:---|:---|
| **Responsibility** | Test writing, test execution, coverage analysis |
| **Trust Tier** | T1 (WorkspaceWrite) |
| **SOP Input** | Design document, source code |
| **SOP Output** | Test files, coverage report, validation results |
| **Watches For** | Test coverage gaps, new implementations |
| **Invocation** | "Operating as: tester" |

---

### Quality Roles

#### Reviewer
| Attribute | Value |
|:---|:---|
| **Responsibility** | Code review, quality gate validation, standards compliance |
| **Trust Tier** | T0 (ReadOnly) |
| **SOP Input** | Source code, test results, coding standards |
| **SOP Output** | Review findings, approval/rejection, improvement suggestions |
| **Watches For** | Completed implementations, PRs |
| **Invocation** | "Operating as: reviewer" |

#### Security Reviewer
| Attribute | Value |
|:---|:---|
| **Responsibility** | Security audit, vulnerability detection, CVE assessment |
| **Trust Tier** | T0 (ReadOnly) |
| **SOP Input** | Source code, dependency list, security standards |
| **SOP Output** | Security findings, risk assessment, remediation guidance |
| **Watches For** | Security-sensitive changes, dependency updates |
| **Invocation** | "Operating as: security-reviewer" |

---

### Operations Roles

#### Documenter
| Attribute | Value |
|:---|:---|
| **Responsibility** | Documentation writing, changelog updates, API docs |
| **Trust Tier** | T1 (WorkspaceWrite) |
| **SOP Input** | Source code, design documents, review findings |
| **SOP Output** | Documentation files, updated README, changelogs |
| **Watches For** | Documentation gaps, completed features |
| **Invocation** | "Operating as: documenter" |

#### Releaser
| Attribute | Value |
|:---|:---|
| **Responsibility** | Release management, versioning, rollback preparation |
| **Trust Tier** | T3 (FullAccess) |
| **SOP Input** | All completed work, test results, review approvals |
| **SOP Output** | Release candidate, version tag, release notes |
| **Watches For** | Release candidates, version milestones |
| **Invocation** | "Operating as: releaser" |

---

## 3) Role Invocation Protocol

### Declaration
When operating in a specific role, the agent SHOULD declare it:
```
Operating as: reviewer
```

This is **advisory**, not prescriptive — agents may operate in multiple roles
during a single task. The declaration helps with:
- Audit trail (which role produced which output)
- Trust tier enforcement (role constrains available permissions)
- SOP compliance (role-specific checklists apply)

### Role Transitions
An agent may transition between roles within a task:
```
[planner] → Decomposed task into 4 subtasks
[architect] → Designed API contract for auth module
[implementer] → Writing implementation...
[reviewer] → Self-reviewing before submission
```

### Single-Agent Mode
When only one agent instance is available, it cycles through roles
sequentially, following the workflow pipeline defined in
`workflow-pipelines.md`.

### Multi-Agent Mode
When multiple agent instances are available, roles can be parallelized:
- planner + architect can work simultaneously on different tasks
- reviewer MUST NOT be the same instance as implementer (separation of
  concerns)

---

## 4) Sequential Handoff Protocol

Inspired by MetaGPT's structured document passing:

```
planner ──[TODO.md]──► architect ──[design.md]──► implementer
                                                       │
                                                  [source code]
                                                       │
                                              tester ◄─┘
                                                │
                                          [test results]
                                                │
                                         reviewer ◄─┘
                                                │
                                        [review findings]
                                                │
                                        documenter ◄─┘
                                                │
                                          [docs + changelog]
                                                │
                                         releaser ◄─┘
```

### Handoff Requirements
Each handoff MUST include:
1. **Structured artifact**: The output document from the previous role
2. **Completion signal**: Confirmation that the role's SOP is complete
3. **Evidence**: Timestamped proof of work (per `quality-gates.md`)

---

## 5) Custom Roles

Projects MAY define custom roles in their root `AGENTS.md`:

```markdown
## Custom Agent Roles

### Data Analyst
| Attribute | Value |
|:---|:---|
| **Responsibility** | Data analysis, visualization, insight generation |
| **Trust Tier** | T1 |
| **SOP Input** | Data sources, analysis requirements |
| **SOP Output** | Analysis report, visualizations |
```

Custom roles:
- MUST declare a trust tier
- MUST define SOP inputs and outputs
- MUST NOT override core role definitions
- MAY extend the sequential handoff chain

---

## 6) Relationship to Other Standards

| Standard | Relationship |
|:---|:---|
| `approval-policy.md` | Trust tier per role determines approval requirements |
| `workflow-pipelines.md` | Defines the sequence in which roles execute |
| `hooks-policy.md` | `PreTask` hook assigns the initial role |
| `quality-gates.md` | Each role has role-specific quality gates |
| `how-to-code-review.md` | Reviewer role follows these review standards |
| `how-to-strict-review.md` | Security reviewer follows strict review |
| `execution-policy.md` | Task lane maps to starting role |
