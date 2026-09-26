import 'package:luxeknox/session/domain/entities/principal.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Principal', () {
    test('should support value equality', () {
      const principal1 = Principal(
        userId: 'user-1',
        userType: UserType.member,
        displayName: 'John Doe',
        profileId: 'profile-1',
      );

      const principal2 = Principal(
        userId: 'user-1',
        userType: UserType.member,
        displayName: 'John Doe',
        profileId: 'profile-1',
      );

      expect(principal1, equals(principal2));
    });

    test('should not be equal when userId differs', () {
      const principal1 = Principal(
        userId: 'user-1',
        userType: UserType.member,
        displayName: 'John Doe',
        profileId: 'profile-1',
      );

      const principal2 = Principal(
        userId: 'user-2',
        userType: UserType.member,
        displayName: 'John Doe',
        profileId: 'profile-1',
      );

      expect(principal1, isNot(equals(principal2)));
    });

    test('should not be equal when userType differs', () {
      const principal1 = Principal(
        userId: 'user-1',
        userType: UserType.member,
        displayName: 'John Doe',
        profileId: 'profile-1',
      );

      const principal2 = Principal(
        userId: 'user-1',
        userType: UserType.trainer,
        displayName: 'John Doe',
        profileId: 'profile-1',
      );

      expect(principal1, isNot(equals(principal2)));
    });

    test('should not be equal when displayName differs', () {
      const principal1 = Principal(
        userId: 'user-1',
        userType: UserType.member,
        displayName: 'John Doe',
        profileId: 'profile-1',
      );

      const principal2 = Principal(
        userId: 'user-1',
        userType: UserType.member,
        displayName: 'Jane Doe',
        profileId: 'profile-1',
      );

      expect(principal1, isNot(equals(principal2)));
    });

    test('should not be equal when profileId differs', () {
      const principal1 = Principal(
        userId: 'user-1',
        userType: UserType.member,
        displayName: 'John Doe',
        profileId: 'profile-1',
      );

      const principal2 = Principal(
        userId: 'user-1',
        userType: UserType.member,
        displayName: 'John Doe',
        profileId: 'profile-2',
      );

      expect(principal1, isNot(equals(principal2)));
    });
  });
}
