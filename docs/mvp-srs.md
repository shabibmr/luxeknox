\# Software Requirements Specification (SRS)



\## Project: Gym Management Software (Basic Version)



\*\*Version:\*\* 1.0

\*\*Prepared For:\*\* Initial Product Development

\*\*Prepared By:\*\* Algoray

\*\*Document Date:\*\* 16 May 2026



\---



\# 1. Introduction



\## 1.1 Purpose



The Gym Management Software will help gyms manage:



\* Members

\* Membership plans

\* Attendance through biometric devices

\* Billing and accounting

\* Inventory and product sales

\* Staff operations



The system shall support single-gym and multi-branch operation in future.



\---



\## 1.2 Scope



The application shall provide:



\### Core Modules



1\. Membership Management

2\. Attendance \& Biometric Integration

3\. Accounting

4\. Inventory Management

5\. Reports

6\. User \& Staff Management



Optional future:



\* Mobile App

\* Trainer Management

\* Workout Plans

\* Diet Plans

\* WhatsApp Notifications

\* Online Payments



\---



\# 2. User Roles



| Role              | Permissions                         |

| ----------------- | ----------------------------------- |

| Admin             | Full access                         |

| Reception Staff   | Member registration, payments       |

| Trainer           | View assigned members               |

| Accountant        | Accounts \& reports                  |

| Inventory Manager | Inventory operations                |

| Member            | View membership status (future app) |



\---



\# 3. Functional Requirements



\---



\# Module 1: Membership Management



\## 3.1 Member Registration



System shall allow creation of member profiles.



Fields:



\* Member ID (Auto generated)

\* Full Name

\* Photo

\* Mobile Number

\* Email

\* Address

\* Gender

\* DOB

\* Emergency Contact

\* Blood Group

\* Joining Date

\* Height

\* Weight

\* Medical Conditions

\* Trainer Assigned



Documents:



\* ID Proof

\* Consent Form



\---



\## 3.2 Membership Plans



System shall support:



Examples:



\* Monthly

\* Quarterly

\* Half Yearly

\* Annual

\* Personal Training

\* Premium Membership



Fields:



\* Plan Name

\* Duration

\* Price

\* Tax

\* Freeze Allowed

\* Max Visits



\---



\## 3.3 Membership Subscription



Member can subscribe to plans.



Track:



\* Start Date

\* Expiry Date

\* Remaining Days

\* Status



Statuses:



\* Active

\* Expired

\* Suspended

\* Frozen



\---



\## 3.4 Membership Renewal



Allow:



\* Renew

\* Upgrade

\* Downgrade

\* Extend



System generates invoice.



\---



\## 3.5 Alerts



Automatic notifications:



\* Expiry in 7 days

\* Expired membership

\* Payment pending



Channels:



\* SMS (future)

\* WhatsApp (future)

\* Email



\---



\# Module 2: Attendance \& Biometric Integration



\---



\## 4.1 Biometric Device Integration



Support:



Examples:



ZKTeco devices



Functions:



\### Import attendance



Capture:



\* Member ID

\* Date

\* Time

\* Device ID



\---



\### Real-time Attendance



When finger recognized:



System shall:



1\. Identify member

2\. Verify active membership

3\. Record attendance

4\. Open gym access



\---



\## 4.2 Door Lock Integration



System shall support:



IF Membership Active:



Unlock door



ELSE:



Reject access



Show:



"Membership Expired"



\---



\## 4.3 Access Rules



Examples:



Allow:



\* One entry/day

\* Unlimited access

\* Time restrictions



Example:



Only 5AM–10PM



\---



\## 4.4 Attendance Dashboard



Display:



\* Today's visits

\* Active members inside

\* Peak hours

\* Frequent visitors



\---



\# Module 3: Accounting



Need lightweight ERP accounting.



\---



\## 5.1 Ledger Management



Maintain:



\* Customers (Members)

\* Vendors

\* Expenses

\* Income



\---



\## 5.2 Accounts



Default:



Assets



Liabilities



Income



Expenses



