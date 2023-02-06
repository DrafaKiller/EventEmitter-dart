part of '../emitter.dart';

abstract class EventEmitterController extends EventEmitter {
  abstract final Set<EventListener> listeners;

  /* -= Listener Methods =- */

  bool addEventListener(EventListener listener);
  bool removeEventListener(EventListener listener);
}