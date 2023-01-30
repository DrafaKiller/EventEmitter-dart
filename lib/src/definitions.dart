part of 'emitter.dart';

/* -= Event Components =- */

typedef EventController<T extends Event> = StreamController<T>;
typedef EventDispatcher<T extends Event> = StreamSink<T>;
typedef EventStream<T extends Event> = Stream<T>;
typedef EventFuture<T extends Event> = Future<T>;

/* -= Listener Callbacks =- */

typedef EventListenerOnAdd = void Function(EventEmitter emitter);
typedef EventListenerOnRemove = void Function(EventEmitter emitter);
typedef EventListenerOnEvent<T extends Event> = void Function(T event);
typedef EventListenerOnData<T> = void Function(T data);
typedef EventListenerOnCancel = void Function();
typedef EventSubscriptionOnCancel = void Function();