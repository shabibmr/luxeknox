# Member App — MVP Screens Specification

The **Member App** is designed for gym members to manage their memberships, track schedules and attendance, monitor health, workout, and nutrition plans, and track their fitness progress.

---

## Navigation Summary

* **Primary Bottom Navigation Bar:**
  1. **Home** (Dashboard)
  2. **Membership** (Current Membership & Plans)
  3. **Schedule** (Bookings, PT & Class Sessions)
  4. **Progress** (Goals, Measurements & Photos)
  5. **Profile** (Account, Health & Documents)

All additional screens are reached via nested flows, tabs, or contextual actions.

---

## 1. Dashboard (`Home` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Dashboard** | Root Tab Screen | `BottomNav > Home` | Central landing page displaying quick widgets, active status, daily agenda, and fast shortcuts. |
| **Quick Membership Status** | Dashboard Widget | Embedded in `Dashboard` | Card showing active plan name, days remaining, expiration badge, and renewal/extension CTA. |
| **Today's Schedule** | Dashboard Widget / Screen | Embedded in `Dashboard` (tap opens full list) | Carousel or list of sessions scheduled for today (PT, class, gym entry). |
| **Attendance Summary** | Dashboard Widget | Embedded in `Dashboard` | Monthly visit streak, check-in count, and last check-in timestamp. |
| **Current Workout** | Dashboard Widget | Embedded in `Dashboard` | Today's assigned workout routine with quick "Start Session" button. |
| **Current Diet** | Dashboard Widget | Embedded in `Dashboard` | Next upcoming meal, daily calorie/macro tracker widget. |
| **Goals / Progress Summary** | Dashboard Widget | Embedded in `Dashboard` | Visual progress bar towards active primary goal (e.g., target weight, BF%). |
| **Notifications** | Icon / Sheet | `AppBar > Bell Icon` | Quick notification tray showing alerts, session reminders, payment dues. |

---

## 2. Profile & Health (`Profile` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Member Profile** | Root Tab Screen | `BottomNav > Profile` | Overview of personal profile, contact info, emergency contacts, QR/Member ID card, app settings. |
| **Edit Profile** | Form Screen | `Profile > Edit (Button)` | Form to update name, email, phone, address, profile photo. |
| **Health Information** | Detail Screen | `Profile > Health Information` | General vitals, blood group, allergies, dietary preferences, physician contacts. |
| **Medical History** | Detail Screen | `Profile > Medical History` | Historical injuries, chronic conditions, surgeries, and physical clearance docs. |
| **Emergency Contact** | Form / List | `Profile > Emergency Contacts` | Primary and secondary emergency contact details (Name, Relation, Phone). |
| **Documents / Photos** | Gallery / List | `Profile > Documents & Photos` | Uploaded IDs, gym waiver agreements, medical certificates, and ID photos. |

---

## 3. Membership (`Membership` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Current Membership** | Root Tab Screen | `BottomNav > Membership` | Active plan status, start/end dates, remaining days, access permissions (pool, spa, PT). |
| **Membership Details** | Detail Screen | `Membership > View Details` | Full breakdown of terms, included amenities, branch access rules, locker allocation. |
| **Membership History** | History List | `Membership > History` | Chronological list of past subscriptions, renewals, upgrades, and cancellations. |
| **Membership Package Details**| Detail Screen | `Membership > Explore Packages` | Available upgrade or renewal packages, pricing, duration, and feature comparison. |
| **Freeze / Extension History**| History List | `Membership > Freeze / Extensions` | History of requested membership freezes, medical holds, extension approvals, and remaining freeze quota. |

---

## 4. Schedule (`Schedule` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **My Schedule** | Root Tab Screen | `BottomNav > Schedule` | Calendar/day view showing all booked workouts, personal training slots, and studio classes. |
| **Schedule Details** | Detail Screen | `Schedule > [Select Slot]` | Date, time, location/room, instructor/trainer info, cancellation policy, cancel/reschedule actions. |
| **PT Sessions** | Tab / Filter Screen | `Schedule > PT Filter` | Dedicated view for 1-on-1 personal training bookings, remaining package sessions. |
| **Class / Gym Sessions** | Tab / Filter Screen | `Schedule > Classes Filter` | Group class calendar (Yoga, HIIT, Spinning) with "Book Spot" action. |
| **Schedule History** | History List | `Schedule > History` | Past completed and cancelled sessions with attendance status. |

