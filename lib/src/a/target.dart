part of 'emitter.dart';

class EventTarget<T extends Event> implements Interface.EventTarget<T> {
  final String? type;

  const EventTarget([ this.type ]);

  bool accept<EventT extends Interface.Event>(EventT event) => event.matches<T>(type);
  bool matches<EventT extends Interface.Event>([ String? type ]) =>
    ( type == null || type == this.type ) &&
    isAssignable<T, EventT>();
}