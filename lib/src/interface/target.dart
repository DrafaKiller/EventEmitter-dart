part of 'emitter.dart';

class EventTarget<T extends Event> {
  final String? type;

  const EventTarget(this.type);
}