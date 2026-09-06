# Functional Requirements Document (FRD)

## Project: Gym Management Software — MVP (Version 1.0)

| Field | Value |
| ----- | ----- |
| Document type | Functional Requirements Document |
| Version | 1.0 |
| Status | Draft |
| Source | `docs/mvp-srs.md` (SRS 1.0, 16 May 2026) |
| Prepared for | Initial product development |
| Prepared by | Algoray |
| Document date | 06 Sep 2026 |

This FRD turns the SRS into **what the software must do**. It is written for product, development, and test. Technical stack, table names, and folder layout stay in the SRS unless they affect user-visible behaviour.

---

# 1. Purpose

The system shall help a gym:

- Register and manage members
- Sell and renew membership plans
- Control gym entry with biometric devices and door lock
- Bill members and keep accounts
- Buy, stock, and sell products
- Show reports and dashboards by role

MVP targets **one gym**. Data shall be stored so more branches can be added later, but multi-branch UI and franchise features are **out of scope**.

---

# 2. Scope

## 2.1 In scope (MVP freeze)

| ID | Module |
| -- | ------ |
| M1 | Users and roles (login) |
| M2 | Membership (members, plans, subscriptions, renewals, alerts) |
| M3 | Attendance and biometric (devices, entry, door, rules, dashboard) |
| M4 | Accounting (ledgers, invoices, payments, expenses, reports) |
| M5 | Inventory (items, purchase, stock, POS sale, reports) |
| M6 | Staff records (profile, role, attendance, salary fields — not full payroll) |
| M7 | Reports and dashboards |
| M8 | Audit log, backup/restore, offline gym operations |

## 2.2 Out of scope (postponed)

Do **not** build in Version 1.0:

- Member mobile app and member self-login
- Trainer management beyond “assigned trainer” on the member
- Workout plans, diet plans, class scheduling, locker management
- WhatsApp, SMS, push notifications (email + in-app only)
- Online payments (Razorpay, Stripe), online membership purchase
- QR attendance, face recognition as a product feature, CCTV, AI assistant
- Multi-branch operations, franchise, central multi-gym dashboard
- Full payroll

If a request is not in section 2.1, it is **rejected** until a later version.

---

# 3. Users and permissions

## 3.1 Roles

| Role ID | Role name | Who | MVP login |
| ------- | --------- | --- | --------- |
| R-ADM | Admin | Gym owner / manager | Yes |
| R-REC | Reception Staff | Front desk | Yes |
| R-TRN | Trainer | Floor trainer | Yes |
| R-ACC | Accountant | Accounts person | Yes |
| R-INV | Inventory Manager | Store / counter stock | Yes |
| R-MEM | Member | Gym customer | **No** (future app) |

## 3.2 Permission matrix (MVP)

| Function | Admin | Reception | Trainer | Accountant | Inventory Mgr |
| -------- | :---: | :-------: | :-----: | :--------: | :-----------: |
| Login / logout | Y | Y | Y | Y | Y |
| Manage users and roles | Y | N | N | N | N |
| Register / edit members | Y | Y | N | N | N |
| Create / edit membership plans | Y | N | N | N | N |
| Subscribe / renew / upgrade / downgrade / extend | Y | Y | N | N | N |
| Take membership and POS payments | Y | Y | N | Y | N |
| View assigned members only | Y | Y | Y | N | N |
| View all members | Y | Y | N | N | N |
| Enrol / delete biometric for a member | Y | Y | N | N | N |
| Add / configure biometric devices | Y | N | N | N | N |
| View attendance (all) | Y | Y | N | N | N |
| View attendance (assigned members) | Y | Y | Y | N | N |
| Manual door unlock (emergency, audited) | Y | Y | N | N | N |
| Invoices, receipts, payments, expenses | Y | Limited* | N | Y | N |
| Full ledgers, P&L, GST, cashbook | Y | N | N | Y | N |
| Item master, purchase, stock adjust | Y | N | N | N | Y |
| POS sale of products | Y | Y | N | N | Y |
| Staff profiles | Y | N | N | N | N |
| Admin dashboard | Y | N | N | N | N |
| Reception dashboard | Y | Y | N | N | N |
| Accountant dashboard | Y | N | N | Y | N |
| Backup / restore | Y | N | N | N | N |
| View audit logs | Y | N | N | N | N |

