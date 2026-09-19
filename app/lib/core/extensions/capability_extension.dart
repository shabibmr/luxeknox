import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../session/presentation/session_cubit.dart';

/// Extension on [BuildContext] providing capability checks via [SessionCubit].
///
/// Uses [BuildContext.select] so only widgets inspecting specific capabilities
/// are rebuilt when session capabilities change.
extension CapabilityExtension on BuildContext {
  /// Returns `true` if the currently authenticated user has the given [slug] capability.
  bool can(String slug) {
    return select<SessionCubit, bool>((cubit) {
      final state = cubit.state;
      if (state is SessionAuthenticated) {
        return state.capabilities.can(slug);
      }
      return false;
    });
  }
}
