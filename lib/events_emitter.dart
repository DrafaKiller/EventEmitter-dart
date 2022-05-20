library events_emitter;

import 'dart:async';

part 'events_stream_emitter.dart';

/// # Event Emitter
/// A Event-based system, highly inspired by [NodeJS's EventEmitter](https://nodejs.org/api/events.html). This implementation uses generic types to allow for multiple data types, while still being intuitive.
/// 
/// Based on JavaScript and suitable for Dart and Flutter with type safety.
/// 
/// ## Features
/// 
/// * Attach multiple listeners to an event.
/// * Listen to a **topic** and **data type**. 
/// * Emit a message on a specific topic to be broadcasted to all listeners.
/// * Type safety
/// * Use callbacks with `EventEmitter`.
/// * Use streams with `EventStreamEmitter`.
/// * Can be extended to create custom event emitter objects.
/// 
/// ## Usage:
/// ```dart
/// EventEmitter events = EventEmitter();
/// 
/// events.on('message', (String data) => print('String: $data'));
/// events.on('message', (int data) => print('Integer: $data'));
/// 
/// events.emit('message', 'Hello World');
/// events.emit('message', 42);
/// 
/// // [Output]
/// // String: Hello World
/// // Integer: 42
/// ```

class EventEmitter {
  final EventStreamEmitter _streamEmitter;

  /// # EventEmitter
  /// ```dart
  /// EventEmitter events = EventEmitter();
  /// 
  /// events.on('message', (String data) => print('String: $data'));
  /// events.on('message', (int data) => print('Integer: $data'));
  /// 
  /// events.emit('message', 'Hello World');
  /// events.emit('message', 42);
  /// 
  /// // [Output]
  /// // String: Hello World
  /// // Integer: 42
  /// ```
  EventEmitter({ bool sync = true }) : _streamEmitter = EventStreamEmitter(sync: sync);

  /// List of event listeners.
  final listeners = <EventListener>[];

  /// Attach a listener to an emitter. Calls the [callback] whenever there's a new event of any **type** and **topic**.  
  /// 
  /// Can be filtered by **type**.
  StreamSubscription<Event<MessageType>> onAny<MessageType>(void Function(Event event) callback) =>
    _streamEmitter.onAny<MessageType>().listen(callback);
  
  /// Attach a listener to an emitter. Calls the [callback] whenever there's a new event of the specified **type** and **topic**.
  /// 
  /// If the emitted event doesn't match the specified type and topic, the callback will not be called. This method can be used with generalized types, such as `Object` and other super classes.
  /// 
  /// A [EventListener] is returned, which has all information about the listener and can be used to cancel the subscription.
  /// 
  /// ```
  /// EventEmitter events = EventEmitter();
  /// events.on('message', (String data) => print('String: $data'));
  /// ```
  EventListener<MessageType> on<MessageType> (String topic, void Function(MessageType data) callback) {
    final stream = _streamEmitter.on<MessageType>(topic);
    final listener = EventListener<MessageType>(topic, callback, stream);
    listener.subscription.onDone(() => listeners.remove(listener));
    listeners.add(listener);
    return listener;
  }

  /// Same as [on] but with a [callback] is only called once.
  Future<MessageType> once<MessageType> (String topic, void Function(MessageType data) callback) =>
    _streamEmitter.once<MessageType>(topic).then((value) {
      callback(value);
      return value;
    });

  /// Remove an attached listener, by [type], [topic] and [callback]. This can also be achieved by using the returned [StreamSubscription].
  void off<MessageType> ({ String? topic, void Function(MessageType data)? callback }) {
    listeners.removeWhere((listener) {
      if (
        (topic == null || listener.topic == topic) &&
        (callback == null || listener.callback == callback) && 
        listener.messageType == MessageType
      ) {
        listener.subscription.cancel();
        return true;
      }
      return false;
    });
  }
  
  /// Emit a message on a specific **type** and **topic**. This will broadcast the message to all listeners that match the same type and topic.
  /// 
  /// ```
  /// EventEmitter events = EventEmitter();
  /// events.on('message', (String data) => print('String: $data'));
  /// events.emit('message', 'Hello World');
  /// // [Output]
  /// // String: Hello World
  /// ```
  void emit<MessageType> (String topic, MessageType data) => _streamEmitter.emit<MessageType>(topic, data);

  /// Close the emitter. This will close all attached listeners.
  void close() => _streamEmitter.close();
}

/// # Event Listener
/// A listener is a subscription to a specific topic and type.
/// 
/// This includes all the objects used to attach a listener to an emitter.
class EventListener<MessageType> {
  final String topic;
  final Type messageType = MessageType;
  final Function(MessageType data) callback;
  final Stream<MessageType> stream;
  final StreamSubscription<MessageType> subscription;

  EventListener(this.topic, this.callback, this.stream) : subscription = stream.listen(callback);
  EventListener.fromSubscription(this.topic, this.callback, this.stream, this.subscription);

  Future<void> cancel() => subscription.cancel();
}