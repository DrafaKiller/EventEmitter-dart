part of 'emitter.dart';

abstract class EventSubscription<T extends Event> extends StreamSubscription<T> {
  final EventEmitter emitter;
  final EventListener<T> listener;

  EventSubscription(this.emitter, this.listener);

  /* -= Event Methods =- */

  EventStream<T> get stream;

  bool get cancelled;
  Future<void> cancel();

  /* -= Callbacks =- */

  Future<void> get onCancel;
}