Equity



\---



\## 5.3 Transactions



Support:



Receipts



Payments



Journal Entries



Contra



Expenses



\---



\## 5.4 Member Billing



Generate invoices for:



Membership



PT sessions



Supplements



Products



Locker rental



\---



\## 5.5 Payment Methods



Support:



Cash



Card



UPI



Bank Transfer



Wallet



\---



\## 5.6 Reports



Reports:



Daily collection



Profit/Loss



Outstanding payments



Cashbook



Ledger report



GST report (India)



\---



\# Module 4: Inventory Management



Inventory for:



\* Supplements

\* Protein powders

\* Water bottles

\* Merchandise

\* Equipment

\* Snacks



\---



\## 6.1 Item Master



Fields:



Item Code



Barcode



Name



Category



Purchase Price



Selling Price



Tax



Stock



Min Stock



Supplier



\---



\## 6.2 Purchase Entry



Track:



Supplier



Quantity



Rate



Invoice



\---



\## 6.3 Stock Movement



Track:



Purchase



Sale



Damage



Adjustment



Consumption



\---



\## 6.4 Sales



Allow POS sale:



Examples:



Protein powder



Shaker



Energy drink



\---



Generate invoice.



\---



\## 6.5 Inventory Reports



Low stock



Stock valuation



Expiry reports



Fast moving items



\---



\# Module 5: Staff Management



Store:



Employee profile



Salary



Attendance



Role



\---



Future:



Payroll



\---



\# Module 6: Reports Dashboard



Admin dashboard:



Show:



Total Members



Active Members



Expired Members



Today's Collection



Today's Attendance



Inventory Alerts



Revenue



\---



\# 4. Non Functional Requirements



\---



\## Performance



System shall support:



Minimum:



5000 members



50 concurrent users



Attendance response:



<2 seconds



Door unlock:



<1 second



\---



\## Availability



Target uptime:



99%



\---



\## Security



Authentication:



Username/password



2FA (future)



Role-based access



\---



\## Data Security



Encrypt:



Passwords



Sensitive information



Backups



\---



\## Audit Logs



Track:



User



Action



Date



Changes



\---



\# 5. Database Entities (Initial)



Main tables:



Members



MembershipPlans



MemberSubscriptions



Attendance



BiometricDevices



Invoices



Accounts



Transactions



InventoryItems



StockTransactions



Suppliers



Employees



Users



Roles



Branches



\---



\# 6. External Integrations



Required integrations:



\### Biometric



\* ZKTeco

\* Other SDK-supported readers



Functions:



Enroll user



Delete user



Sync attendance



Open door relay



Lock door



\---



\### Payment



UPI



Razorpay (future)



Stripe (future)



\---



\### Messaging



WhatsApp API



SMS Gateway



Email



\---



\# 7. Suggested Technology Stack



Since you work in Flutter:



Frontend:



\* Flutter (Desktop + Web)



Backend:



\* Go / PHP Laravel / NodeJS



Database:



\* PostgreSQL or MySQL



Realtime:



\* WebSocket



Biometric Middleware:



Python service or C# service communicating with SDK



Accounting:



Double-entry bookkeeping architecture from day one



\---



\# 8. Future Modules (Recommended)



These become selling points:



\* Workout tracking

\* Diet plans

\* Trainer schedules

\* QR attendance

\* Mobile app

\* Online membership purchase

\* AI workout assistant

\* CCTV integration

\* Facial recognition entry

\* Franchise/multi-branch support





\# 9. Use Cases



This section describes how users interact with the system.



\---



\# UC-01: Register New Member



\### Actors



Reception Staff, Admin



\### Preconditions



\* User logged in

\* Membership plan exists



\### Flow



1\. Open Member Registration

2\. Enter member details

3\. Upload photo/documents

4\. Select membership plan

5\. Record payment

6\. Save member

7\. Generate member ID

8\. Optionally enroll biometric



\### Post Conditions



Member becomes active.



\---



\# UC-02: Renew Membership



\### Actors



Reception Staff



\### Flow



