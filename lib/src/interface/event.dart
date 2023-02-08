part of 'emitter.dart';

class Event<T> {
  final String type;
  final T data;

  const Event(this.type, this.data);
}