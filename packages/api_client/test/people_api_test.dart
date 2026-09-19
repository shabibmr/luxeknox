import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for PEOPLEApi
void main() {
  final instance = ApiClient().getPEOPLEApi();

  group(PEOPLEApi, () {
    // Assign or reassign a trainer
    //
    //Future<Member> assignTrainer(int id, AssignTrainerRequest assignTrainerRequest) async
    test('test assignTrainer', () async {
      // TODO
    });

    // Create an employee
    //
    //Future<Employee> createEmployee(EmployeeCreate employeeCreate) async
    test('test createEmployee', () async {
      // TODO
    });

    // Onboard a member (user + profile, one transaction)
    //
    //Future<Member> createMember(MemberCreate memberCreate) async
    test('test createMember', () async {
      // TODO
    });

    // Create a trainer
    //
    //Future<Trainer> createTrainer(TrainerCreate trainerCreate) async
    test('test createTrainer', () async {
      // TODO
    });

    // Employee profile
    //
    //Future<Employee> getEmployee(int id) async
    test('test getEmployee', () async {
      // TODO
    });

    // Member dossier (role-scoped)
    //
    //Future<MemberDossier> getMember(int id) async
    test('test getMember', () async {
      // TODO
    });

    // Trainer profile (rate hidden from members)
    //
    //Future<Trainer> getTrainer(int id) async
    test('test getTrainer', () async {
      // TODO
    });

    // Staff directory
    //
    //Future<EmployeePage> listEmployees({ int limit, int offset, String q }) async
    test('test listEmployees', () async {
      // TODO
    });

    // Member directory (scoped by role)
    //
    //Future<MemberPage> listMembers({ int limit, int offset, String cursor, String q, String sort, UserStatus status, String membershipStatus, int assignedTrainerId }) async
    test('test listMembers', () async {
      // TODO
    });

    // Members assigned to a trainer
    //
    //Future<MemberPage> listTrainerMembers(int id, { int limit, int offset }) async
    test('test listTrainerMembers', () async {
      // TODO
    });

    // Trainer directory
    //
    //Future<TrainerPage> listTrainers({ int limit, int offset, String q }) async
    test('test listTrainers', () async {
      // TODO
    });

    // Change employment status; suspend revokes sessions
    //
    //Future<Employee> setEmployeeStatus(int id, EmployeeStatusRequest employeeStatusRequest) async
    test('test setEmployeeStatus', () async {
      // TODO
    });

    // Update employee
    //
    //Future<Employee> updateEmployee(int id, EmployeeUpdate employeeUpdate) async
    test('test updateEmployee', () async {
      // TODO
    });

    // Update member profile
    //
    //Future<Member> updateMember(int id, MemberUpdate memberUpdate) async
    test('test updateMember', () async {
      // TODO
    });

    // Update trainer
    //
    //Future<Trainer> updateTrainer(int id, TrainerUpdate trainerUpdate) async
    test('test updateTrainer', () async {
      // TODO
    });

  });
}
