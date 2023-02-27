part of 'emitter.dart';

abstract class Event<T> with Cancelable {
  String get type;
  T get data;
}