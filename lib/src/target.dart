part of 'emitter.dart';

class EventTarget<T extends Event> {
  final String? type;

  const EventTarget([ this.type ]);

  bool accept<EventT extends Event>(EventT event) => event.matches<T>(type);

  bool matches<EventT extends Event>([ String? type ]) =>
    ( type == null || type == this.type ) &&
    isAssignable<T, EventT>();
}