\*Reception **Limited** accounting: create member/POS invoices, record payment, print/view those invoices. No delete of posted invoices, no journal reverse, no expense posting, no GST/P&L unless Admin grants it later. MVP: Reception cannot post expenses or journals.

## 3.3 Security functions

| ID | Requirement |
| -- | ----------- |
| FR-SEC-01 | User shall log in with username and password. |
| FR-SEC-02 | System shall reject login if user is inactive. |
| FR-SEC-03 | Passwords shall be stored hashed (never plain text). |
| FR-SEC-04 | After login, the user shall see only screens and actions allowed by their role. |
| FR-SEC-05 | User shall log out. Session shall end on logout. |
| FR-SEC-06 | 2FA is **out of scope** for MVP. |
| FR-SEC-07 | Login screen shall offer username, password, remember login, and branch field (branch stored for future; MVP may have one default branch). |

---

# 4. Common rules (all modules)

| ID | Requirement |
| -- | ----------- |
| FR-COM-01 | Every create/update shall record `created_at` / `updated_at` where data is stored. |
| FR-COM-02 | Soft-delete or cancel shall be used instead of hard-delete for posted money documents (see BR-10). |
| FR-COM-03 | Search shall work by name, phone, member code, and barcode/item code where those exist. |
| FR-COM-04 | Date and time shall use the gym’s local clock. Attendance timestamps shall come from the device or server, stored in one consistent timezone per gym. |
| FR-COM-05 | Validation errors shall be shown in plain language on screen. |
| FR-COM-06 | The gym shall keep working **without internet** for: membership lookup, attendance, door access, billing, inventory, and accounting. Changes shall sync when internet returns. |
| FR-COM-07 | LAN is required for devices and clients. Internet is optional. |

---

# 5. Module: Membership

## 5.1 Member registration

| ID | Requirement |
| -- | ----------- |
| FR-MEM-01 | Reception and Admin shall create a member profile. |
| FR-MEM-02 | System shall auto-generate a unique Member ID / member code. |
| FR-MEM-03 | Profile shall capture: full name, photo, mobile, email, address, gender, DOB, emergency contact, blood group, joining date, height, weight, medical conditions, assigned trainer. |
| FR-MEM-04 | User shall upload ID proof and consent form. |
| FR-MEM-05 | User may enrol fingerprint after save (optional in the same flow). |
| FR-MEM-06 | On successful registration with a paid plan, member status shall become **Active** (see workflow New Member Enrollment). |
| FR-MEM-07 | Admin and Reception shall edit member profile. Trainer shall not edit. |
| FR-MEM-08 | Duplicate mobile number shall warn the user. Save may continue only after confirm (MVP: warn, do not hard-block unless product later tightens this). |
| FR-MEM-09 | Member shall **not** share one membership with another person (BR-04). System shall bind one subscription to one member_id. |

**Acceptance (FR-MEM)**

- Given a logged-in Reception user and at least one plan, when they complete registration and payment, then a member exists with unique ID, subscription, and invoice.
- Photo and documents are stored and can be opened later from the member screen.

## 5.2 Membership plans

| ID | Requirement |
| -- | ----------- |
| FR-PLAN-01 | Admin shall create, edit, and deactivate plans. Reception shall not create plans. |
| FR-PLAN-02 | Plan fields: name, duration (days), price, tax, freeze allowed (yes/no), max visits (number or unlimited). |
| FR-PLAN-03 | Sample plan types the gym can configure: Monthly, Quarterly, Half Yearly, Annual, Personal Training, Premium. These are data, not hard-coded product SKUs. |
| FR-PLAN-04 | Inactive plans shall not appear in new subscribe/renew pickers. Existing subscriptions keep their plan. |

