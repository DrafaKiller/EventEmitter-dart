import '../listenable.dart';

typedef EventCallback<T> = void Function(T data);

class EventEmitter {
  final listeners = <EventListener>{};

  EventListener<T> on<T>(String type, [ EventCallback<T>? callback ]) {
    
  }
}

class Event<T> {
  final String type;
  final T data;

  Event(this.type, this.data);
}

class EventListener<T extends Event> {
  final String type;
  EventListener(this.type);

  void emit(T event) => onData(event.data);

  bool validate(Event event) => event is T && event.type == type;

  bool accept(Event event) {
    if (!validate(event)) return false;
    emit(event as T);
    return true;
  }

  /* -= Event Callbacks =- */

  final onAdd = Listenable<void Function(EventEmitter emitter)>();
  final onRemove = Listenable<void Function(EventEmitter emitter)>();
  final onData = Listenable<void Function(T data)>();
  final onCancel = Listenable<void Function()>();
}
