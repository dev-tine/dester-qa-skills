# Plain-language glossary

One line each. Use these when explaining to someone new.

| Word | Meaning |
|---|---|
| Exploratory testing | Using the app with a goal and curiosity, and writing down what you find, instead of following a fixed script. |
| Charter | A one-sentence mission for a testing session: "Explore X using Y to find Z". |
| Session | A timeboxed block (30 to 90 min) of testing for one charter. |
| Derived spec | A description of how the app behaves, written by observing it, because no official spec exists. It is a draft, not truth. |
| Oracle | How you decide something is wrong (it contradicts another screen, common sense, the law of math, a competitor). |
| Heuristic | A rule of thumb that suggests where bugs hide. |
| Happy path | Everything goes right: valid input, normal user. |
| Negative test | Wrong input or wrong action, to see if the app copes. |
| Edge / boundary | The smallest, largest and just-over-the-limit values (0, 1, max, max+1). |
| Role / permission | What each type of user (admin, merchant, employee) is allowed to see and do. |
| IDOR | Changing an ID in the URL or request to see someone else's data. |
| Regression | Something that used to work and now is broken after a change. |
| Severity | How bad the bug is (Critical, High, Medium, Low). |
| Priority | How soon it should be fixed. |
| Evidence | Proof: screenshot, video, response, exported file. |
| Blocked | I could not test it (no access, no data, feature missing). |
| Flaky | Sometimes fails, sometimes passes, with the same steps. |
| Staging | A copy of the system used for testing, not the real one. |
| Traceability | A link from each requirement to its test and its result. |
