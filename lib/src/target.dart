import 'package:events_emitter/listenable.dart';

class Event<T> {
  final String type;
  final T data;

  const Event(this.type, this.data);
}

class EventTarget<T extends Event> {
  final String? type;

  const EventTarget(this.type);
  const EventTarget.any() : this(null);
}

class EventSubscription {
  final EventListenerOnCancel _onCancel;
  EventSubscription(this._onCancel);

  bool _cancelled = false;
  bool get cancelled => _cancelled;

  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _onCancel();
  }
}

typedef EventListenerOnAdd = void Function(EventEmitter emitter);
typedef EventListenerOnRemove = void Function(EventEmitter emitter);
typedef EventListenerOnEvent<T extends Event> = void Function(T event);
typedef EventListenerOnData<T> = void Function(T data);
typedef EventListenerOnCancel = void Function();

class EventListener<T extends Event> {
  
}



class EventEmitter {
  final listeners = <EventListener>{};

  bool addEventListener(EventListener listener) {
    if (!listeners.add(listener)) return false;
    return true;
  }

  bool removeEventListener(EventListener listener) {
    if (!listeners.remove(listener)) return false;
    return true;
  }

  /* -= Event Methods =- */

}