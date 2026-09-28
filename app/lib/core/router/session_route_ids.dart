import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../session/presentation/session_cubit.dart';

/// Resolves the authenticated profile id as an int for self-scoped routes.
/// Returns null when the session is missing or the id is not numeric.
int? sessionProfileId(BuildContext context) {
  final state = context.read<SessionCubit>().state;
  if (state is! SessionAuthenticated) return null;
  return int.tryParse(state.principal.profileId);
}

/// Resolves the authenticated user id as an int for self-scoped routes.
int? sessionUserId(BuildContext context) {
  final state = context.read<SessionCubit>().state;
  if (state is! SessionAuthenticated) return null;
  return int.tryParse(state.principal.userId);
}
