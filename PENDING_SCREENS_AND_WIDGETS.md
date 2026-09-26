# Pending Screens and Widgets Audit Report

**Generated:** 2026-09-25  
**Codebase:** `gym` (`shabibmr/luxeknox`)  
**Scope:** Screens, sub-screens, and widgets yet to be implemented across Member, Trainer, and Admin roles.

---

## 1. Executive Summary

This audit cross-references:
- **Specifications:** [`docs/screens/consolidated-screens.md`](file:///Users/admin/code/gym/docs/screens/consolidated-screens.md), [`admin-app-screens.md`](file:///Users/admin/code/gym/docs/screens/admin-app-screens.md), [`member-app-screens.md`](file:///Users/admin/code/gym/docs/screens/member-app-screens.md), [`trainer-app-screens.md`](file:///Users/admin/code/gym/docs/screens/trainer-app-screens.md), and [`navigation-architecture.md`](file:///Users/admin/code/gym/docs/screens/navigation-architecture.md).
- **Task Registers:** [`docs/flutter/flutter-task-register.md`](file:///Users/admin/code/gym/docs/flutter/flutter-task-register.md), [`docs/flutter/07-payments.md`](file:///Users/admin/code/gym/docs/flutter/07-payments.md), [`docs/flutter/05-scheduling.md`](file:///Users/admin/code/gym/docs/flutter/05-scheduling.md), and [`app/TASKS.md`](file:///Users/admin/code/gym/app/TASKS.md).
- **Router Implementation:** [`app/lib/core/router/admin_routes.dart`](file:///Users/admin/code/gym/app/lib/core/router/admin_routes.dart), [`trainer_routes.dart`](file:///Users/admin/code/gym/app/lib/core/router/trainer_routes.dart), and [`member_routes.dart`](file:///Users/admin/code/gym/app/lib/core/router/member_routes.dart).

While the majority of core Member, Trainer, and Admin screens have been implemented, the remaining work centers around:
1. **POS & Payment checkout/receipt generation**
2. **Advanced Scheduling (class creation, rescheduling, recurring series, slot pickers)**
3. **Staff/Trainer onboarding and editing forms**
4. **Specialized domain reporting widgets & hardware configuration**

---

## 2. Completely Missing or Placeholder Screens

| Screen Name | Target Route / Location | Spec Reference | Current State in Codebase |
| :--- | :--- | :--- | :--- |
| **Record Payment / POS Terminal Screen** | `/admin/payments/record` | Consolidated Screen #22; Admin Spec §8 #139 | Stubbed: returns `PlaceholderScreen(title: ShellStrings.adminPayments)` in [`admin_routes.dart`](file:///Users/admin/code/gym/app/lib/core/router/admin_routes.dart#L172). Needs front-desk POS billing interface (member selector, invoice/package picker, cash/card/UPI tender). |
| **Payment Receipt View / Export Screen** | `/profile/payments/:id/receipt`, `/admin/payments/:id/receipt` | Consolidated Screen #24; Member Spec §6 #88; Admin Spec §8 #142 | Not implemented. Task register item `[ ] receipt` in [`07-payments.md`](file:///Users/admin/code/gym/docs/flutter/07-payments.md#L11). No printable or shareable receipt/invoice PDF screen or widget exists. |
| **Create / Edit Gym Schedule Screen (Admin)** | `/admin/schedules/create`, `/admin/schedules/:id/edit` | Admin Spec §9 #154, #155 | Not implemented. [`admin_routes.dart`](file:///Users/admin/code/gym/app/lib/core/router/admin_routes.dart#L241-L257) only mounts calendar, facilities, and schedule details. No admin form exists to create group classes, recurring sessions, or reassign trainers. |
| **Add Trainer Onboarding Screen** | `More > Trainers > Add Trainer` | Admin Spec §3 #65 | Not implemented. [`TrainersDirectoryScreen`](file:///Users/admin/code/gym/app/lib/features/people/presentation/screens/trainers_directory_screen.dart) is a search-and-view directory only; no trainer creation form exists. |
| **Edit Trainer Admin Screen** | `/admin/trainers/:id/edit` | Admin Spec §3 #67 | Not implemented. Admins can view trainer directory, but cannot edit trainer qualifications, employment terms, or commission structures. |
| **Add Employee Onboarding Screen** | `More > Employees > Add Employee` | Admin Spec §4 #81 | Not implemented. [`EmployeesDirectoryScreen`](file:///Users/admin/code/gym/app/lib/features/people/presentation/screens/employees_directory_screen.dart) is list-only; no employee registration form exists. |
| **Edit Employee Screen** | `/admin/employees/:id/edit` | Admin Spec §4 #83 | Not implemented. Only role assignment ([`EmployeeRolesScreen`](file:///Users/admin/code/gym/app/lib/features/people/presentation/screens/employee_roles_screen.dart)) exists; general staff profile editing is missing. |
| **Standalone Membership Renew / Freeze Screens** | `Routes.adminMembershipsRenew`, `Routes.adminMembershipsFreeze` | Consolidated Screen #10; Admin Spec §5 #99, #100 | Routes are defined in [`routes.dart`](file:///Users/admin/code/gym/app/lib/core/router/routes.dart#L158-L159) but not registered in [`admin_routes.dart`](file:///Users/admin/code/gym/app/lib/core/router/admin_routes.dart). They are currently handled only through inline bottom sheets/dialogs inside [`MembershipDetailScreen`](file:///Users/admin/code/gym/app/lib/features/membership/presentation/screens/membership_detail_screen.dart). |

---

## 3. Widgets & Sub-Flows Yet to Be Implemented

### A. Payments & Billing Module ([`07-payments.md`](file:///Users/admin/code/gym/docs/flutter/07-payments.md))
- **Split-Tender Payment Widget:** Multi-mode payment breakdown (e.g., partial cash + partial card/UPI).
- **Discount & Coupon Application Widget:** Input/selector for promotional codes or manual percentage discounts during checkout.
- **Refund / Adjustment Modal:** Admin refund action and ledger adjustment flow.

### B. Scheduling Module ([`05-scheduling.md`](file:///Users/admin/code/gym/docs/flutter/05-scheduling.md))
- **Reschedule Booking Flow:** Cancellation is implemented, but the reschedule UI is open (`- [x] cancel/reschedule (cancel done; reschedule UI open)`).
- **Recurring Series Configuration Widget:** Interface for creating recurring classes (weekly, daily repeat patterns with end dates).
- **Open Slots Selector:** Interactive available slot picker for members booking PT or trainer availability calendar.

### C. Dashboard Module ([`12-dashboard.md`](file:///Users/admin/code/gym/docs/flutter/12-dashboard.md))
- **Today's Schedule & Upcoming Agenda Widgets:** Member and Trainer daily session agenda widgets inside [`DashboardScreen`](file:///Users/admin/code/gym/app/lib/features/dashboard/presentation/screens/dashboard_screen.dart) (currently only high-level status counts are rendered; waiting on server dashboard contract expansion per register notes).

### D. Reports & Analytics Module ([`13-reports.md`](file:///Users/admin/code/gym/docs/flutter/13-reports.md))
The generic tabular viewer ([`ReportViewerScreen`](file:///Users/admin/code/gym/app/lib/features/reports/presentation/screens/report_viewer_screen.dart)) exists, but domain-specific visual charts and analytics widgets remain open:
- **Attendance Heatmap & Peak Hours Chart:** Facility occupancy and visit distribution graphs.
- **Financial & Revenue Breakdown Charts:** Payment mode distributions, tax summaries, and aging accounts receivable.
- **Trainer Performance Slice:** Dedicated trainer retention rate, session volume, and client rating metrics (`- [ ] trainer own slice`).
- **Member Acquisition & Churn Visualizations:** Graphical cohort and churn breakdown.

### E. Hardware & Settings Module ([`14-settings-rbac.md`](file:///Users/admin/code/gym/docs/flutter/14-settings-rbac.md))
- **Biometric & Access Gate Integration Widget:** While generic key/value editing exists in [`SettingsCategoryScreen`](file:///Users/admin/code/gym/app/lib/features/settings/presentation/screens/settings_category_screen.dart), specialized UI widgets for turnstile sync, RFID/biometric hardware, and automated checkout rules are not yet built.

---

## 4. Implementation Priority Recommendation

1. **Priority 1 (Blocking Functional Gaps):**
   - Implement `/admin/payments/record` (POS billing terminal) to replace `PlaceholderScreen`.
   - Implement Payment Receipt viewer & download widget.
2. **Priority 2 (Core Admin / Staff Workflows):**
   - Admin Schedule/Class creation & edit form (`/admin/schedules/create`).
   - Add Trainer & Add Employee onboarding forms.
   - Reschedule booking UI in scheduling detail.
3. **Priority 3 (Visual Polish & Advanced Features):**
   - Recurring class series rule picker.
   - Domain-specific visual charts (Attendance heatmaps, revenue breakdowns).
   - Specialized turnstile / biometric gate configuration controls.
