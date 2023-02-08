part of 'emitter.dart';

abstract class EventListener<T extends Event> {
  final EventTarget<T> target;
  final EventCallback? alias;

  final bool protected;
  final bool once;

  EventListener(this.target, {
    this.alias,

    this.protected = false,
    this.once = false,
  });

  /* -= Event Methods =- */
  
  EventStream<T> get events;
  bool accept(Event event);
  bool execute(T event);

  /* -= Callbacks =- */

  Future<EventEmitter> get onAdd;
  Future<void> get onRemove;
}