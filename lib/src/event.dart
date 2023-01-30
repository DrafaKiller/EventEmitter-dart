part of 'emitter.dart';

class Event<T> {
  final String type;
  final T data;
  
  const Event(this.type, this.data);

  bool matches<EventT extends Event>([ String? type ]) =>
    ( type == null || type == this.type ) &&
    isAssignable<T, EventT>();
}
