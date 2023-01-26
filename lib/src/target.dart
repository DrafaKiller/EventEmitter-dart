class Event<T> {
  final String type;
  final T data;

  const Event(this.type, this.data);
}

class EventTarget<T extends Event> {
  final String? type;
  
  const EventTarget(this.type);
  const EventTarget.any() : this(null);

  bool validate(T event) => type == null || event.type == type;

  bool accept(Event event) => event is T && validate(event);
}

class EventSubscription<T extends Event> {
  final EventEmitter emitter;
  final EventListener<T> listener;

  EventSubscription(this.emitter, this.listener);

  bool get cancelled => !emitter.listeners.contains(listener);

  void cancel() {
    if (cancelled) return;
    emitter.removeEventListener(listener);
  }
}

typedef EventListenerOnAdd = void Function(EventEmitter emitter);
typedef EventListenerOnRemove = void Function(EventEmitter emitter);
typedef EventListenerOnEvent<T extends Event> = void Function(T event);
typedef EventListenerOnData<T> = void Function(T data);
typedef EventListenerOnCancel = void Function();

class EventListener<T extends Event> {
  final EventTarget target;
  
  const EventListener(this.target);


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

  EventSubscription<T> onEvent<T extends Event>(EventCallback<T> callback) {
    final listener = EventListener<T>(EventTarget<T>.any());
    return EventSubscription(this, listener);
  }
}

typedef EventCallback<T extends Event> = void Function(T event);