## 5.3 Subscription

| ID | Requirement |
| -- | ----------- |
| FR-SUB-01 | A member shall subscribe to one current gym-access plan at a time for door access. (PT add-ons may be invoiced separately; door access uses the access subscription.) |
| FR-SUB-02 | System shall store start date, expiry date, remaining days, remaining visits, freeze days, status, linked invoice. |
| FR-SUB-03 | Status values: Active, Expired, Suspended, Frozen, Cancelled. |
| FR-SUB-04 | Remaining days shall be computed from expiry date vs today. |
| FR-SUB-05 | If max visits is set, remaining visits shall decrease on granted entry. When remaining visits hit 0, further entry shall be denied until renewed/extended. |

## 5.4 Renew / change plan

| ID | Requirement |
| -- | ----------- |
| FR-SUB-06 | Reception and Admin shall Renew, Upgrade, Downgrade, or Extend a membership. |
| FR-SUB-07 | Each of those actions shall generate an invoice and, after payment recording, update start/expiry/status. |
| FR-SUB-08 | Renew: new period from current expiry if still active, or from today if expired (document the chosen rule in UI: “from expiry” vs “from today”). **MVP default:** if Active, new expiry = old expiry + plan duration; if Expired, new start = today, expiry = today + duration. |
| FR-SUB-09 | Upgrade/Downgrade: switch plan; price difference invoiced (full new plan price on MVP unless Admin sets discount on the invoice). |
| FR-SUB-10 | Extend: add days without changing plan name; invoice as configured. |

## 5.5 Freeze

| ID | Requirement |
| -- | ----------- |
| FR-SUB-11 | If the plan allows freeze, Admin/Reception may freeze an Active membership for N days. |
| FR-SUB-12 | Freeze shall set status to Frozen and **extend expiry by N days** (BR-03). Example: 30-day plan, freeze 5 days → expiry moves +5 days. |
| FR-SUB-13 | Frozen members shall be denied gym entry until unfrozen. |
| FR-SUB-14 | Unfreeze shall return status to Active if expiry is still in the future. |

## 5.6 Suspend / cancel

| ID | Requirement |
| -- | ----------- |
| FR-SUB-15 | Admin may Suspend a member. Suspended members are denied entry (BR-02). |
| FR-SUB-16 | Admin may Cancel a subscription. Cancelled members are denied entry. Door access shall be disabled. |

## 5.7 Membership alerts

| ID | Requirement |
| -- | ----------- |
| FR-ALT-01 | System shall flag memberships expiring in 7 days. |
| FR-ALT-02 | System shall flag expired memberships. |
| FR-ALT-03 | System shall flag payment pending (unpaid / partial invoices). |
| FR-ALT-04 | Alerts shall show in-app (dashboards and member screen). |
| FR-ALT-05 | System shall send **email** for FR-ALT-01, FR-ALT-02, FR-ALT-03 when email exists and gym email is configured. |
| FR-ALT-06 | SMS and WhatsApp are out of scope. |

---

# 6. Module: Attendance and biometric

## 6.1 Device setup

| ID | Requirement |
| -- | ----------- |
| FR-BIO-01 | Admin shall add a device: name, IP, port, SDK type, branch. |
| FR-BIO-02 | Admin shall test connection before or after save and see success or fail. |
| FR-BIO-03 | System shall store device status and last sync time. |
| FR-BIO-04 | Supported device classes: fingerprint readers (e.g. ZKTeco), other SDK readers, RFID, door relay. Face hardware may exist on a device; **face-as-product-feature** is out of scope. |
| FR-BIO-05 | Admin shall enrol a member on a device (map gym member ↔ device user id). |
| FR-BIO-06 | Admin shall delete a member from a device when membership is cancelled or on request. |
| FR-BIO-07 | System shall sync attendance from the device (import and/or realtime). |
| FR-BIO-08 | System shall command door relay: unlock on allowed entry; keep locked on reject. |

