/// UI copy for People / Profile screens.
abstract final class PeopleStrings {
  static const membersTitle = 'Members';
  static const trainersTitle = 'Trainers';
  static const employeesTitle = 'Employees';
  static const searchHint = 'Search';
  static const emptyMembers = 'No members found.';
  static const emptyTrainers = 'No trainers found.';
  static const emptyEmployees = 'No employees found.';
  static const retry = 'Retry';
  static const cancel = 'Cancel';
  static const noPermission = 'You do not have permission to view this page.';
  static const dossierTitle = 'Member';
  static const dossierTabOverview = 'Overview';
  static const dossierTabLifestyle = 'Lifestyle & Habits';
  static const clearanceCleared = 'Health clearance: cleared to train';
  static const clearancePending =
      'Health clearance pending — PT booking is blocked';
  static const clearanceRejected =
      'Health clearance rejected — PT booking is blocked';
  static const clearanceNone = 'No PAR-Q+ screening on file';
  static const clearanceUnavailable = 'Health clearance unavailable';
  static const lifestyleStress = 'Stress';
  static const lifestyleSleep = 'Sleep';
  static const lifestyleActivity = 'Activity level';
  static String activityLevelLabel(String name) =>
      '${name[0].toUpperCase()}${name.substring(1)}';
  static const lifestyleNone ='No lifestyle consultation yet.';
  static const lifestyleUnavailable = 'Lifestyle & habits unavailable';
  static const lifestylePriorities = 'Top lifestyle priorities';
  static const lifestyleDomainSleep = 'Sleep';
  static const lifestyleDomainNutrition = 'Nutrition';
  static const lifestyleDomainActivity = 'Activity';
  static const lifestyleDomainRecovery = 'Recovery';
  static String stressScore(int level) => '$level / 10';
  static String sleepHours(double hours) =>
      '${hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1)} h';
  static const assignTrainer = 'Assign trainer';
  static const reassignTrainer = 'Reassign';
  static const unassignedTrainer = 'Unassigned';
  static const assignedTrainer = 'Assigned trainer';
  static const assignMembership = 'Sell / assign membership';
  static const addPersonalTraining = 'Add Personal Training';
  static const trainerAssigned = 'Trainer assigned.';
  static const membership = 'Membership';
  static const membershipExpiry = 'Membership expiry';
  static const noMembership = 'No membership';
  static String coupleWith(String partnerName) => 'Couple with $partnerName';
  static String billedTo(String primaryName) => 'Billed to $primaryName';
  static const balance = 'Balance';
  static const lastCheckIn = 'Last check-in';
  static const nextSchedule = 'Next schedule';
  static const noUpcomingSession = 'No upcoming session';
  static const attendanceThisMonth = 'Attendance this month';
  static const unavailable = 'Unavailable';
  static const personalTraining = 'Personal Training';
  static const ptStatus = 'PT status';
  static const ptActive = 'Active';
  static const ptScheduled = 'Starts soon';
  static const ptExpired = 'Expired';
  static const ptNotPurchased = 'Not purchased';
  static const ptExpiry = 'PT expiry';
  static const contact = 'Contact';
  static const notes = 'Notes';
  static const editProfile = 'Edit profile';
  static const cancelEdit = 'Cancel';
  static const health = 'Health';
  static const goals = 'Goals & progress';
  static const workoutPlan = 'Workout plan';
  static const startWorkoutSession = 'Start workout session';
  static const dietPlan = 'Diet plan';
  static const medicalHistory = 'Medical history';
  static const emergencyContacts = 'Emergency contacts';
  static const documents = 'Documents';
  static const photos = 'Photos & avatar';
  static const save = 'Save';
  static const add = 'Add';
  static const delete = 'Delete';
  static const profileSaved = 'Profile saved.';
  static const healthSaved = 'Health info saved.';
  static const avatarSet = 'Avatar updated.';
  static const trainerIdHint = 'Trainer ID';
  static const firstName = 'First name';
  static const lastName = 'Last name';
  static const phoneNumber = 'Phone number';
  static const bio = 'Biography';
  static const specializations = 'Specializations';
  static const specializationsHint = 'Comma-separated, e.g. Strength, HIIT';
  static const hourlyRate = 'Hourly rate';
  static const loadMore = 'Load more';
  static const emptyHealth = 'No health information yet.';
  static const emptyMedical = 'No medical records.';
  static const emptyEmergency = 'No emergency contacts.';
  static const emptyDocuments = 'No documents.';
  static const emptyPhotos = 'No photos yet.';
  static const bloodGroup = 'Blood group';
  static const heightCm = 'Height (cm)';
  static const weightKg = 'Baseline weight (kg)';
  static const allergies = 'Allergies';
  static const dietaryPreferences = 'Dietary preferences';
  static const physicianName = 'Physician name';
  static const physicianPhone = 'Physician phone';
  static const previous = 'Previous';
  static const recordedOn = 'Recorded on';
  static const recordDate = 'Record date';
  static const recordTitle = 'Title';
  static const description = 'Description';
  static const clearanceStatus = 'Clearance status';
  static const contactName = 'Contact name';
  static const relationship = 'Relationship';
  static const phonePrimary = 'Primary phone';
  static const phoneSecondary = 'Secondary phone';
  static const primaryContact = 'Primary contact';
  static const uploadDocument = 'Upload document';
  static const uploadPhoto = 'Add photo';
  static const setAvatar = 'Set as avatar';
  static const uploadRetry = 'Retry upload';
  static const uploadCancel = 'Cancel upload';
  static const documentTitle = 'Document title';
  static const email = 'Email';
  static const phone = 'Phone';
  static const gender = 'Gender';
  static const genderMale = 'Male';
  static const genderFemale = 'Female';
  static const genderRequired = 'Gender is required. Select Male or Female.';
  static const dateOfBirth = 'Date of birth';
  static const address = 'Address';
  static const changeAvatar = 'Change avatar';
  static const myTrainerTitle = 'My Trainer';
  static const noAssignedTrainer = 'No trainer assigned yet.';
  static const rating = 'Rating';
  static const activeClients = 'Active clients';
  static const capacity = 'Capacity';
  static const bookSession = 'Book Session';

