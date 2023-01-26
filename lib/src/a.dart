import 'dart:async';

class EventEmitter extends Stream<Event> {
  final listeners = <EventListener>{};

  bool addEventListener(EventListener listener) => listeners.add(listener);
  bool removeEventListener(EventListener listener) => listeners.remove(listener);

  bool emit(Event event) {
    var consumed = false;
    listeners.forEach((listener) => consumed = listener.accept(event) || consumed);
    return consumed;
  }

  EventSubscription<T> onEvent<T extends Event>(EventCallback<T> callback) {
    final listener = EventListener<T>(EventTarget.any(), callback);
    addEventListener(listener);
    return EventSubscription(this, listener);
  }

  @override
  EventSubscription listen(EventCallback? onData, { Function? onError, void Function()? onDone, bool? cancelOnError }) {
    final listener = EventListener(EventTarget.any(), onData!);
    addEventListener(listener);
    return EventSubscription(this, listener);
  }
}

class EventListener<T extends Event> {
  final EventTarget<T> target;
  final EventCallback<T> callback;
  
  const EventListener(this.target, this.callback);

  bool accept(Event event) {
    if (!target.accept(event)) return false;
    execute(event as T);
    return true;
  }

  void execute(T event) => callback(event);
}

class EventSubscription<T extends Event> extends StreamSubscription<T> {
  final EventEmitter emitter;
  final EventListener<T> listener;
  
  EventSubscription(this.emitter, this.listener);

  @override
  Future<E> asFuture<E>([ E? futureValue ]) {
    // TODO: implement asFuture
    throw UnimplementedError();
  }

  bool get cancelled => !emitter.listeners.contains(listener);

  @override
  Future<void> cancel() async {
    if (cancelled) return;
    emitter.removeEventListener(listener);
  }

  @override bool get isPaused => false;
  @override void pause([Future<void>? resumeSignal]) {}
  @override void resume() {}

  @override void onData(EventCallback<T>? handleData) => throw UnimplementedError();
  @override void onDone(void Function()? handleDone) => throw UnimplementedError();
  @override void onError(Function? handleError) => throw UnimplementedError();
}

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

typedef EventCallback<T extends Event> = void Function(T event);
