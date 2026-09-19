# Entities List

Canonical physical names: [`database-entities.md`](./database-entities.md) (56 tables).

## 1. Master Entities
- User
- Session
- Role
- Permission
- Role Permission
- Employee
- Member
- Trainer
- Membership Product
- Exercise
- Food
- Goal Metric *(also “Measurement Type”)*
- Schedule Type
- Facility
- Notification Type
- Gym Setting

## 2. Member & Health
- Member Health
- Health Condition
- Medical History
- Emergency Contact
- Member Document
- Member Photo

## 3. Membership
- Membership
- Membership History
- Membership Freeze
- Membership Extension

## 4. Attendance
- Attendance *(per check-in/out)*
- Attendance History *(daily aggregate, not a scan log)*

## 5. Payments
- Payment *(invoice)*
- Payment History *(tenders, refunds, adjustments)*
- Payment Method
- Payment Receipt

## 6. Schedule
- Schedule
- Schedule Participant
- Schedule History
- Trainer Availability

## 7. Workout
- Workout Plan
- Workout Plan Version
- Workout Plan Exercise *(on version, not plan root)*
- Workout Session *(this is workout history)*
- Workout Session Exercise

## 8. Diet
- Diet Plan
- Diet Plan Version
- Diet Plan Meal *(on version, not plan root)*
- Diet Plan Food
- Diet History

## 9. Goals & Progress
- Goal
- Goal History *(also “Goal Version / History”)*
- Measurement
- Measurement Values *(also “Measurement History”)*
- Progress Photo
- Progress Note

## 10. Notifications
- Notification
- User Device
- Notification Delivery

## 11. System / Audit
- Audit Log