## 6.2 Gym entry (core flow)

| ID | Requirement |
| -- | ----------- |
| FR-ATT-01 | When a fingerprint is recognised, system shall identify the member. |
| FR-ATT-02 | System shall check membership is **Active** (not Expired, Suspended, Frozen, Cancelled). |
| FR-ATT-03 | System shall check attendance rules (visit limit, time window, duplicate window). |
| FR-ATT-04 | If all checks pass: record attendance, unlock door, allow entry. |
| FR-ATT-05 | If any check fails: do **not** unlock, do **not** count a valid visit, show reason (at least on device/display or reception screen): e.g. “Membership Expired”. |
| FR-ATT-06 | Attendance record shall store: member, device id, check-in time, access granted (yes/no), remarks. Checkout time may be empty in MVP if the gym is entry-only. |
| FR-ATT-07 | Door unlock after a valid decision shall complete in **under 1 second** (target). Attendance write shall complete in **under 2 seconds** (target). |

## 6.3 Access rules

| ID | Requirement |
| -- | ----------- |
| FR-ATT-08 | Gym (Admin) shall configure per plan or gym default: one entry/day, unlimited, or max visits from plan. |
| FR-ATT-09 | Admin shall configure allowed time window (example: 5:00 AM–10:00 PM). Entry outside window shall be rejected (BR-06). |
| FR-ATT-10 | Duplicate scans within a configurable period (default **5 minutes**) shall be ignored: no second attendance row, door may stay as already handled (BR-05). |
| FR-ATT-11 | Expired membership → deny (BR-01). Suspended → deny (BR-02). Visit limit exceeded → deny. |

## 6.4 Attendance views

| ID | Requirement |
| -- | ----------- |
| FR-ATT-12 | Attendance dashboard shall show: today’s visits, members currently inside (if checkout unused, “inside” may mean “entered today and not marked out” — MVP may show today’s unique entries instead if checkout is not used), peak hours, frequent visitors. |
| FR-ATT-13 | Reception and Admin shall see all attendance. Trainer shall see assigned members only. |
| FR-ATT-14 | Failed attendance and failed biometric sync shall raise in-app alerts (and email if configured). |

---

# 7. Module: Accounting

Accounting shall be **double-entry from day one** (BR-09). Every money event posts to two accounts.

## 7.1 Books

| ID | Requirement |
| -- | ----------- |
| FR-ACC-01 | System shall maintain ledgers for customers (members), vendors, expenses, and income. |
| FR-ACC-02 | Default account types: Assets, Liabilities, Income, Expenses, Equity. |
| FR-ACC-03 | System shall support receipts, payments, journal entries, contra, and expenses. |
| FR-ACC-04 | Accountant and Admin shall post expenses (examples: electricity, rent, salary, equipment, marketing). Reception shall not. |

## 7.2 Member billing

| ID | Requirement |
| -- | ----------- |
| FR-ACC-05 | System shall generate invoices for: membership, PT sessions, supplements/products, locker rental (locker as invoice line type even if locker module is later). |
| FR-ACC-06 | Invoice shall have number, date, member, lines (type, qty, rate, amount), discount, tax, grand total, payment status (unpaid / partial / paid). |
| FR-ACC-07 | Posted invoices **cannot be deleted**. User may cancel or reverse only (BR-10). Reverse shall create a reversing accounting entry. |
| FR-ACC-08 | Payment methods: Cash, Card, UPI, Bank Transfer, Wallet. |
| FR-ACC-09 | Recording a payment shall update invoice status and post accounts (e.g. Debit Cash/Bank, Credit Income or Receivable per gym setup). |
| FR-ACC-10 | Example membership sale ₹1000: Debit Cash 1000, Credit Membership Income 1000 (when paid immediately). |

