# Diagram templates (Mermaid)

Author: Destine April | dester-docs v0.1.0

Dashed arrows (`-.->`) and the word `unconfirmed` mark steps that were not seen working.

## Flow with roles as lanes

```mermaid
flowchart LR
  subgraph Customer
    A[Open tip page] --> B[Enter amount and pay]
  end
  subgraph Merchant
    C[See tip in dashboard]
  end
  subgraph Employee
    D[See share in payout page]
  end
  B --> C
  C -.->|unconfirmed: split rule| D
```

## Status lifecycle

```mermaid
stateDiagram-v2
  [*] --> Pending
  Pending --> Approved: Admin approves
  Pending --> Rejected: Admin rejects
  Approved --> Paid: Payout runs
  Paid --> [*]
```

## Module map (how data moves)

```mermaid
flowchart LR
  Sales -->|invoice| Accounting
  Inventory -->|stock levels| Sales
  HR -->|employee list| Payroll
  Payroll -->|journal entries| Accounting
```

## Sequence across systems

```mermaid
sequenceDiagram
  participant U as User
  participant S as System
  participant P as Payment provider
  U->>S: Submit payment
  S->>P: Charge
  P-->>S: Result
  S-->>U: Confirmation (email unconfirmed)
```

## Roles matrix (table, words not only color)

| Action | Admin | Merchant | Employee |
|---|---|---|---|
| View payouts | Allowed | Allowed | Own only |
| Edit tip rules | Allowed | Denied | Denied |
| Export report | Allowed | Not tested | Denied |

## Coverage summary

| Area | Cases | Run | Pass | Bug | Blocked | Not run |
|---|---|---|---|---|---|---|
