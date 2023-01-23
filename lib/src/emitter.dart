import 'dart:io';

import '../listenable.dart';

part 'event.dart';
part 'listener.dart';

typedef EventCallback<T> = void Function(T data);

class EventEmitter {
  final listeners = <EventListener>{};

  /* -= Listener Methods =- */

  bool addEventListener(EventListener listener) {
    if (listeners.contains(listener)) return false;
    listeners.add(listener);
    listener.onAdd(this);
    return true;
  }

  bool removeEventListener(EventListener listener) {
    if (!listeners.contains(listener)) return false;
    listeners.remove(listener);
    listener.onRemove(this);
    return true;
  }

  bool emitEvent(Event event) {
    var consumed = false;
    for (var listener in listeners) {
      if (listener.accept(event)) consumed = true;
    }
    return consumed;
  }

  /* -= Event Methods =- */

  void emit<T>(String type, [ T? data ]) => emitEvent(Event(type, data));
  
  EventListener<Event<T>> on<T>(String? type, [ EventListenerOnData<T>? callback ]) {
    final listener = EventListener(type, callback: callback);
    addEventListener(listener);
    return listener;
  }

  EventListener<EventT> onEvent<EventT extends Event>([ EventListenerOnEvent<EventT>? callback ]) {
    final listener = EventListener(null, callback: callback);
    addEventListener(listener);
    return listener;
  }
}

void main() {
  final emitter = EventEmitter();
  emitter.on('test', (Event<String> event) => print(event));
  emitter.on('test', (String data) => print(data));
  emitter.onEvent((Event<String> event) => print(event));
  emitter.emit('test', 'Hello World!');
}