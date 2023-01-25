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

class EventSubscription<T extends Event> {
  final Function() _onCancel;
  EventSubscription(this._onCancel);

  bool _cancelled = false;
  bool get cancelled => _cancelled;

  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _onCancel();
  }
}

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