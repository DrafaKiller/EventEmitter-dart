part of 'emitter.dart';

class Event<T> {
  final String type;
  final T data;

  const Event(this.type, this.data);
}

/* -= Extended Functionality =- */

extension _WrappedEvent<T extends Event> on T {
  bool get isWrapped => data is Event;
  Event<T> wrap() => Event<T>(type, this);
}