  // Add Member wizard
  static const addMemberTitle = 'Add Member';
  static const stepBasicInfo = 'Basic info';
  static const stepContactAccount = 'Contact & account';
  static const stepReview = 'Review';
  static const password = 'Temporary password';
  static const next = 'Next';
  static const back = 'Back';
  static const createMember = 'Create member';
  static const memberCreated = 'Member created.';
  static const reviewHint = 'Review the details below, then create the member.';
  static const invalidEmail = 'Enter a valid email address.';
  static const alreadySubmittingMember = 'Already submitting — please wait.';

  // Edit Member screen
  static const editMemberTitle = 'Edit Member';
  static const memberSaved = 'Member updated.';

  // Add Trainer
  static const addTrainerTitle = 'Add Trainer';
  static const createTrainer = 'Create trainer';
  static const trainerCreated = 'Trainer created.';
  static const maxClients = 'Max clients';
  static const specializationAddHint = 'Add specialization';
  static const firstNameRequired = 'First name is required.';
  static const phoneRequired = 'Phone number is required.';
  static const passwordRequired = 'Temporary password is required.';
  static const alreadySubmitting = 'Already submitting — please wait.';
  static const deactivateTrainerTitle = 'Deactivate trainer';
  static const deactivateTrainerConfirm =
      'Deactivating this trainer will prevent them from logging in and receiving new member assignments. Assigned members will need reassignment. Continue?';
  static const filterAll = 'All';
  static const filterActive = 'Active';
  static const filterInactive = 'Inactive';
  static const selectTrainerPrompt = 'Select a trainer to view details';
  static const selectEmployeePrompt = 'Select an employee to view details';
  static const addEmployeeTooltip = 'Add employee';
  static const filterStatusTooltip = 'Filter by status';

