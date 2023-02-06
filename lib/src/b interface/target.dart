part of 'emitter.dart';

abstract class EventTarget<T extends Event> {
  final String? type;

  const EventTarget([ this.type ]);

  bool accept<EventT extends Event>(EventT event);
  bool matches<EventT extends Event>([ String? type ]);
}