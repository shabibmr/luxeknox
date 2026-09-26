# Admin / Office App — MVP Screens Specification

The **Admin / Office App** is the central management interface for gym owners, facility managers, and front-desk reception staff. It provides full control over member registrations, package sales, staff & trainer records, attendance tracking, billing, class schedules, and facility configurations.

---

## Navigation Summary

* **Primary Bottom Navigation / Navigation Rail:**
  1. **Dashboard** (KPIs, operational alerts, financial and check-in summaries)
  2. **Members** (Directory, registration, full member 360° dossiers)
  3. **Memberships** (Active/expiring memberships, renewals, package master)
  4. **Payments** (POS billing, payment receipts, outstanding dues, daily collection)
  5. **More / Menu** (Trainers, Employees, Attendance, Schedules, Exercise & Food Libraries, Reports, Gym Settings)

---

## 1. Dashboard (`Dashboard` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Admin Dashboard** | Root Tab Screen | `Nav > Dashboard` | Executive command center with key metrics, real-time counters, and operational alerts. |
| **Member Summary** | Dashboard Card | Embedded in `Admin Dashboard` | Total members, active count, inactive count, new joins this month. |
| **Membership Summary** | Dashboard Card | Embedded in `Admin Dashboard` | Active contracts, pending renewals, expired accounts tally. |
| **Revenue / Payment Summary**| Dashboard Card | Embedded in `Admin Dashboard` | Today's revenue, monthly collections, pending receivables graph. |
| **Attendance Summary** | Dashboard Card | Embedded in `Admin Dashboard` | Live in-gym headcount, today's peak hour visits, trainer attendance count. |
| **Trainer Summary** | Dashboard Card | Embedded in `Admin Dashboard` | On-duty trainers, sessions delivered today, assigned member workload. |
| **Today's Schedule** | Dashboard Widget | Embedded in `Admin Dashboard` | Today's master timeline of all PT slots, classes, and room allocations. |
| **Expiring Memberships** | Alert List Widget | Embedded in `Admin Dashboard` | Memberships expiring in the next 7/14 days with quick renew CTA. |
| **Recent Payments** | Transaction Widget | Embedded in `Admin Dashboard` | Live stream of recent POS receipts and fee transactions. |
| **Notifications / Alerts** | System Drawer | `AppBar > Bell Icon` | System operational warnings (door alerts, pending approvals, low package stocks). |

---

## 2. Members (`Members` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Members** | Root Tab Screen | `Nav > Members` | Complete member registry table/list with search, status filters, and export. |
| **Add Member** | Wizard / Form | `Members > Add Member (FAB)` | New member onboarding: personal details, contact, photo capture, waiver signing. |
| **Member Profile** | 360° Detail Screen | `Members > [Select Member]` | Central hub linking to all records related to this member. |
| **Edit Member** | Form Screen | `Member Profile > Edit Details` | Update member personal, contact, and administrative data. |
| **Member Health** | Detail Screen | `Member Profile > Health` | Health declaration, allergies, physical limitations, blood group. |
| **Medical History** | Detail Screen | `Member Profile > Medical History` | Chronic conditions, injury reports, doctor clearance certificates. |
| **Emergency Contact** | Detail Screen | `Member Profile > Emergency` | Next of kin contact numbers, relationships, and instructions. |
| **Documents / Photos** | Gallery / Files | `Member Profile > Documents` | Government ID scans, agreements, membership contracts, photos. |
| **Member Membership** | Detail Screen | `Member Profile > Membership` | Current active package, assigned trainer, validity dates, locker assignment. |
| **Membership History** | History List | `Member Profile > Subscriptions` | Full log of past memberships, renewals, upgrades, freezes, and cancellations. |
| **Member Attendance** | Detail Screen | `Member Profile > Attendance` | Member's check-in timeline and attendance calendar. |
| **Attendance History** | History Table | `Member Attendance > View Log` | Chronological timestamped check-in/out records. |
| **Member Payments** | Detail Screen | `Member Profile > Billing` | Invoices, payment transactions, outstanding balance ledger. |
| **Payment History** | History Table | `Member Payments > Full History`| All receipts and transaction records for this member. |
| **Member Schedule** | Schedule View | `Member Profile > Schedule` | Booked PT sessions, upcoming classes, and slot bookings. |
| **Workout Plans** | Detail View | `Member Profile > Workouts` | Review assigned workout plans and routine compliance. |
| **Diet Plans** | Detail View | `Member Profile > Diets` | Review assigned nutrition plans and dietary guidelines. |
| **Goals & Progress** | Analytics View | `Member Profile > Progress` | Goal tracking, measurement graphs, and transformation photo records. |