## 7.3 Accounting reports

| ID | Requirement |
| -- | ----------- |
| FR-ACC-11 | Daily collection |
| FR-ACC-12 | Profit and Loss |
| FR-ACC-13 | Outstanding payments |
| FR-ACC-14 | Cashbook |
| FR-ACC-15 | Ledger report |
| FR-ACC-16 | GST report (India) |

---

# 8. Module: Inventory

## 8.1 Items

| ID | Requirement |
| -- | ----------- |
| FR-INV-01 | Inventory Manager and Admin shall maintain item master: item code, barcode, name, category, purchase price, selling price, tax, stock, min stock, supplier. |
| FR-INV-02 | Categories include (examples, not a closed list): supplements, protein, water bottles, merchandise, equipment, snacks. |

## 8.2 Stock movements

| ID | Requirement |
| -- | ----------- |
| FR-INV-03 | Purchase entry: supplier, qty, rate, supplier invoice; stock increases; accounts update. |
| FR-INV-04 | Movements: Purchase, Sale, Damage, Adjustment, Consumption, Transfer (Transfer reserved for future branches; MVP may hide Transfer in UI). |
| FR-INV-05 | **Negative stock is prohibited** (BR-07). Sale/adjust that would go below zero shall be blocked with a clear error. |
| FR-INV-06 | When stock falls below minimum, raise low-stock alert (BR-08). |

## 8.3 POS sale

| ID | Requirement |
| -- | ----------- |
| FR-INV-07 | Reception, Inventory Manager, and Admin shall sell items at POS: search/scan, qty, collect payment, generate invoice, reduce stock. |
| FR-INV-08 | Inventory screen shall support list, barcode scan, purchase, sales, reports. |

## 8.4 Inventory reports

| ID | Requirement |
| -- | ----------- |
| FR-INV-09 | Low stock, stock valuation, expiry reports (if item has expiry date — add optional expiry on item or batch in MVP if time allows; if no expiry field, hide expiry report), fast-moving items, current stock, purchase history, sales history. |

---

# 9. Module: Staff

| ID | Requirement |
| -- | ----------- |
| FR-STF-01 | Admin shall store employee profile, salary amount, staff attendance, and role. |
| FR-STF-02 | Full payroll run (payslips, PF, etc.) is out of scope. |
| FR-STF-03 | Staff reports: staff attendance, salary report, performance report (performance may be a simple count of assigned members / sessions — keep minimal in MVP). |

---

# 10. Dashboards and reports

## 10.1 Admin dashboard

Shall show widgets: Total Members, Active Members, Expired Members, Today’s Entry Count, Revenue Today, Pending Renewals, Low Stock Alerts, Profit This Month.

Shall show charts: monthly revenue, attendance trends, renewals.

## 10.2 Reception dashboard

Today’s visits, expiring memberships, pending payments, recent registrations.

## 10.3 Accountant dashboard

Cash balance, today’s collection, expenses, outstanding dues.

## 10.4 Membership reports

Active, Expired, Renewal due, Inactive, Gender analysis, Age group analysis.

## 10.5 Attendance reports

Daily, monthly, peak hours, member frequency, no-show analysis.

## 10.6 Revenue reports

Daily sales, monthly revenue, membership revenue, product sales, expense analysis, profit/loss.

Requirement IDs: **FR-RPT-01** (all reports listed in 10.4–10.6 available to roles in the permission matrix), **FR-DSH-01** (dashboards in 10.1–10.3).

---

# 11. Notifications (MVP)

| ID | Event | In-app | Email | WhatsApp / SMS / Push |
| -- | ----- | ------ | ----- | --------------------- |
| FR-NTF-01 | Membership expiry approaching / expired | Y | Y | No |
| FR-NTF-02 | Payment due | Y | Y | No |
| FR-NTF-03 | Low stock | Y | Y (optional) | No |
| FR-NTF-04 | Failed attendance / biometric sync | Y | Y | No |
| FR-NTF-05 | Backup failure | Y | Y (Admin) | No |

