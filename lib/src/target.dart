part of 'emitter.dart';

class EventTarget<T extends Event> implements I.EventTarget<T> {
  final String? type;

  const EventTarget([ this.type ]);

  bool accept<EventT extends I.Event>(EventT event) => event.matches<T>(type);
  bool matches<EventT extends I.Event>([ String? type ]) =>
    ( type == null || type == this.type ) &&
    isAssignable<T, EventT>();
}