1\. Search member

2\. Open membership details

3\. Select renewal plan

4\. Receive payment

5\. Generate invoice

6\. Update expiry date



\---



\# UC-03: Member Entry Using Biometric



\### Actors



Member



\### Preconditions



Member enrolled in biometric device



\---



\### Flow



Member scans fingerprint



System:



Validate member



Check membership status



IF active:



Record attendance



Unlock door



Allow entry



ELSE:



Reject access



Show reason



\---



\### Exceptions



Expired membership



Suspended membership



Attendance limit exceeded



\---



\# UC-04: Sell Inventory Item



\### Actors



Reception Staff



Flow:



Search product



Enter quantity



Collect payment



Generate invoice



Update stock



\---



\# UC-05: Record Expense



\### Actors



Accountant



Examples:



Electricity



Rent



Salary



Equipment purchase



Marketing



\---



\# UC-06: Add Biometric Device



Actors:



Admin



Flow:



Enter:



IP



Port



Device Name



SDK Type



Test connection



Save



\---



\# 10. Workflow Definitions



\---



\# Workflow: New Member Enrollment



```text

Register Member

&#x20;     ↓

Choose Membership

&#x20;     ↓

Receive Payment

&#x20;     ↓

Generate Invoice

&#x20;     ↓

Create Subscription

&#x20;     ↓

Enroll Fingerprint

&#x20;     ↓

Activate Access

```



\---



\# Workflow: Gym Entry



```text

Fingerprint Scan

&#x20;     ↓

Find Member

&#x20;     ↓

Check Membership

&#x20;     ↓

Check Attendance Rules

&#x20;     ↓

Unlock Door

&#x20;     ↓

Save Attendance

```



\---



\# Workflow: Membership Expiry



```text

Expiry Near

&#x20;     ↓

Send Reminder

&#x20;     ↓

Member Renews

&#x20;       ↓

&#x20;     Update Subscription



OR



No Renewal

&#x20;     ↓

Membership Expired

&#x20;     ↓

Disable Door Access

```



\---



\# Workflow: Inventory Purchase



```text

Supplier Invoice

&#x20;     ↓

Purchase Entry

&#x20;     ↓

Increase Stock

&#x20;     ↓

Update Accounts

```



\---



\# 11. Business Rules



Critical rules the software must enforce.



\---



\## Membership Rules



BR-01



Member cannot enter gym if:



Membership expired



\---



BR-02



Suspended members denied entry



\---



BR-03



Freeze period extends expiry



Example:



30-day membership



Freeze 5 days



Expiry extends 5 days



\---



BR-04



One membership cannot be shared among multiple members



\---



\# Attendance Rules



BR-05



Attendance recorded only once within configurable period



Example:



Ignore duplicate scans within 5 mins



\---



BR-06



Late-night access restrictions configurable



\---



\# Inventory Rules



BR-07



Negative stock prohibited



\---



BR-08



Low stock alert when quantity below minimum



\---



\# Accounting Rules



BR-09



Every transaction must affect two accounts



(Double-entry accounting)



Example:



Membership Sale



```text

Cash      +1000

Revenue   -1000

```



\---



BR-10



Invoices cannot be deleted after posting



Only cancel/reverse



\---



\# Security Rules



BR-11



Passwords stored encrypted



\---



BR-12



All critical operations logged



\---



\# 12. Reporting Requirements



\---



\# Membership Reports



Required:



Active Members



Expired Members



Renewal Due



Inactive Members



Gender Analysis



Age Group Analysis



\---



\# Attendance Reports



Daily attendance



Monthly attendance



Peak hours



Member frequency



No-show analysis



\---



\# Revenue Reports



Daily sales



Monthly revenue



Membership revenue



Product sales



Expense analysis



Profit/Loss



\---



\# Inventory Reports



Current stock



Low stock



Purchase history



Sales history



Stock valuation



\---



\# Staff Reports



Staff attendance



Salary report



Performance report



\---



\# 13. Dashboard Requirements



\---



\## Admin Dashboard



Widgets:



