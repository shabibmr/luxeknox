import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/members_directory_cubit.dart';
import '../people_strings.dart';

class MembersDirectoryScreen extends StatelessWidget {
  const MembersDirectoryScreen({
    super.key,
    this.memberDetailPathBuilder,
  });

  /// Builds the detail path for a member id.
  /// Defaults to the admin members dossier path.
  final String Function(int id)? memberDetailPathBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MembersDirectoryCubit>()..load(),
      child: _MembersDirectoryBody(
        memberDetailPathBuilder: memberDetailPathBuilder,
      ),
    );
  }
}

class _MembersDirectoryBody extends StatefulWidget {
  const _MembersDirectoryBody({this.memberDetailPathBuilder});

  final String Function(int id)? memberDetailPathBuilder;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.membersTitle)),
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
                  onPressed: () => context.read<MembersDirectoryCubit>().load(
                    query: _searchController.text,
                  ),
                ),
              ),
              onSubmitted: (value) =>
                  context.read<MembersDirectoryCubit>().load(query: value),
            ),
          ),
          Expanded(
            child: BlocBuilder<MembersDirectoryCubit, MembersDirectoryState>(
              builder: (context, state) {
                return switch (state) {
                  MembersDirectoryLoading() => const AppLoading(),
                  MembersDirectoryFailure(:final message) => AppErrorView(
                    message: message,
                    onRetry: () => context.read<MembersDirectoryCubit>().load(
                      query: _searchController.text,
                    ),
                  ),
                  MembersDirectoryLoaded(
                    :final items,
                    :final hasMore,
                    :final loadingMore,
                  ) =>
                    items.isEmpty
                        ? const AppEmptyView(
                            message: PeopleStrings.emptyMembers,
                          )
                        : ListView.builder(
                            itemCount: items.length + (hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= items.length) {
                                return TextButton(
                                  onPressed: loadingMore
                                      ? null
                                      : () => context
                                            .read<MembersDirectoryCubit>()
                                            .loadMore(),
                                  child: Text(
                                    loadingMore
                                        ? '…'
                                        : PeopleStrings.loadMore,
                                  ),
                                );
                              }
                              final member = items[index];
                              final pathBuilder =
                                  widget.memberDetailPathBuilder;
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
                                onTap: () => context.push(path),
                              );
                            },
                          ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
