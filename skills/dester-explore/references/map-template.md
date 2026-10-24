# 01_MAP.md template

Author: Destine April | dester-explore v0.1.0 | Status: DRAFT

## 1. Modules x roles

Cell values: `seen` (opened and used), `view` (can only look), `denied` (blocked, with how: hidden, error, redirect),
`not seen` (not checked yet), `?` (unknown).

| Module / page | Admin | Merchant | Employee | Notes |
|---|---|---|---|---|
| Dashboard | seen | seen | view | |
| Payouts | seen | view | denied (hidden in menu) | direct URL not tried yet |

## 2. Flows

```
F1 <name> (risk: high)
1. <Role> does <action> in <module>  -> creates/changes <data>
2. ...
Shows up in: <lists, totals, reports, notifications>
```

## 3. Data objects

| Object | Key fields | Statuses seen | Who creates | Who changes | Appears in |
|---|---|---|---|---|---|

## 4. Settings that change behavior

| Setting | Where | What it seems to affect | Confidence |
|---|---|---|---|

## 5. Integrations and unknowns

Emails, SMS, payments, exports, imports, third parties, and anything not understood yet.