```text

Total Members

Active Members

Expired Members

Today's Entry Count

Revenue Today

Pending Renewals

Low Stock Alerts

Profit This Month

```



Charts:



Monthly revenue



Attendance trends



Renewals



\---



\## Reception Dashboard



Widgets:



Today's Visits



Expiring Memberships



Pending Payments



Recent Registrations



\---



\## Accountant Dashboard



Widgets:



Cash Balance



Today's Collection



Expenses



Outstanding Dues



\---



\# 14. API Requirements



Software should expose APIs.



\---



\## Authentication API



```http

POST /login

POST /logout

POST /refresh-token

```



\---



\## Members API



```http

GET /members



POST /members



PUT /members/{id}



DELETE /members/{id}

```



\---



\## Membership API



```http

GET /subscriptions



POST /renew

```



\---



\## Attendance API



```http

POST /attendance



GET /attendance

```



\---



\## Biometric API



```http

POST /device/connect



POST /device/unlock



POST /device/sync

```



\---



\## Inventory API



```http

POST /stock



POST /sale

```



\---



\## Accounting API



```http

POST /invoice



POST /payment



POST /expense

```



\---



\# 15. Hardware Requirements



\---



\## Server



Minimum:



4 Core CPU



8GB RAM



SSD



\---



Recommended:



8 Core



16–32GB RAM



NVMe SSD



\---



\## Client PC



Windows/Linux



8GB RAM



\---



\## Biometric Device



Support:



Fingerprint



RFID



Face recognition



Door relay



\---



\## Network



LAN support mandatory



Internet optional



(Gym must work offline)



This is important because attendance should continue during outages.



\---



\# 16. Backup Requirements



Automatic:



Daily backup



Weekly backup



Monthly backup



\---



Support:



Local backup



Cloud backup



\---



Restore feature required.



\---



\# 17. Offline Requirements



System should continue functioning without internet:



Attendance



Billing



Inventory



Membership lookup



Biometric access



Accounting



Sync later when internet returns



\---



\# 18. Multi-Branch Support (Future Ready)



Design DB for:



Branches



Separate inventory



Separate attendance



Separate accounting



Central dashboard



\---



\# 19. Risks \& Constraints



Possible risks:



Biometric SDK incompatibility



Internet failures



Power failures



Data corruption



Concurrent access conflicts



\---



Mitigation:



UPS



Auto backup



Audit logs



Retry queues



Local cache



\---



\# 20. Acceptance Criteria (MVP Completion)



Software accepted when:



✓ Register member



✓ Create membership



✓ Renew membership



✓ Capture attendance



✓ Unlock door



✓ Record payments



✓ Maintain inventory



✓ Generate invoices



✓ View reports



✓ Role-based login works



✓ Backup/restore works



\---



\# 21. Recommended Architecture



For scalability:



```text

Flutter Desktop/Web

&#x20;       ↓

REST/WebSocket API

&#x20;       ↓

Backend Service

&#x20;       ↓

PostgreSQL/MySQL

&#x20;       ↓

Biometric Middleware

&#x20;       ↓

Biometric Device

```



Microservices later:



```text

Auth Service



Membership Service



Attendance Service



Accounting Service



Inventory Service



Notification Service

```



\---



This completes a reasonably professional SRS for version 1.0. The next document would usually be:



1\. ER Diagram

2\. Database schema

3\. UI wireframes

4\. API specification (Swagger/OpenAPI)

5\. Project estimation \& milestones

6\. Module-wise development plan.





\# 22. Entity Relationship Design (High-Level)



Initial database structure for MVP.



\---



\## Members



Stores member information.



Fields:



```text

member\_id (PK)

member\_code

full\_name

mobile

email

dob

gender

address

photo

height

weight

medical\_notes

joining\_date

status

branch\_id

created\_at

updated\_at

```



Relationship:



```text

Members

&#x20;  |

&#x20;  |----< MembershipSubscriptions

&#x20;  |

&#x20;  |----< Attendance

&#x20;  |

&#x20;  |----< Invoices

```



