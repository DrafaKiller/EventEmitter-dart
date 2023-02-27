part of 'emitter.dart';

class EventTarget<T extends Event> {
  final String? type;

  EventTarget([ this.type ]);

  bool accepts<EventT extends Event>(EventT event) => matches<EventT>(event.type);

  bool matches<EventT extends Event>([ String? type ]) =>
    ( type == null || type == this.type ) &&
    isAssignable<T, EventT>();
}