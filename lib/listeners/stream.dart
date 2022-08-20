import 'dart:async';

import 'package:events_emitter/listener.dart';
import 'package:rxdart/rxdart.dart';

/// # Stream Event Listener
/// A listener is a subscription to a specific **event type** and **data type**.
/// 
/// This includes all the information needed for how to react with an event emitter.
/// 
/// This specific listener also includes a [Stream] to listen to.
/// The [callback] property is optional, useful to return the callback satisfaction.
class StreamEventListener<T> extends EventListener<T> {
  final _controller = BehaviorSubject<T>();

  StreamEventListener(String? type, {
    EventCallback<T>? callback,
    super.once,
    super.protected,
    super.onAdd, super.onRemove, super.onCall, super.onCancel,
    super.cancelAdded,
  }) : super(type, callback ?? (T data) {}) {
    appendCallback(
      onRemove: (emitter) => close(),
      onCall: (listener, data) => _controller.add(data),
    );
  }

  Stream<T> get stream => _controller.stream;

  void close() => _controller.close();
}
