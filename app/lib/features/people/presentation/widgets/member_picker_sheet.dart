import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/widgets/app_picker_form_field.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../domain/entities/member_filter.dart';
import '../../domain/entities/profile_summary.dart';
import '../../domain/usecases/list_members_usecase.dart';
import '../people_strings.dart';

/// Opens a searchable, paginated bottom sheet to select a member.
Future<ProfileSummary?> showMemberPickerSheet(
  BuildContext context, {
  ListMembersUseCase? listMembers,
  int? assignedTrainerId,
  Set<int> excludeMemberIds = const {},
}) {
  return showModalBottomSheet<ProfileSummary>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => MemberPickerSheet(
      listMembers: listMembers,
      assignedTrainerId: assignedTrainerId,
      excludeMemberIds: excludeMemberIds,
    ),
  );
}

/// A form field that displays the selected member and opens [showMemberPickerSheet] on tap.
class MemberPickerField extends StatelessWidget {
  const MemberPickerField({
    super.key,
    required this.onChanged,
    this.selectedMember,
    this.selectedMemberId,
    this.selectedMemberName,
    this.labelText = 'Member',
    this.hintText = 'Select a member',
    this.enabled = true,
    this.listMembers,
    this.assignedTrainerId,
    this.excludeMemberIds = const {},
  });

  final ProfileSummary? selectedMember;
  final String? selectedMemberId;
  final String? selectedMemberName;
  final ValueChanged<ProfileSummary?> onChanged;
  final String labelText;
  final String hintText;
  final bool enabled;
  final ListMembersUseCase? listMembers;
  final int? assignedTrainerId;

  /// Members that must not be offered, e.g. the primary member when picking
  /// their couple partner.
  final Set<int> excludeMemberIds;

  String? get _displayLabel {
    if (selectedMember != null) {
      return '${selectedMember!.fullName} (${selectedMember!.membershipNumber})';
    }
    if (selectedMemberName != null && selectedMemberName!.isNotEmpty) {
      if (selectedMemberId != null && selectedMemberId!.isNotEmpty) {
        return '$selectedMemberName (#$selectedMemberId)';
      }
      return selectedMemberName;
    }
    if (selectedMemberId != null && selectedMemberId!.isNotEmpty) {
      return 'Member #$selectedMemberId';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final label = _displayLabel;

    return AppPickerFormField<ProfileSummary>(
      value: selectedMember,
      labelText: labelText,
      hintText: hintText,
      enabled: enabled,
      labelBuilder: (_) => label ?? '',
      onPick: (context) => showMemberPickerSheet(
        context,
        listMembers: listMembers,
        assignedTrainerId: assignedTrainerId,
        excludeMemberIds: excludeMemberIds,
      ),
      onChanged: onChanged,
    );
  }
}

class MemberPickerSheet extends StatelessWidget {
  const MemberPickerSheet({
    super.key,
    this.listMembers,
    this.assignedTrainerId,
    this.excludeMemberIds = const {},
  });

  final ListMembersUseCase? listMembers;
  final int? assignedTrainerId;
  final Set<int> excludeMemberIds;

  @override
  Widget build(BuildContext context) {
    final useCase = listMembers ?? getIt<ListMembersUseCase>();
    return AppPagedPickerSheet<ProfileSummary>(
      searchLabel: 'Search members by name...',
      searchFieldKey: const Key('member_search_field'),
      emptyMessage: PeopleStrings.emptyMembers,
      retryLabel: PeopleStrings.retry,
      heightFactor: 0.85,
      autofocus: true,
      fetcher: ({cursor, query}) async {
        final result = await useCase(
          ListMembersParams(
            filter: MemberFilter(
              query: query,
              assignedTrainerId: assignedTrainerId,
            ),
            cursor: cursor,
          ),
        );
        if (excludeMemberIds.isEmpty) return result;
        return result.map(
          (page) => CursorPage<ProfileSummary>(
            items: page.items
                .where((m) => !excludeMemberIds.contains(m.id))
                .toList(),
            nextCursor: page.nextCursor,
            hasMore: page.hasMore,
          ),
        );
      },
      itemBuilder: (context, member) => ListTile(
        key: Key('member_option_${member.id}'),
        leading: CircleAvatar(
          backgroundImage: member.avatarUrl != null
              ? NetworkImage(member.avatarUrl!)
              : null,
          child: member.avatarUrl == null
              ? Text(
                  member.fullName.isNotEmpty
                      ? member.fullName[0].toUpperCase()
                      : 'M',
                )
              : null,
        ),
        title: Text(
          member.fullName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Membership: ${member.membershipNumber}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: member.membershipStatus != null
            ? ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 110),
                child: Chip(
                  label: Text(
                    member.membershipStatus!,
                    style: const TextStyle(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              )
            : null,
        onTap: () => Navigator.of(context).pop(member),
      ),
    );
  }
}
