# Trainer App — MVP Screens Specification

The **Trainer App** equips personal trainers and gym fitness coaches with tools to manage assigned members, organize training sessions, monitor client attendance, build custom workout and diet plans, and evaluate progress metrics.

---

## Navigation Summary

* **Primary Bottom Navigation Bar:**
  1. **Home** (Trainer Dashboard & Today's Agenda)
  2. **Members** (Assigned Clients Directory & Profiles)
  3. **Schedule** (Session Calendar & Availability Management)
  4. **Plans** (Workout & Diet Plan Builder & Manager)
  5. **Profile** (Trainer Bio, Certifications & Account Settings)

Additional workflows are exposed as nested screens, action bottom sheets, and detail drawers.

---

## 1. Dashboard (`Home` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Trainer Dashboard** | Root Tab Screen | `BottomNav > Home` | Real-time overview of daily obligations, assigned client roster, upcoming sessions, and quick actions. |
| **Today's Schedule** | Dashboard Widget / Screen | Embedded in `Trainer Dashboard` | Chronological timeline of today's booked sessions and slot times. |
| **Today's Sessions** | Session List Screen | `Dashboard > Today's Sessions` | Drill-down view of today's 1-on-1 and group classes with quick check-in / start buttons. |
| **Assigned Members** | Dashboard Widget / List | Embedded in `Trainer Dashboard` | Total client count, newly assigned members, active vs inactive client badge. |
| **Pending Tasks** | Action List | Embedded in `Trainer Dashboard` | Action items: plans due for renewal, pending measurement reviews, unlogged sessions. |
| **Member Progress Summary**| Summary Widget | Embedded in `Trainer Dashboard` | Snapshot of client milestones reached this week (weight goals, PRs). |
| **Notifications** | Icon / Sheet | `AppBar > Bell Icon` | Real-time alerts for session bookings, member cancellations, system messages. |

---

## 2. Profile (`Profile` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Trainer Profile** | Root Tab Screen | `BottomNav > Profile` | Trainer bio, primary disciplines, certifications, assigned branch, review rating, working hours. |
| **Edit Profile** | Form Screen | `Profile > Edit Profile` | Form to edit phone number, emergency contacts, profile photo, biography, and credentials. |

---

## 3. Members (`Members` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **My Members** | Root Tab Screen | `BottomNav > Members` | List of all assigned clients with search, status badges (Active/Expiring/Inactive), and avatar. |
| **Member Search / Filter** | Search Modal / Sheet | `Members > Search / Filter Bar` | Filter by goal, plan status, membership expiration, attendance frequency. |
| **Member Profile** | Detail Screen | `Members > [Select Member]` | Member summary: contact info, joined date, assigned goals, active plan cards. |
| **Member Health** | Detail Screen | `Member Profile > Health Info` | Client medical alerts, injuries, contraindications, vitals, physician clearance. |
| **Member Membership** | Detail Screen | `Member Profile > Membership` | Client's membership plan, validity, PT session balance, package perks. |
| **Member Attendance** | Detail Screen | `Member Profile > Attendance` | Client's gym check-in log, missed sessions, frequency heat map. |
| **Member Schedule** | Detail Screen | `Member Profile > Schedule` | Upcoming and past training sessions booked with this client. |
| **Member Payment Summary** | Detail Screen | `Member Profile > Payments` | Overview of client's package payment status, pending dues (read-only for trainer). |

---

## 4. Schedule (`Schedule` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **My Schedule** | Root Tab Screen | `BottomNav > Schedule` | Trainer's personal booking schedule (Day / Week view). |
| **Schedule Calendar** | Interactive Calendar | `Schedule > Calendar View` | Full calendar grid showing booked PT sessions, group classes, and free slots. |
| **Schedule Details** | Detail Screen | `Schedule > [Select Booking]` | Client name, session type, scheduled duration, location/station, notes, mark complete button. |
| **Trainer Availability** | Management Screen | `Schedule > Set Availability` | Configure recurring working hours, shift timings, off-days, and block-out slots. |
| **Schedule History** | History List | `Schedule > History` | Historical archive of completed, rescheduled, and cancelled training appointments. |

---

## 5. Attendance

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Session Attendance** | Quick Action / Modal | `Today's Schedule > Mark Attendance` | Confirm client presence, no-show, or late arrival for a specific booked session. |
| **Member Attendance** | Detail View | `Member Profile > Attendance Log` | Full historical check-in audit for individual assigned members. |
| **Attendance History** | List Screen | `Schedule > Attendance Log` | Historical register of all sessions conducted by the trainer. |

---

## 6. Workout Plans (`Plans` Tab — Workouts)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Member Workout Plans** | List Screen | `BottomNav > Plans > Workouts` | Catalog of active and draft workout plans assigned to clients. |
| **Create Workout Plan** | Form / Builder | `Plans > New Workout Plan` | Multi-step builder: Plan title, target goal, duration (weeks), split days. |
| **Edit Workout Plan** | Editor Screen | `Workout Plan Details > Edit` | Modify routine split, add/remove exercises, update rep/set targets. |
| **Workout Plan Details** | Detail Screen | `Workout Plans > [Select Plan]` | Day-by-day split breakdown (e.g., Day 1: Chest & Triceps) with exercise cards. |
| **Add Exercises** | Picker / Search | `Plan Builder > Add Exercise` | Search exercise library by muscle group, equipment, difficulty, and add to plan. |
| **Exercise Details** | Detail Screen | `Add Exercises > [Select Exercise]` | Exercise instructions, targeted primary/secondary muscles, demo media. |
| **Workout Plan History** | History Screen | `Member Profile > Workout History` | Previous workout routines completed by a member with version logs. |
| **Workout Session** | Live Session Mode | `Schedule Details > Start Session` | Guided session tracker: live log of weights lifted, sets completed, and client feedback. |
| **Workout History** | History List | `Plans > Completed Sessions Log` | Archive of all executed client workout logs. |

---

## 7. Diet Plans (`Plans` Tab — Nutrition)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Member Diet Plans** | List Screen | `BottomNav > Plans > Diets` | Overview of nutrition plans created for assigned members. |
| **Create Diet Plan** | Form / Builder | `Plans > New Diet Plan` | Setup daily calorie targets, macronutrient split (Protein, Carbs, Fats), guidelines. |
| **Edit Diet Plan** | Editor Screen | `Diet Plan Details > Edit` | Adjust meal timings, macros, food items, and special dietary notes. |
| **Diet Plan Details** | Detail Screen | `Diet Plans > [Select Plan]` | Full meal breakdown: Breakfast, Mid-Morning, Lunch, Evening Snack, Dinner. |
| **Add Meals** | Builder Sub-Screen | `Create/Edit Diet > Add Meal` | Add custom meal slot with scheduled consumption time and macro limits. |
| **Add Foods** | Picker / Search | `Meal Editor > Add Food` | Search food database for nutritional info (calories, macros per 100g/serving). |
| **Food Details** | Detail Screen | `Add Foods > [Select Food]` | Macro & micronutrient breakdown, serving unit options. |
| **Diet Plan History** | History Screen | `Member Profile > Diet Plan History` | Historical record of past nutrition programs assigned to client. |
| **Diet History** | History List | `Diet Plans > Compliance Logs` | Client's logged food consumption and adherence feedback. |

---

## 8. Goals & Progress

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Member Goals** | List Screen | `Member Profile > Goals` | Active targets set for client (Weight Target, Body Fat %, Strength milestones). |
| **Create / Edit Goal** | Form Screen | `Member Goals > Add/Edit Goal` | Set metric, baseline value, target value, target deadline, and priority. |
| **Goal Details** | Detail Screen | `Member Goals > [Select Goal]` | Current progress bar, milestone check-ins, projected vs actual rate of progress. |
| **Progress Tracking** | Dashboard View | `Member Profile > Progress` | Comprehensive visual charts for weight, circumference, and BMI evolution. |
| **Measurements** | Summary Screen | `Progress Tracking > Measurements` | Table of latest anthropometric metrics (Chest, Arms, Waist, Hips, Thighs). |
| **Add Measurement** | Form Screen | `Measurements > Record New` | Input new circumference, skinfold, weight, or body fat % readings with date stamp. |
| **Measurement History** | History Table | `Measurements > Full History` | Tabular and graphical logs of all historical measurement recordings. |
| **Progress Photos** | Comparison Screen | `Progress Tracking > Photos` | Front/Side/Back client progress images with date tagging and privacy safeguards. |
| **Progress Notes** | List / Form | `Progress Tracking > Notes` | Trainer clinical notes, coach remarks, form correction feedback. |
| **Progress History** | Timeline Screen | `Progress Tracking > Timeline` | Complete historical audit of client evolution since joining. |

---

## 9. Notifications

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Notifications** | List Screen | `AppBar > Notification Bell` | Incoming alerts: new client assigned, member bookings, schedule cancellations. |
| **Notification Details** | Detail Screen | `Notifications > [Select Item]` | Notification detail message with action trigger (e.g., "Confirm Slot"). |
