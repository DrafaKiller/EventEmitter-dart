import 'dart:async';

import 'package:events_emitter/event.dart';
import 'package:rxdart/rxdart.dart';

/// # Event Stream Emitter
/// An Event-based system, highly inspired by [NodeJS's Event Emitter](https://nodejs.org/api/events.html). This implementation uses generic types to allow for multiple data types while being very intuitive.
/// 
/// Based on JavaScript and suitable for Dart and Flutter with type safety.
/// 
/// ## Features
/// 
/// * Attach multiple listeners to an event emitter.
/// * Listen to events with a specific **event type** and **data type**.
/// * Emit an event of a specific type to be broadcasted to all listeners.
/// * Type safety, only the right type will be passed in.
/// * Use callbacks with `EventEmitter`.
/// * Use streams with `StreamEventEmitter`.
/// * Can be extended to create custom event emitters and events.
/// * Custom events can hold custom data to be used in the listeners.
/// 
/// ## Usage:
/// ```dart
/// StreamEventEmitter events = StreamEventEmitter();
/// 
/// events.on<String>('message').listen((String data) => print('String: $data'));
/// events.on<int>('message').listen((int data) => print('Integer: $data'));
/// 
/// events.emit('message', 'Hello World');
/// events.emit('message', 42);
/// 
/// // [Output]
/// // String: Hello World
/// // Integer: 42
/// ``` 
class StreamEventEmitter {
  final StreamController<Event> controller;
  StreamEventEmitter({ bool sync = true }) : controller = StreamController<Event>.broadcast(sync: sync);

  /// Emit a message on a specific **event type** and **data type**.
  /// This will broadcast the event to all listeners that match the same **event type** and **data type**.
  /// 
  /// ```dart
  ///   final emitter = EventEmitter();
  ///     ...
  ///   events.emitEvent(Event('message', 'Hello World'));
  /// ```
  /// 
  /// A custom event can be emitted by extending the [Event] class.
  /// This allows for custom data to be passed to the listeners,
  ///   it's expected to have the same effect as a normal event.
  void emitEvent<T>(Event<T> event) => controller.add(event);

  /// Attach a listener to an emitter. Calls the [callback] whenever there's a new event of the specified **type** and **data type**.
  /// 
  /// This method can be used with generalized types, such as `Object`/`dynamic` and other super classes.
  /// 
  /// It can be canceled using the [StreamSubscription] from the `.listen( ... )`.
  /// 
  /// ```
  ///   StreamEventEmitter events = StreamEventEmitter();
  ///     ...
  ///   final subscription = events.on<Event<String>>('message').listen((Event<String> event) => print('String: ${event.type} ${event.data}'));
  ///     ...
  ///   subscription.cancel();
  /// ```
  /// 
  /// This method can also be used to catch custom events, which extend the `Event` class.
  Stream<T> onEvent<T extends Event>([ String? type ]) {
    var stream = controller.stream;
    if (type != null) stream = stream.where((event) => event.type == type);
    return stream.whereType<T>();
  }

  /// Same as [onEvent] but only running once, by returning a Future.
  Future<T> onceEvent<T extends Event>([ String? type ])=> onEvent<T>(type).first;

  /* -= Simpler Alternative =- */

  /// Emit a event with a specific **event type** and **data type**.
  /// This will broadcast the message to all listeners that match the same **event type** and **data type**.
  /// 
  /// ```
  ///   StreamEventEmitter events = StreamEventEmitter();
  ///     ...
  ///   events.emit('message', 'Hello World');
  /// ```
  /// 
  /// Same as [emitEvent], but with a simpler syntax.
  void emit<T>(String type, T data) => emitEvent(Event<T>(type, data));

  /// Attach a listener to the event emitter.
  /// Calls the [callback] whenever there's a new event of the specified **type** and **data type**.
  /// 
  /// This method can be used with generalized types, such as `Object`/`dynamic` and other super classes.
  /// 
  /// It can be canceled using the [StreamSubscription] from the `.listen( ... )`.
  /// 
  /// ```dart
  ///   StreamEventEmitter events = StreamEventEmitter();
  ///    ...
  ///   events.on<String>('message').listen((String data) => print('String: $data'));
  /// ```
  Stream<T> on<T>([ String? type ]) => onEvent<Event<T>>(type).map((event) => event.data);

  /// Same as [on] but only running once, by returning a Future.
  Future<T> once<T>([ String? type ]) => on<T>(type).first;

  @Deprecated('Use [on] instead')
  Stream<Event<MessageType>> onAny<MessageType>() => onEvent<Event<MessageType>>();

  /// Closes the event emitter, which closes all the listeners in the process.
  void close() => controller.close();
}