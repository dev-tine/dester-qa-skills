# Lens checklists

Author: Destine April | dester-lens v0.1.0

Pick the items that fit the area. Each item is a question to answer with evidence.

## 1. Senior QA engineer

- Purpose: what is this for? Does it do that for the main path, first?
- Rules: every limit, formula, status change and message: is it stated, consistent, and enforced on the server (not
  only on screen)?
- State: does it survive refresh, back button, two tabs, session expiry, double click on submit?
- Dependencies: what else changes when this changes (lists, totals, reports, notifications, history)?
- Errors: what does a failure look like to the user? Can they recover? Are errors honest (no "Saved" when not saved)?
- Idempotence: do the same action twice and see if it duplicates.
- Data lifecycle: create, edit, archive, delete, restore: what happens to related records and history?
- Concurrency: two users editing the same record.
- Regression magnets: recently changed areas, complex forms, anything with many conditions.
- What was not built that a user would expect (empty states, undo, confirmations, search, export)?

## 2. End user, per role

For each role (admin, merchant, employee, customer...):
- Goal: what is this person trying to get done? Can they, in how many steps?
- Sees: menu items, cards, tabs, buttons, data. Anything they should not see (other users' or other tenants' data,
  admin controls)?
- Can: every key action. Anything they should be able to do but cannot?
- Cannot: try the forbidden: hidden menu item by direct URL, button hidden but action allowed, edit another user's
  record. Do menu, button, URL and data all agree?
- Language: does the wording fit this person (no internal jargon)?
- Notifications: do they get what they need, and nothing meant for others?
- First visit: onboarding, empty states, defaults.

## 3. UX and UI

- Clarity: can a first-time user tell what each screen is for and what to do next?
- Consistency: same words, icons, button placement, date and money formats everywhere.
- Feedback: loading, success, error, disabled states; does a click always show a response?
- Forms: labels, required marks, helpful errors, keep input on error, sensible defaults and tab order.
- Navigation: where am I, how do I go back, breadcrumbs, links that open in new tabs.
- Layout: alignment, overflow, truncation, long text, many rows, empty list.
- Responsive: phone, tablet, narrow window; nothing cut off, tap targets big enough.
- Visual: contrast, spacing, typos, broken images, wrong icons.
- Destructive actions: confirmation with clear consequence.

## 4. Accessibility (basic checks; say "basic" in the report)

- Keyboard only: reach every control with Tab, visible focus, logical order, no traps, Esc closes dialogs.
- Names: every button, link, icon and input has a text label (visible or aria).
- Headings and landmarks: one main heading, sensible order.
- Contrast: text readable against its background; not color alone to show state (errors, status).
- Zoom: 200 percent zoom, text still readable and usable.
- Forms: errors announced and tied to fields; required fields identified.
- Images: meaningful alt text; decorative ones ignored.
- Motion and timeouts: nothing flashes; session timeouts warn.
Automated scan (axe through Playwright) can be added via `dester-check`; automated tools find only part of the issues.

## 5. Business process and flow

- Map the flow end to end (use `01_MAP.md` flows). Walk it as the real roles in order with one fictional case.
- At each handoff: does the next role see the right thing at the right time?
- Statuses: each change allowed, blocked or reversible as the business expects? Can a record get stuck?
- Exceptions: cancel, refund, reject, resubmit, edit after approval, partial completion, backdated entries.
- Cross-module: the same fact (a customer, an amount) consistent in every module it touches.
- Notifications and side effects (email, SMS, calendar, webhook): triggered once, to the right people.
- Audit: does the history show who did what and when?
- Month-end or cut-off behavior if the business has one.

## 6. Data accuracy

- Pick 3 to 5 numbers per screen or report. Recalculate by hand from source records. Write the working.
- Totals equal the sum of the rows; row counts equal list counts; filters change totals correctly.
- Percentages, fees, taxes, discounts, splits and rounding (what happens at .005, with 3 or 7 people?).
- Currency and decimals: symbols, separators, negative values, zero, very large.
- Dates and time zones: today, boundaries, month end, ranges inclusive or exclusive; the same time shown the same way.
- Same number on every screen: dashboard, detail, report, export, email.
- Export: CSV or file equals the screen (columns, order, count, formatting, special characters).
- Reports with a date range: check first and last day, empty range, one record.
- Stale data: change a record, then check every place that shows it, without a manual refresh and after one.

## 7. Negative and edge cases

- Empty, spaces only, very long (255, 1000, 100000), special characters, emoji, quotes, angle brackets, other
  languages, leading and trailing spaces.
- Numbers: 0, 1, negative, decimals, huge, scientific notation, thousand separators.
- Dates: past, far future, invalid (Feb 30), today, midnight.
- Duplicates: same name, same email with different case, same record twice.
- Order: skip a step, go back, resubmit, open a link from an old session.
- Double submit, rapid clicks, refresh after submit.
- Wrong role, expired session, deleted related record, removed option.
- Upload (if any): wrong type, too big, empty file, odd file name.
- Interruptions: network off, slow response.
Never use real personal data; never run bulk or destructive inputs against shared data.
