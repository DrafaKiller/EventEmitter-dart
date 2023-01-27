import 'dart:async';

class EventEmitter {
  final listeners = <EventListener>{};

  final EventController controller;

  EventEmitter({ EventController? dispatcher }) : controller = dispatcher ?? EventController.broadcast();

  /* -=  =- */

  EventDispatcher get dispatcher => controller.sink;
  EventStream get stream => controller.stream;
  EventFuture get future => controller.stream.first;

  /* -=  =- */

  bool addEventListener(EventListener listener) {

  }

  bool removeEventListener(EventListener listener) {

  }

  void emit<T>(String type, [ T? data ]) => dispatch(Event(type, data));
  void dispatch(Event event) => dispatcher.add(event);

  EventSubscription<Event<T>> on<T>(String type, [ EventDataCallback<T>? callback ]) => onDispatch(type, callback != null ? (Event<T> event) => callback.call(event.data) : null);
  EventSubscription<Event<T>> once<T>(String type, [ EventDataCallback<T>? callback ]) {}
  EventSubscription<T> onDispatch<T extends Event>(String type, [ EventCallback<T>? callback ]) {}
}

class ControllableEventEmitter extends EventEmitter {
  final EventController controller;

  EventEmitter({ EventController? dispatcher }) : controller = dispatcher ?? EventController.broadcast();

}

class Event<T> {
  final String type;
  final T data;
  
  const Event(this.type, this.data);
}

class EventTarget<T extends Event> {
  final String? type;

  const EventTarget([ this.type ]);

  bool validate(T event) => type == null || event.type == type;
  bool accept(Event event) => event is T && validate(event);
}

class EventListener {
  final EventTarget target;

  const EventListener(this.target);
}

class EventSubscription {

}

typedef EventCallback<T extends Event> = void Function(T event);
typedef EventDataCallback<T> = void Function(T data);

typedef EventController<T extends Event> = StreamController<T>;
typedef EventDispatcher<T extends Event> = StreamSink<T>;
typedef EventStream<T extends Event> = Stream<T>;
typedef EventFuture<T extends Event> = Future<T>;

void main() {
  final emitter = EventEmitter();
  final subscription = emitter.on('test', (String data) => print(data));
  emitter.emit('test', 'Hello World!');
  subscription.cancel();
  emitter.emit('test', 'Hello World!');
}