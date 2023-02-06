part of 'emitter.dart';

/* -= Event Components =- */

typedef EventController<T extends Event> = StreamController<T>;
typedef EventDispatcher<T extends Event> = StreamSink<T>;
typedef EventStream<T extends Event> = Stream<T>;
typedef EventFuture<T extends Event> = Future<T>;

/* -= Listener Callbacks =- */

typedef EventDispatchCallback<T extends Event> = void Function(T event);
typedef EventCallback<T> = void Function(T data);