part of 'emitter.dart';

abstract class EventSubscription<T extends Event> {
  /* -= Mounting Methods =- */
  
  abstract final EventEmitter emitter;
  bool get mounted;

  /* -= Event Methods =- */

  EventStream<T> get stream;

  bool get cancelled;
  bool cancel();

  /* -= Callbacks =- */

  Future<void> get onCancel;
}