---

## 5. Attendance

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Attendance** | Sub-Screen | `Home / Profile > Attendance` | Digital pass / QR code for check-in, recent check-in status. |
| **Attendance History** | List Screen | `Attendance > History` | Detailed log of all check-in and check-out dates and times. |
| **Monthly / Overall Summary**| Analytics Screen | `Attendance > Summary` | Visual calendar heat map, monthly total visits, average weekly frequency. |

---

## 6. Payments

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Payments & History** | List Screen | `Profile > Payments` | Invoices, payment records, outstanding dues, payment method management. |
| **Payment Details** | Detail Screen | `Payments > [Select Transaction]`| Breakdown of invoice line items, tax, discount, payment method, transaction ID. |
| **Payment Receipt** | View / Export Screen | `Payment Details > Download/View Receipt` | Printable/shareable digital receipt / PDF invoice. |

---

## 7. Personal Trainer

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **My Trainer** | Screen | `Home > My Trainer` or `Profile > My Trainer` | Assigned trainer summary card, contact options (chat/call), current assignment status. |
| **Trainer Profile** | Profile Screen | `My Trainer > View Profile` | Trainer bio, certifications, specializations, ratings, working hours. |

---

## 8. Workout

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Current Workout Plan** | Overview Screen | `Home > Current Workout` | Active workout routine assigned by trainer (e.g., 4-Day Push/Pull/Legs). |
| **Workout Plan Details** | Detail Screen | `Current Workout Plan > Details` | Routine split by days, targeted muscle groups, total sets and estimated duration. |
| **Exercise Details** | Modal / Screen | `Workout Plan > [Select Exercise]` | Step-by-step instructions, demo video/animation, target sets, reps, weight, rest timer. |
| **Workout Session** | Active Mode Screen | `Workout Plan > Start Workout` | Interactive in-workout logging interface: log completed sets, reps, load, rest stopwatch. |
| **Workout History** | History List | `Workout > History` | Completed workout sessions log with dates, duration, volume lifted. |
| **Previous Workout Plans** | History Screen | `Workout > Previous Plans` | Archive of past completed workout plans. |

---

## 9. Diet

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Current Diet Plan** | Overview Screen | `Home > Current Diet` | Active meal plan assigned by nutritionist/trainer with target daily calories & macros. |
| **Diet Plan Details** | Detail Screen | `Current Diet Plan > Details` | Structured meals schedule (Breakfast, Lunch, Pre-workout, Dinner, Snacks). |
| **Meal Details** | Detail Screen | `Diet Plan Details > [Select Meal]` | List of foods per meal, portion sizes, calories, protein, carbs, fats, notes. |
| **Diet History** | History List | `Diet > History / Logs` | Log of adherence and food intake history. |
| **Previous Diet Plans** | History Screen | `Diet > Previous Plans` | Archive of past dietary regimes. |

---

## 10. Goals & Progress (`Progress` Tab)

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **My Goals** | Root Tab Screen | `BottomNav > Progress` | Active fitness goals (Weight Loss, Muscle Gain, Endurance) with targets and target dates. |
| **Goal Details** | Detail Screen | `My Goals > [Select Goal]` | Current milestone vs target metrics, timeline, coach feedback notes. |
| **Progress Overview** | Analytics Screen | `Progress > Overview` | Visual trend charts for weight, body composition, attendance correlation. |
| **Measurements** | Summary Screen | `Progress > Measurements` | Latest body measurements (Chest, Waist, Biceps, Thighs, Body Fat %, Weight). |
| **Measurement History** | Table / Chart | `Measurements > History` | Historical log and progress curves across all measurement dates. |
| **Progress Photos** | Gallery Screen | `Progress > Photos` | Side-by-side front/side/back transformation photo comparison. |
| **Progress Notes** | List Screen | `Progress > Notes` | Member personal notes and trainer assessment logs. |

---

## 11. Notifications

| Screen Name | Type | Access / Navigation Path | Purpose & UI Components |
| :--- | :--- | :--- | :--- |
| **Notifications** | List Screen | `AppBar > Notification Bell` | Feed of system alerts, upcoming booking reminders, fee alerts, announcements. |
| **Notification Details** | Detail Screen | `Notifications > [Select Item]` | Full announcement message, action links (e.g., "Pay Now", "Confirm Booking"). |
