import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../bloc/members_directory_bloc.dart';
import '../people_strings.dart';

class MembersDirectoryScreen extends StatelessWidget {
  const MembersDirectoryScreen({
    super.key,
    this.memberDetailPathBuilder,
    this.addMemberPath,
  });

  /// Builds the detail path for a member id.
  /// Defaults to the admin members dossier path.
  final String Function(int id)? memberDetailPathBuilder;

  /// When non-null and the session has `members.create`, shows the add FAB.
  /// Admin passes [Routes.adminMembersAdd]; trainer omits this (no create route).
  final String? addMemberPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<MembersDirectoryBloc>()..add(const MembersDirectoryStarted()),
      child: _MembersDirectoryBody(
        memberDetailPathBuilder: memberDetailPathBuilder,
        addMemberPath: addMemberPath,
      ),
    );
  }
}

class _MembersDirectoryBody extends StatefulWidget {
  const _MembersDirectoryBody({
    this.memberDetailPathBuilder,
    this.addMemberPath,
  });

  final String Function(int id)? memberDetailPathBuilder;
  final String? addMemberPath;

  @override
  State<_MembersDirectoryBody> createState() => _MembersDirectoryBodyState();
}

class _MembersDirectoryBodyState extends State<_MembersDirectoryBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    context.read<MembersDirectoryBloc>().add(
      MembersDirectoryQueryChanged(value),
    );
  }

  Future<void> _openAddMember() async {
    final path = widget.addMemberPath;
    if (path == null) return;
    await context.push(path);
    if (!mounted) return;
    context.read<MembersDirectoryBloc>().add(const MembersDirectoryStarted());
  }

  @override
  Widget build(BuildContext context) {
    final canCreate =
        widget.addMemberPath != null && context.can('members.create');

    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.membersTitle)),
      floatingActionButton: canCreate
          ? FloatingActionButton(
              onPressed: _openAddMember,
              tooltip: PeopleStrings.addMemberTitle,
              child: const Icon(Icons.person_add_alt_1),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: PeopleStrings.searchHint,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _onQueryChanged(_searchController.text),
                ),
              ),
              onChanged: _onQueryChanged,
              onSubmitted: _onQueryChanged,
            ),
          ),
          Expanded(
            child: BlocConsumer<MembersDirectoryBloc, MembersDirectoryState>(
              listener: (context, state) {
                if (state.status == LoadStatus.failure &&
                    state.items.isNotEmpty &&
                    state.failure != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(failureMessage(state.failure!))),
                  );
                }
              },
              builder: (context, state) {
                if (state.items.isEmpty && state.status == LoadStatus.failure) {
                  return AppErrorView(
                    message: failureMessage(state.failure!),
                    onRetry: () => context.read<MembersDirectoryBloc>().add(
                      const MembersDirectoryStarted(),
                    ),
                  );
                }
                if (state.items.isEmpty && state.status != LoadStatus.success) {
                  return const AppLoading();
                }
                if (state.items.isEmpty) {
                  return const AppEmptyView(
                    message: PeopleStrings.emptyMembers,
                  );
                }
                return ListView.builder(
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      final loadingMore = state.loadingMore;
                      return TextButton(
                        onPressed:
                            loadingMore || state.status == LoadStatus.loading
                            ? null
                            : () => context.read<MembersDirectoryBloc>().add(
                                const MembersDirectoryLoadMoreRequested(),
                              ),
                        child: Text(loadingMore ? '…' : PeopleStrings.loadMore),
                      );
                    }
                    final member = state.items[index];
                    final pathBuilder = widget.memberDetailPathBuilder;
                    final path = pathBuilder != null
                        ? pathBuilder(member.id)
                        : Routes.adminMembersDetail.replaceFirst(
                            ':id',
                            '${member.id}',
                          );
                    return ListTile(
                      title: Text(member.fullName),
                      subtitle: Text(member.membershipNumber),
                      trailing: member.membershipStatus == null
                          ? null
                          : Text(member.membershipStatus!),
                      onTap: () async {
                        await context.push(path);
                        if (context.mounted) {
                          context.read<MembersDirectoryBloc>().add(
                            const MembersDirectoryStarted(),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
