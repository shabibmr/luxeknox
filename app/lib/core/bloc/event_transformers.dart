import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:bloc_concurrency/bloc_concurrency.dart' show droppable, sequential;

/// Debounce an event stream, then restart the previous handler.
///
/// Shared by exercise search, food search, and the members directory
/// (ADR-0006 §4).
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events
      .transform(_DebounceStreamTransformer<E>(duration))
      .switchMap(mapper);
}

class _DebounceStreamTransformer<T> extends StreamTransformerBase<T, T> {
  const _DebounceStreamTransformer(this.duration);

  final Duration duration;

  @override
  Stream<T> bind(Stream<T> stream) {
    Timer? timer;
    StreamController<T>? controller;

    controller = StreamController<T>(
      onListen: () {
        final subscription = stream.listen(
          (data) {
            timer?.cancel();
            timer = Timer(duration, () {
              if (!controller!.isClosed) {
                controller.add(data);
              }
            });
          },
          onError: (Object error, StackTrace stackTrace) {
            controller?.addError(error, stackTrace);
          },
          onDone: () {
            timer?.cancel();
            controller?.close();
          },
        );

        controller?.onCancel = () {
          timer?.cancel();
          return subscription.cancel();
        };
      },
    );

    return controller.stream;
  }
}

extension _StreamSwitchMap<T> on Stream<T> {
  Stream<R> switchMap<R>(Stream<R> Function(T event) mapper) {
    StreamSubscription<R>? innerSubscription;
    StreamSubscription<T>? outerSubscription;
    StreamController<R>? controller;

    controller = StreamController<R>(
      onListen: () {
        outerSubscription = listen(
          (data) {
            innerSubscription?.cancel();
            innerSubscription = mapper(data).listen(
              (r) => controller?.add(r),
              onError: (Object e, StackTrace s) => controller?.addError(e, s),
            );
          },
          onError: (Object e, StackTrace s) => controller?.addError(e, s),
          onDone: () => controller?.close(),
        );

        controller?.onCancel = () async {
          await innerSubscription?.cancel();
          await outerSubscription?.cancel();
        };
      },
    );

    return controller.stream;
  }
}
