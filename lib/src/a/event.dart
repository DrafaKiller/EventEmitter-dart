part of 'emitter.dart';

class Event<T> implements Interface.Event<T> {
  final String type;
  final T data;

  const Event(this.type, this.data);
  
  bool matches<EventT extends Interface.Event>([ String? type ]) =>
    ( type == null || type == this.type ) &&
    isAssignable<T, EventT>();
}