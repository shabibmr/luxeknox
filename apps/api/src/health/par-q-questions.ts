/** One list drives PAR-Q+ validation, insert, and response mapping. */
export const PAR_Q_QUESTIONS = [
  { answer: 'q1_heart_condition', details: 'q1_details' },
  { answer: 'q2_chest_pain_activity', details: 'q2_details' },
  { answer: 'q3_chest_pain_rest', details: 'q3_details' },
  { answer: 'q4_dizziness_consciousness', details: 'q4_details' },
  { answer: 'q5_bone_joint_problem', details: 'q5_details' },
  { answer: 'q6_medication_condition', details: 'q6_details' },
  { answer: 'q7_other_reason', details: 'q7_details' },
] as const;

export type ParQQuestionKey = (typeof PAR_Q_QUESTIONS)[number]['answer'];
export type ParQDetailsKey = (typeof PAR_Q_QUESTIONS)[number]['details'];
