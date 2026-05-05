# Development Guidelines

## Code Quality
- **Keep code simple, testable, and well-documented**
  - *Easy to understand, modify, and maintain by both humans and AI*

- **Write tests alongside code, not after**
  - *Prevents technical debt and catches issues early*

- **Document the "why," not just the "what"**
  - *Code shows implementation; docs explain intent and context*

## Integration & Delivery
- **Merge early, merge often**
  - *Reduces conflicts and enables faster feedback*
  - Use feature flags for high-risk changes

- **Leverage CI/CD and automation**
  - *Ensures consistency and catches issues before production*

- **Keep main branch always deployable**
  - *Enables rapid releases and reduces deployment risk*

## Collaboration
- **Require code reviews before merging**
  - *Maintains quality and shares knowledge across the team*

- **Make work visible and define "done" explicitly**
  - *Prevents ambiguity and keeps everyone aligned*


# Ticket Workflow

## Stages
1. **Design**
2. **Development**
3. **QA**
4. **UAT**
5. **Completed**

---

## Statuses for Active Stages (Design → UAT)
- **Pending** → waiting to start
- **In Progress** → actively being worked on
- **Blocked** → cannot proceed due to an issue
- **Cancelled** → ticket abandoned
- **Closed** -> ticket closed

## Status for Completed Stage
- **Completed** → work fully finished and deployed

---

## Workflow Diagram
```
┌────────┐
│ Design │
└────────┘
    │
    v
┌─────────────┐
│ Development │
└─────────────┘
    │
    v
┌─────┐
│ QA  │
└─────┘
    │
    v
┌─────┐
│ UAT │
└─────┘
    │
    v
┌───────────┐
│ Completed │
└───────────┘
```

---

## How It Works
1. Tickets start in **Design** with **Pending**.
2. Status moves to **In Progress** as work begins.
3. If blocked, status moves to **Blocked**.
4. Once work in a stage is finished → move ticket to the next stage (status resets to **Pending**).
5. Repeat through **Development → QA → UAT**.
6. When all stages are finished → move to **Completed**.
7. Tickets that are abandoned can be set to **Cancelled** at any stage.

# Dev Workflow
## Stage: Development
1. Create a new feature branch titled <ticket_id>-<shorthand-desc-of-ticket>
2. Switch to new branch.
3. Develop on branch. Make sure to follow "Commit Guidelines" (See below section)
while making commits.
4. Push and create new branch to remote `origin` repo.
5. Open up a pull request.
6. Wait until PR is approved by an approver.
7. If Approver request changes, either:
  a. accept requests and make improvements with additional commits to local branch,
  and then push them to remote branch.
  b. reply back to comments with good justifications for your code changes.
8. After all comments are resolved, make sure no conflicts with `main` branch. If there is,
resolve conflicts by either rebasing on top of latest `main`, or merging with latest `main`.

## Stage: QA
TODO

## Stage: UAT
10. After UAT is done, if PR is ready to merge, merge PR to `main` branch.

## Stage: Completed
11. Delete feature branch.


# Commit Guidelines

## Before Committing
- **Update the ticket file with your progress**
  - *Keeps work status current and visible to the team*

- **Ensure all tests pass locally**
  - *Prevents breaking CI/CD pipeline and wasting team time*

## Commit Message Format
- **Follow Commitizen conventional commit format**
  - *Enables automated changelog generation and semantic versioning*

  **Format:** `<type>(<scope>): <subject> [FT-XXX]`

  **Example:** `feat(auth): add OAuth2 login support [FT-123]`

### Commit Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring (no feature change or bug fix)
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, configs, etc.)
- `ci`: CI/CD pipeline changes

## Commit Best Practices
- **Link the ticket ID in every commit message**
  - *Provides traceability between code changes and requirements*
  - Format: `[AC-XXX]` at the end of the subject line

- **Keep commits atomic and focused**
  - *One logical change per commit makes reviews easier and rollbacks safer*

- **Write clear, descriptive subjects (50 chars or less)**
  - *Helps quickly scan git history and understand changes at a glance*

