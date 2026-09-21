import 'package:app/core/media/document_access.dart';
import 'package:app/features/people/domain/entities/member_document.dart';
import 'package:app/features/people/presentation/people_strings.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

/// Role-variant filter used by Documents UI (BR-HEALTH-001).
List<MemberDocument> visibleDocumentsForRole({
  required UserType role,
  required List<MemberDocument> documents,
}) {
  return documents
      .where((d) => canAccessDocument(role: role, purpose: d.documentType))
      .toList();
}

void main() {
  const docs = [
    MemberDocument(
      id: 1,
      memberId: 10,
      documentType: DocumentPurpose.idProof,
      title: 'ID',
    ),
    MemberDocument(
      id: 2,
      memberId: 10,
      documentType: DocumentPurpose.medicalCert,
      title: 'Cert',
    ),
    MemberDocument(
      id: 3,
      memberId: 10,
      documentType: DocumentPurpose.waiver,
      title: 'Waiver',
    ),
  ];

  testWidgets('trainer role variant hides identity documents from list', (
    tester,
  ) async {
    final visible = visibleDocumentsForRole(
      role: UserType.trainer,
      documents: docs,
    );

    await pumpApp(
      tester,
      Scaffold(
        appBar: AppBar(title: const Text(PeopleStrings.documents)),
        body: ListView(
          children: [
            for (final doc in visible)
              ListTile(title: Text(doc.title ?? doc.documentType.name)),
          ],
        ),
      ),
    );

    expect(find.text('Cert'), findsOneWidget);
    expect(find.text('ID'), findsNothing);
    expect(find.text('Waiver'), findsNothing);
  });

  testWidgets('admin role variant shows identity documents', (tester) async {
    final visible = visibleDocumentsForRole(
      role: UserType.admin,
      documents: docs,
    );

    await pumpApp(
      tester,
      Scaffold(
        body: ListView(
          children: [
            for (final doc in visible)
              ListTile(title: Text(doc.title ?? doc.documentType.name)),
          ],
        ),
      ),
    );

    expect(find.text('ID'), findsOneWidget);
    expect(find.text('Waiver'), findsOneWidget);
    expect(find.text('Cert'), findsOneWidget);
  });
}
