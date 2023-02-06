part of '../emitter.dart';

abstract class EventListenerController<T extends Event> extends EventListener<T> {
  EventListenerController(super.target, {
    super.alias,

    super.protected = false,
    super.once = false,
  });

  /* -= Mounting Methods =- */
  
  void bind(EventEmitter emitter);
  void unbind();

  /* -= Event Methods =- */

  bool execute(T event);
}