---

# 12. Audit, backup, import

| ID | Requirement |
| -- | ----------- |
| FR-AUD-01 | Log critical actions: user, module, action, old value, new value, datetime, IP (BR-12). |
| FR-AUD-02 | Examples: posted invoice cancel, member suspend, device delete, stock adjustment, login failure optional. |
| FR-BKP-01 | Automatic daily, weekly, and monthly backups. |
| FR-BKP-02 | Local backup and cloud backup (cloud when internet available). |
| FR-BKP-03 | Admin shall restore from a backup. |
| FR-MIG-01 | Import members, attendance, inventory, accounting from Excel/CSV (and “old software” via CSV mapping). |

---

# 13. Use cases (testable)

## UC-01 Register new member

- **Actors:** Reception, Admin  
- **Pre:** Logged in; at least one active plan  
- **Flow:** Open registration → enter details → upload photo/docs → select plan → record payment → save → generate member ID → optional biometric enrol  
- **Post:** Member Active; subscription and invoice exist  
- **Pass:** FR-MEM-01..06, FR-ACC-05..09  

## UC-02 Renew membership

- **Actors:** Reception, Admin  
- **Flow:** Search member → open membership → select renew plan → receive payment → invoice → update expiry  
- **Pass:** FR-SUB-06..08  

## UC-03 Member entry using biometric

- **Actors:** Member (at device); system  
- **Pre:** Member enrolled on device  
- **Flow:** Scan → identify → check status and rules → if ok: attendance + unlock; else reject + reason  
- **Exceptions:** Expired, Suspended, Frozen, visit limit, outside hours, unknown finger  
- **Pass:** FR-ATT-01..07, BR-01, BR-02, BR-05, BR-06  

## UC-04 Sell inventory item

- **Actors:** Reception, Inventory Manager, Admin  
- **Flow:** Search/scan product → qty → payment → invoice → stock down  
- **Fail:** qty > stock (FR-INV-05)  
- **Pass:** FR-INV-07  

## UC-05 Record expense

- **Actors:** Accountant, Admin  
- **Flow:** Choose category, amount, date, vendor, remarks → save → accounts updated  
- **Pass:** FR-ACC-04  

## UC-06 Add biometric device

- **Actors:** Admin  
- **Flow:** IP, port, name, SDK type → test connection → save  
- **Pass:** FR-BIO-01..03  

## UC-07 Freeze membership

- **Actors:** Admin, Reception (if plan allows freeze)  
- **Flow:** Choose days → confirm → status Frozen, expiry extended, door denied until unfreeze  
- **Pass:** FR-SUB-11..14  

## UC-08 Offline entry then sync

- **Actors:** Member, system  
- **Pre:** Internet down; LAN/device up  
- **Flow:** Valid member scans → door still works → records stored locally → when internet returns, sync  
- **Pass:** FR-COM-06  

---

# 14. Workflows (must match software)

## 14.1 New member enrollment

Register member → choose membership → receive payment → generate invoice → create subscription → enrol fingerprint (optional) → activate access.

## 14.2 Gym entry

Fingerprint scan → find member → check membership → check attendance rules → unlock door → save attendance.  
(If reject: stop before unlock; save failed attempt with reason.)

## 14.3 Membership expiry

Expiry near → send reminder (in-app + email) → member renews → update subscription.  
**Or** no renewal → membership expired → disable door access.

## 14.4 Inventory purchase

Supplier invoice → purchase entry → increase stock → update accounts.

---

# 15. Business rules (enforce in code)

