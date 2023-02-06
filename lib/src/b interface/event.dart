part of 'emitter.dart';

abstract class Event<T> {
  final String type;
  final T data;

  const Event(this.type, this.data);

  bool matches<EventT extends Event>([ String? type ]);
}