\---



\## MembershipPlans



```text

plan\_id (PK)



plan\_name



duration\_days



price



tax\_percent



freeze\_allowed



max\_visits



active

```



\---



\## MembershipSubscriptions



Tracks actual subscriptions.



```text

subscription\_id (PK)



member\_id (FK)



plan\_id (FK)



start\_date



expiry\_date



status



freeze\_days



remaining\_visits



invoice\_id



created\_at

```



\---



Status:



Active



Expired



Suspended



Frozen



Cancelled



\---



\## Attendance



```text

attendance\_id (PK)



member\_id (FK)



device\_id



checkin\_time



checkout\_time



access\_granted



remarks

```



\---



\## BiometricDevices



```text

device\_id (PK)



name



ip\_address



port



sdk\_type



branch\_id



status



last\_sync

```



\---



\## DeviceUsers



Maps biometric user ID to gym member.



```text

device\_user\_id



member\_id



biometric\_uid



device\_id

```



\---



\## InventoryItems



```text

item\_id (PK)



item\_code



barcode



name



category\_id



purchase\_rate



selling\_rate



stock\_qty



minimum\_stock



tax\_rate



supplier\_id

```



\---



\## InventoryTransactions



Use stock ledger model.



```text

txn\_id



item\_id



txn\_type



qty



rate



reference\_type



reference\_id



date

```



Transaction Types:



Purchase



Sale



Adjustment



Damage



Consumption



Transfer



\---



\## Suppliers



```text

supplier\_id



name



phone



email



address

```



\---



\## Invoices



Single invoice table.



Supports:



Membership sales



Inventory sales



PT charges



\---



```text

invoice\_id



invoice\_number



invoice\_date



member\_id



total



discount



tax



grand\_total



payment\_status

```



\---



\## InvoiceItems



```text

invoice\_item\_id



invoice\_id



item\_type



item\_id



qty



rate



amount

```



item\_type:



Membership



Inventory



Service



\---



\## Accounts



Chart of accounts.



```text

account\_id



account\_name



account\_type

```



Types:



Asset



Liability



Income



Expense



Equity



\---



\## JournalEntries



Accounting backbone.



\---



Header:



```text

journal\_id



date



reference



remarks

```



\---



Details:



```text

journal\_detail\_id



journal\_id



account\_id



debit



credit

```



\---



Example:



Membership Fee ₹1000



```text

Cash Account      Debit 1000



Membership Income Credit 1000

```



\---



\## Expenses



```text

expense\_id



category



amount



date



vendor



remarks

```



\---



\## Users



```text

user\_id



username



password\_hash



role\_id



active

```



\---



\## Roles



```text

role\_id



role\_name

```



Examples:



Admin



Reception



Trainer



Accountant



\---



\## Branches



Future ready.



```text

branch\_id



name



address



phone

```



\---



\# 23. ER Relationship Summary



High-level:



```text

Branches

&#x20;   |

&#x20;   ├── Members

&#x20;   |        |

&#x20;   |        ├── Attendance

&#x20;   |        |

&#x20;   |        ├── MembershipSubscriptions

&#x20;   |        |

&#x20;   |        └── Invoices

&#x20;   |

&#x20;   ├── Inventory

&#x20;   |

&#x20;   ├── Devices

&#x20;   |

&#x20;   └── Users





Invoices

&#x20;    |

&#x20;    └── InvoiceItems





Accounts

&#x20;    |

&#x20;    └── JournalEntries

```



\---



\# 24. Suggested Folder Structure



Since you prefer Flutter with feature modules:



\## Flutter Frontend



```text

lib/



core/

&#x20;   network/

&#x20;   theme/

&#x20;   auth/

&#x20;   constants/

&#x20;   widgets/



features/



&#x20;   membership/

&#x20;       screens/

&#x20;       bloc/

&#x20;       repository/

&#x20;       models/



&#x20;   attendance/

&#x20;       screens/

&#x20;       bloc/



&#x20;   inventory/

&#x20;       screens/

&#x20;       bloc/



&#x20;   accounting/

&#x20;       screens/

&#x20;       bloc/



&#x20;   biometric/

&#x20;       services/



&#x20;   reports/



&#x20;   settings/



main.dart

```