  // Add / Edit Employee
  static const addEmployeeTitle = 'Add Employee';
  static const editEmployeeTitle = 'Edit Employee';
  static const createEmployee = 'Create employee';
  static const employeeCreated = 'Employee created.';
  static const employeeSaved = 'Employee updated.';
  static const employeeMissing = 'Employee not found.';
  static const jobTitle = 'Job title';
  static const department = 'Department';
  static const hireDate = 'Hire date';
  static const pickHireDate = 'Pick hire date';
  static const clearHireDate = 'Clear hire date';
  static const role = 'Role';
  static const selectRole = 'Select a role';
  static const jobTitleRequired = 'Job title is required.';
  static const employmentStatus = 'Employment status';
  static const statusActive = 'Active';
  static const statusOnProbation = 'On probation';
  static const statusSuspended = 'Suspended';
  static const statusTerminated = 'Terminated';
  static const statusUpdated = 'Employment status updated.';
  static const confirmStatusChangeTitle = 'Confirm status change';
  static const confirmSuspendBody =
      'Suspend this employee? Active sessions will be revoked.';
  static const confirmTerminateBody =
      'Terminate this employee? This should be used for offboarding.';
  static const confirmStatusChange = 'Confirm';
  static const manageRoles = 'Manage roles';
  static const createOnlyHint = 'Set at hire — not editable here.';
  static const clearDepartment = 'Clear department';

  // Employee roles screen
  static const employeeRolesTitle = 'Roles & Permissions';
  static const currentRole = 'Current role';
  static const noRoleAssigned = 'No role assigned';
  static const availableRoles = 'Available roles';
  static const assign = 'Assign';
  static const roleAssigned = 'Role assigned.';
  static const permissionsLabel = 'Permissions';
  static const systemRole = 'System role';
  static const emptyRoles = 'No roles configured yet.';

  // Screen 04: PAR-Q+ Screening & Tabs
  static const healthVitalsTab = 'Vitals & General';
  static const parQTab = 'PAR-Q+ Screening';
  static const parQTitle = 'Physical Activity Readiness Questionnaire (PAR-Q+)';
  static const parQSubtitle =
      'Please answer the following 7 screening questions honestly before engaging in personal training or high-intensity exercise.';
  static const parQQ1 =
      '1. Has a healthcare professional ever said you have a heart condition or that you should only do physical activity recommended by a professional?';
  static const parQQ2 =
      '2. Do you feel pain in your chest during physical activity?';
  static const parQQ3 =
      '3. In the past 30 days, have you had chest pain when not doing physical activity?';
  static const parQQ4 =
      '4. Do you lose balance because of dizziness or have you ever lost consciousness?';
  static const parQQ5 =
      '5. Do you have a bone, joint, or soft-tissue problem that could be made worse by physical activity?';
  static const parQQ6 =
      '6. Are you currently taking medication or have another health condition that may affect exercise participation?';
  static const parQQ7 =
      '7. Is there any other reason you believe you should not participate in physical activity?';
  static const yes = 'Yes';
  static const no = 'No';
  static const parQDetailsLabel = 'Details / Action taken';
  static const parQDetailsHint =
      'Describe the condition, medical advice, or symptoms (required on YES)';
  static const parQDetailsRequired = 'Details are required when answering YES.';
  static const parQDeclaration =
      'I have answered the screening questions honestly and understand that I should inform Luxe Knox of any relevant change in my health or ability to exercise. I understand the trainer is not providing medical diagnosis.';
  static const parQDeclarationRequired =
      'You must accept the declaration to submit.';
  static const parQSignatureTitle = 'Client Signature';
  static const parQSignaturePrompt =
      'Sign below with touch or mouse to certify your declaration';
  static const parQSignatureClear = 'Clear signature';
  static const parQSignatureRequired =
      'Client signature is required before submitting.';
  static const parQSignatureDialogTitle = 'Sign PAR-Q+ Screening';
  static const parQSignatureDone = 'Confirm signature';
  static const parQSubmit = 'Submit PAR-Q+ Screening';
  static const parQSubmitting = 'Submitting screening...';
  static const parQSubmitted = 'PAR-Q+ screening submitted.';
  static const parQPassedTitle = 'Medical Clearance: PASSED';
  static const parQPassedBody =
      'All answers negative. Member is cleared for unrestricted physical training.';
  static const parQPendingTitle = 'Medical Clearance: PENDING CLEARANCE';
  static const parQPendingBody =
      'One or more positive answers recorded. Personal training bookings are gated until medical clearance is approved.';
  static const parQClearedTitle = 'Medical Clearance: CLEARED';
  static const parQClearedBody =
      'Medical clearance has been reviewed and cleared.';
  static const parQRejectedTitle = 'Medical Clearance: REJECTED';
  static const parQRejectedBody =
      'Medical clearance rejected. Member may not participate in PT sessions.';
  static const parQRetake = 'Submit new screening';
}
