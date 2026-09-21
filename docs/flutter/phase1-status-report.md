# Phase 1 Identity & People — status (2026-09-21, People completion pass)

## Already complete (verified)
- Auth / session
- People directories (members, trainers, employees)
- Member dossier edit + trainer assignment
- PersonScope role visibility + data layer for health/medical/emergency/docs

## Newly implemented this pass
- Health info UI (`HealthInfoScreen` + cubit)
- Medical history UI (list/add/edit/delete)
- Emergency contacts UI (list/add/edit/delete)
- Documents UI with BR-HEALTH-001 filtering
- Photos & avatar UI (gallery, upload, set avatar)
- Upload retry/cancel via `MediaUploader.cancel` + pending-bytes retry
- Role-variant tests: `canAccessDocument`, documents list filter, PersonScope (prior)

## People checklist
- [x] health
- [x] medical history
- [x] emergency contacts
- [x] documents
- [x] photos/avatar
- [x] upload retry/cancel
- [x] role-variant tests

## Phase 1 remaining
- None for People / Profile checklist items.

## Recommended next
Continue Phase 2 Membership polish (tests, create-membership flow, navigation wiring) then Scheduling.