\---



\## Backend



Example Go/PHP:



```text

backend/



auth/



members/



attendance/



inventory/



accounting/



reports/



devices/



notifications/



shared/

```



\---



\# 25. UI Requirements



Flat Material 3 style.



(Aligns with your preference.)



\---



\## Login Screen



Fields:



Username



Password



Remember login



Branch



\---



\## Dashboard



Cards:



```text

Members Today



Revenue Today



Attendance Today



Pending Renewals



Low Stock



Profit

```



\---



Bottom:



Charts



Recent activity



Alerts



\---



\## Member Screen



Tabs:



```text

Profile



Membership



Attendance



Payments



Invoices

```



\---



\## Inventory Screen



Views:



List



Barcode scan



Purchase



Sales



Reports



\---



\## Accounting Screen



Views:



Receipts



Payments



Ledger



Profit/Loss



Balance Sheet



\---



\# 26. Notification Requirements



System notifications:



Membership expiry



Low stock



Failed attendance



Failed biometric sync



Payment due



Backup failure



\---



Channels:



In-app



Email



WhatsApp (future)



Push notifications



\---



\# 27. Audit Log Requirements



Track every sensitive change.



Store:



```text

log\_id



user\_id



module



action



old\_value



new\_value



datetime



ip

```



Example:



```text

User:

Admin



Action:

Deleted invoice



Time:

10:30AM

```



\---



\# 28. Data Migration Requirements



Support import from:



Excel



CSV



Old software



\---



Import:



Members



Attendance



Inventory



Accounting



\---



\# 29. Deployment Requirements



Supported deployments:



\---



\## Option 1



Local PC



Suitable for:



Single gym



\---



\## Option 2



Local server + LAN



Suitable:



Medium gym



\---



\## Option 3



Cloud SaaS



Suitable:



Multi branch



Franchise gyms



\---



\# 30. Estimated Modules \& Development Timeline (Single Developer)



Approximate:



| Module     | Duration |

| ---------- | -------- |

| Login/Auth | 3 days   |

| Members    | 7 days   |

| Membership | 5 days   |

| Attendance | 7 days   |

| Biometric  | 10 days  |

| Inventory  | 8 days   |

| Accounting | 15 days  |

| Reports    | 6 days   |

| Dashboard  | 4 days   |

| Testing    | 10 days  |



Total MVP:



\~75–90 working days



(One developer)



\---



\# 31. Revenue Model Ideas (Product Perspective)



If selling commercially:



Plans:



Starter:



Single branch



₹999/month



\---



Professional:



Accounting + Inventory



₹2499/month



\---



Enterprise:



Multi branch + biometrics



Custom pricing



\---



Additional income:



Biometric hardware sales



SMS charges



WhatsApp integration



Setup fees



Training fees



\---



\# 32. Final Deliverables



At project completion:



Required deliverables:



✓ Source code



✓ Database schema



✓ API docs



✓ Deployment guide



✓ User manual



✓ Backup guide



✓ Test cases



✓ Installation manual



✓ Hardware integration docs



✓ Admin manual



\---



\# Appendix A: Recommended Future Features



Gym CRM



Trainer scheduling



Workout planner



Diet planner



AI chatbot



QR access



Face recognition



Mobile app



Online booking



Class scheduling



Locker management



Equipment maintenance



\---



\# Appendix B: MVP Scope Freeze



To avoid endless expansion, Version 1.0 includes ONLY:



✓ Membership



✓ Attendance



✓ Biometric



✓ Accounting



✓ Inventory



✓ Reports



✓ Dashboard



✓ Users/Roles



Everything else postponed.



\---



This now resembles a full SRS package suitable to begin estimation, UI design, and database modelling. The next logical document would be a \*\*database schema (SQL tables)\*\* or \*\*screen-by-screen wireframes\*\*.