| ID | Rule |
| -- | ---- |
| BR-01 | No entry if membership expired. |
| BR-02 | No entry if suspended. |
| BR-03 | Freeze days extend expiry by the same number of days. |
| BR-04 | One membership is not shared across members. |
| BR-05 | Count attendance once per configurable duplicate window (default 5 minutes). |
| BR-06 | Time-of-day access is configurable; outside window = deny. |
| BR-07 | Stock cannot go negative. |
| BR-08 | Alert when quantity < minimum. |
| BR-09 | Every posted money transaction hits two accounts (double-entry). |
| BR-10 | Posted invoices cannot be deleted; cancel or reverse only. |
| BR-11 | Passwords stored encrypted/hashed. |
| BR-12 | Critical operations are logged. |

---

# 16. APIs the product shall expose (behaviour)

These are functional contracts. Paths may change in the API spec; behaviour shall not.

| Area | Operations |
| ---- | ---------- |
| Auth | Login, logout, refresh token |
| Members | List, create, update, delete/deactivate |
| Membership | List subscriptions, renew (and upgrade/downgrade/extend) |
| Attendance | Create (device/middleware), list |
| Biometric | Connect/test device, unlock door, sync |
| Inventory | Stock movement, sale |
| Accounting | Invoice, payment, expense |

Unauthorized or wrong-role calls shall return an error and shall not change data.

---

# 17. Non-functional (only where they bind functions)

| ID | Requirement |
| -- | ----------- |
| NFR-01 | Support at least 5,000 members. |
| NFR-02 | Support at least 50 users at the same time. |
| NFR-03 | Attendance path &lt; 2 seconds; door unlock &lt; 1 second (targets). |
| NFR-04 | Aim 99% uptime for the gym’s operating hours. |
| NFR-05 | Gym operations listed in FR-COM-06 work without internet. |

UI style (Material 3), hardware sizes, and suggested tech stack are **design/ops**, not extra features. They do not add modules.

---

# 18. MVP acceptance (software is accepted when)

A tester can complete all of the following on a gym PC with a test device or device simulator:

| # | Criterion | Linked FRs |
| - | --------- | ---------- |
| 1 | Register member | FR-MEM-* |
| 2 | Create membership plan and subscribe | FR-PLAN-*, FR-SUB-01..05 |
| 3 | Renew membership | FR-SUB-06..08 |
| 4 | Capture attendance | FR-ATT-01..06 |
| 5 | Unlock door on valid member | FR-ATT-04, FR-BIO-08 |
| 6 | Record payments | FR-ACC-08..09 |
| 7 | Maintain inventory (item, purchase, sale, no negative stock) | FR-INV-* |
| 8 | Generate invoices | FR-ACC-05..07 |
| 9 | View reports | FR-RPT-01 |
| 10 | Role-based login | FR-SEC-01..05 |
| 11 | Backup and restore | FR-BKP-01..03 |

Deny-entry cases must also pass: expired, suspended, frozen, outside hours, over visit limit.

---

# 19. Traceability

| SRS section | FRD |
| ----------- | --- |
| §2 User roles | §3 |
| Module 1 Membership | §5 |
| Module 2 Attendance | §6 |
| Module 3 Accounting | §7 |
| Module 4 Inventory | §8 |
| Module 5 Staff | §9 |
| Module 6 Reports | §10 |
| Use cases UC-01..06 | §13 |
| Workflows | §14 |
| Business rules BR-01..12 | §15 |
| APIs | §16 |
| Offline, backup, NFR | §4, §12, §17 |
| Appendix B scope freeze | §2 |

---

# 20. Open points (do not block MVP start)

Record decisions here when product answers them:

1. Duplicate mobile: warn only vs hard block.  
2. Checkout / “members inside”: entry-only vs in/out.  
3. Item expiry date: in MVP or hide expiry report.  
4. Immediate cash sale vs receivable then payment (default: cash sale posts income at once).  
5. Device simulator for CI tests vs hardware-only.

Until decided, implement the **MVP default** stated in this FRD.

---

*End of FRD v1.0. Next usual documents: SQL schema, screen wireframes, OpenAPI spec.*