---

## 3. Trainers (`More > Trainers`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Trainers** | Directory Screen | `More > Trainers` | Directory of all fitness trainers with status filter (`All`, `Active`, `Inactive`), search, 200px infinite scroll, and 840dp responsive master–detail split pane. |
| **Add Trainer** | Form Screen | `Trainers > Add Trainer (FAB)` | Onboard new trainer with 1-TX atomic user + profile creation (bio, specializations, hourly rate, client capacity). |
| **Edit Trainer Profile** | Form Screen / Detail Pane | `Trainers > [Select Trainer]` (`/admin/trainers/:id/edit`) | Edit profile with `UnsavedChangesScope` discard protection, active status deactivation confirmation dialog, and admin/self-edit role gating. |
| **Trainer Members** | Domain Module | `More > Members` (filtered by assigned trainer) | Roster of assigned member clients managed via Members vertical dossier. |
| **Trainer Schedule & Availability** | Domain Module | `More > Schedule / Calendar` | Master calendar of booked sessions and slot availability managed via Scheduling vertical. |
| **Trainer Attendance** | Domain Module | `More > Attendance` | Staff clock-in/out records and timesheets managed via Attendance vertical. |
| **Trainer Performance & Reports** | Domain Module | `More > Reports > Trainers` | Trainer session metrics, ratings, and retention reports managed via Reports vertical. |

---

## 4. Employees (`More > Employees`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Employees** | Directory Screen | `More > Employees` | Staff roster with search, employment-status chips, infinite scroll, AppBar `+` create (gated by `employees.create`), and ≥840dp master–detail (list + embedded edit). Separate from Trainers. |
| **Add Employee** | Form Screen | `Employees > +` (or create route) | Hire flow: name, contact, temporary password, job title, department, hire date, role. |
| **Edit Employee** | Form Screen | `Employees > [Select Employee]` (push on narrow; side pane when wide) | Update job/department/hire date; change employment status with confirm; link to Manage roles. No separate read-only profile. |
| **Employee Roles** | Full-screen Form | `Edit Employee > Manage roles` (`/admin/employees/:id/roles`, gated by `roles.update`) | Assign exactly one system role. |

---

## 5. Memberships (`Memberships` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Memberships** | Root Tab Screen | `Nav > Memberships` | Overview of all gym memberships with segment tabs. |
| **Active Memberships** | Filter Tab | `Memberships > Active Tab` | Currently valid memberships with expiration countdown. |
| **Expired Memberships** | Filter Tab | `Memberships > Expired Tab` | Lapsed accounts available for win-back campaigns and renewals. |
| **Expiring Memberships** | Filter Tab | `Memberships > Expiring Tab` | Priority list expiring within 7, 15, or 30 days. |
| **Membership Details** | Detail Screen | `Memberships > [Select Record]` | Full plan contract, holder name, validity dates, amount paid, included perks. |
| **Membership History** | History List | `Membership Details > History` | Subscription timeline, renewals, extensions, and invoice references. |
| **Freeze / Extension** | Action Modal / Screen | `Membership Details > Freeze/Extend` | Process membership freeze (medical/vacation) or manual validity extension. |
| **Renew Membership** | Action Screen | `Membership Details > Renew` | Quick renewal checkout: package selection, discount, and payment collection. |
| **Assign Membership** | Action Screen | `Memberships > Assign to Member` | Link an existing member with a purchased membership product. |

---

## 6. Membership Products (`More > Membership Packages`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Membership Packages** | Master List Screen | `More > Membership Packages` | Catalog of offered membership tiers (Monthly, Quarterly, Annual, VIP, Couples). |
| **Add Package** | Form Screen | `Packages > Add Package` | Form to create a new membership offering with pricing and perks. |
| **Edit Package** | Form Screen | `Package Details > Edit` | Modify package parameters, pricing tiers, and active status. |
| **Package Details** | Detail Screen | `Membership Packages > [Select]` | Comprehensive overview of rules, features, pricing, and active subscriber count. |
| **Package Pricing** | Config Sub-Screen | `Package Details > Pricing` | Base price, taxes (GST/VAT), registration fee, recurring discount rules. |
| **Package Duration** | Config Sub-Screen | `Package Details > Duration` | Validity length (e.g., 30 days, 90 days, 365 days), grace period days. |
| **Package Features** | Config Sub-Screen | `Package Details > Features` | Included access items (Cardio, Weights, Locker, Sauna, Complimentary PT sessions). |
| **Package Status** | Quick Action | `Package Details > Toggle Status`| Publish or archive package from sales options. |

---

## 7. Attendance (`More > Attendance`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Attendance Dashboard** | Analytics Screen | `More > Attendance` | Live attendance metrics, peak occupancy graphs, daily check-in counter. |
| **Today's Attendance** | Real-Time Feed | `Attendance > Today's Feed` | Real-time stream of biometric / RFID / QR turnstile check-ins and check-outs. |
| **Attendance Records** | Master Table | `Attendance > All Records` | Searchable historical table of check-ins with filters (Date, User Type, Gate). |
| **Member Attendance** | Filtered Table | `Attendance > Member Log` | Check-in records exclusively for gym members. |
| **Trainer Attendance** | Filtered Table | `Attendance > Trainer Log` | Clock-in records for training staff. |
| **Attendance History** | Archive Table | `Attendance > History Archive` | Searchable long-term attendance archives by month and year. |
| **Attendance Reports** | Report Generator | `Attendance > Reports` | Generate average attendance, peak hours, member visit frequency distributions. |

---

## 8. Payments (`Payments` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Payments** | Root Tab Screen | `Nav > Payments` | Financial ledger: daily collection total, recent receipts, outstanding dues overview. |
| **Record Payment** | POS Form Screen | `Payments > Record Payment (FAB)` | Front-desk billing terminal: select member, select invoice/package, payment method (Cash, Card, UPI, Bank Transfer), collect. |
| **Payment Details** | Detail Screen | `Payments > [Select Transaction]`| Full transaction voucher: invoice #, line items, taxes, payer details, cashier stamp. |
| **Payment History** | Ledger Table | `Payments > All Transactions` | Searchable register of all collected payments, refunds, and adjustments. |
| **Payment Receipts** | Document View | `Payment Details > Receipt` | Standard formatted printable/shareable payment receipt. |
| **Pending / Outstanding** | Action List | `Payments > Outstanding Dues` | List of members with unpaid invoices, partial payments, and overdue amounts. |
| **Payment Reports** | Report Generator | `Payments > Financial Reports` | Daily closing reports, monthly revenue breakdowns, payment mode distribution. |

---

## 9. Schedules (`More > Schedules`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Schedule Calendar** | Calendar View | `More > Schedules` | Unified multi-trainer, multi-studio interactive calendar. |
| **All Schedules** | Master Table | `Schedules > List View` | Chronological list of all gym activities, classes, and appointments. |
| **Create Schedule** | Form Screen | `Schedules > New Schedule` | Setup class/session: title, trainer, date/time, max capacity, room. |
| **Edit Schedule** | Form Screen | `Schedule Details > Edit` | Update session timings, assign substitute trainer, update room capacity. |
| **Schedule Details** | Detail Screen | `Schedule > [Select Slot]` | Session info, enrolled participants list, attendance checkoff, waitlist. |
| **Trainer Availability** | Matrix View | `Schedules > Availability Matrix`| Grid view showing all trainer shifts, booked slots, and open slots simultaneously. |
| **Schedule History** | History List | `Schedules > History Archive` | Historical audit of past completed and cancelled sessions. |

---

## 10. Workout Management (`More > Workout Library`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Exercise Library** | Master Catalog | `More > Exercise Library` | Repository of all exercises categorized by muscle group and equipment. |
| **Add Exercise** | Form Screen | `Exercise Library > Add Exercise` | Name, target muscles, equipment required, instructions, video demo URL. |
| **Edit Exercise** | Form Screen | `Exercise Details > Edit` | Modify exercise parameters, instructions, and categorization. |
| **Exercise Details** | Detail Screen | `Exercise Library > [Select]` | Exercise profile with GIF/video demonstration and biomechanics info. |
| **Workout Plans** | Plan Catalog | `More > Workout Plans Master` | Gym standard workout templates (Beginner, Fat Loss, Hypertrophy, Strength). |
| **Workout Plan Details** | Detail Screen | `Workout Plans > [Select Plan]` | Split breakdown, exercise sequence, target sets and reps. |
| **Workout Plan History** | Version Log | `Workout Plan Details > Versions`| Modification history and member assignment stats. |

---

## 11. Diet Management (`More > Food & Diet Library`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Food Library** | Master Catalog | `More > Food Library` | Database of raw and prepared food items with nutrition info per 100g. |
| **Add Food** | Form Screen | `Food Library > Add Food` | Item name, serving size, calories, protein, carbs, fats, fiber. |
| **Edit Food** | Form Screen | `Food Details > Edit` | Update nutrition facts and serving units. |
| **Food Details** | Detail Screen | `Food Library > [Select Food]` | Full nutritional breakdown and macro percentage breakdown. |
| **Diet Plans** | Plan Catalog | `More > Diet Plans Master` | Standard gym nutrition templates (Keto, High Protein, Maintenance, Calorie Deficit). |
| **Diet Plan Details** | Detail Screen | `Diet Plans > [Select Plan]` | Structured meal schedules and macro allocations. |
| **Diet Plan History** | Version Log | `Diet Plan Details > Versions` | Template revision history and assignment stats. |

---

## 12. Goals & Measurements (`More > Goals & Metrics`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Goal Metrics** | Master List | `More > Goal Metrics` | Configurable tracked metrics (Body Weight, Body Fat %, Chest, Waist, Squat 1RM). |
| **Add / Edit Metric** | Form Screen | `Goal Metrics > Add/Edit` | Metric name, unit of measure (kg, lbs, cm, in, %), category. |
| **Member Goals** | Directory View | `More > Member Goals Monitor` | Overview of all active fitness goals across the member base. |
| **Progress Tracking** | Analytics Screen | `More > Member Progress Aggregate`| Gym-wide aggregate transformation and progress statistics. |
| **Measurements** | Audit Table | `More > Measurements Audit` | Log of all measurements entered across the gym. |
| **Measurement History** | History Screen | `Measurements > History Archive` | Long-term log of body composition records. |
| **Progress Photos** | Moderation Gallery | `More > Progress Photos Vault` | Secure administrative gallery of transformation photos with strict privacy access controls. |

---

## 13. Notifications (`More > Notifications`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Notifications** | List Screen | `AppBar > Bell Icon` or `More > Notifications` | Administrative inbox for alerts, member requests, and audit logs. |
| **Notification Details** | Detail Screen | `Notifications > [Select Item]` | Full message, affected entity link, and resolution action. |
| **Send Notification** | Broadcast Form | `Notifications > Compose (FAB)` | Send announcement or push notification to: All Members, Specific Member, All Trainers, Expiring Members. |
| **Notification History** | Log Table | `Notifications > Broadcast History` | Log of sent broadcast messages, delivery counts, and timestamps. |

---

## 14. Reports (`More > Reports`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Member Reports** | Report Screen | `More > Reports > Members` | Member acquisition, churn rate, demographic breakdown, active vs inactive trends. |
| **Membership Reports** | Report Screen | `More > Reports > Memberships` | Package popularity, average package duration, renewal conversion rate. |
| **Attendance Reports** | Report Screen | `More > Reports > Attendance` | Daily/weekly footfall, peak hours heatmap, average duration per visit. |
| **Payment Reports** | Report Screen | `More > Reports > Revenue` | Total revenue, cash vs digital collection, tax reports (GST/VAT), overdue aging analysis. |
| **Trainer Reports** | Report Screen | `More > Reports > Trainers` | Trainer session count, member rating averages, client retention rate. |
| **Workout Reports** | Report Screen | `More > Reports > Workouts` | Most assigned routines, exercise popularity, workout completion rates. |
| **Diet Reports** | Report Screen | `More > Reports > Diets` | Nutrition plan distribution, dietary compliance logs. |
| **Progress Reports** | Report Screen | `More > Reports > Progress` | Gym-wide fitness achievement rates (total weight lost, goals met). |

---

## 15. Gym Settings (`More > Gym Settings`)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Gym Profile** | Config Screen | `Settings > Gym Profile` | Gym legal name, logo, address, contact numbers, tax identification number. |
| **General Settings** | Config Screen | `Settings > General` | Operating hours, working days, currency symbol, date/time format, timezone. |
| **Membership Settings** | Config Screen | `Settings > Membership Rules` | Grace period days, default freeze duration limits, renewal reminder thresholds. |
| **Attendance Settings** | Config Screen | `Settings > Attendance Rules` | Access gate integration, biometric sync, max check-ins allowed per day, auto-checkout timer. |
| **Schedule Settings** | Config Screen | `Settings > Schedule Rules` | Booking lead time, cancellation cutoff window, max booking slots per member. |
| **Notification Settings** | Config Screen | `Settings > Notifications` | Configure automated SMS, email, and push notification triggers for dues, renewals, and birthdays. |
| **Workout Settings** | Config Screen | `Settings > Workout Config` | Default rest timers, measurement unit defaults (kg vs lbs). |
| **Diet Settings** | Config Screen | `Settings > Diet Config` | Default macro calculation formula, food database sync options. |
| **Measurement Settings** | Config Screen | `Settings > Measurement Config` | Mandatory measurement fields, milestone frequency reminder (e.g., every 30 days). |
