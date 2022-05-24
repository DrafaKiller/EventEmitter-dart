library events_emitter;

import 'dart:async';

import 'package:rxdart/rxdart.dart';

part 'events_stream_emitter.dart';

/// # Event Emitter
/// An Event-based system, highly inspired by [NodeJS's Event Emitter](https://nodejs.org/api/events.html). This implementation uses generic types to allow for multiple data types, while still being intuitive.
/// 
/// Based on JavaScript and suitable for Dart and Flutter with type safety.
/// 
/// ## Features
/// 
/// * Attach multiple listeners to an event.
/// * Listen to a **topic** and **data type**.
/// * Emit a message on a specific topic to be broadcasted to all listeners.
/// * Type safety.
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
  EventEmitter({ bool sync = true }) : _streamEmitter = EventStreamEmitter(sync: sync) {
    _streamEmitter._controller.onCancel = () => listeners.removeWhere((listener) => listener.canceled);
  }

  /// List of event listeners.
  final listeners = <EventListener>[];

  /// Attach a listener to an emitter. Calls the [callback] whenever there's a new event of any **type** and **topic**.  
  /// 
  /// Can be filtered by **type**.
  EventListener<Event<MessageType>> onAny<MessageType>(void Function(Event<MessageType> event) callback) =>
    _createListener(null, callback, _streamEmitter.onAny<MessageType>());
  
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
  EventListener<MessageType> on<MessageType> (String topic, void Function(MessageType data) callback) =>
    _createListener(topic, callback, _streamEmitter.on<MessageType>(topic));

  /// Same as [on] but with a [callback] is only called once.
  Future<MessageType> once<MessageType> (String topic, void Function(MessageType data) callback) =>
    _streamEmitter.once<MessageType>(topic).then((value) {
      callback(value);
      return value;
    });

  /// Remove an attached listener, by [type], [topic] and [callback]. This can also be achieved by using the returned [StreamSubscription].
  Future<void> off<MessageType> ({ String? topic, void Function(MessageType data)? callback }) async {
    final removing = <Future>[];
    for (final listener in List<EventListener>.from(listeners)) {
      if (
        (topic == null || listener.topic == topic) &&
        (callback == null || listener.callback == callback) && 
        (
          listener is EventListener<MessageType> || 
          listener is EventListener<Event<MessageType>>
        )
      ) {
        removing.add(listener.cancel());
      }
    }
    await Future.wait(removing);
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

  /// Emit an event on a specific **type** and **topic**. This will broadcast the message to all listeners that match the same type and topic.
  void emitEvent<MessageType>(Event<MessageType> event) => _streamEmitter.emitEvent<MessageType>(event);

  /// Close the emitter. This will close all attached listeners.
  void close() {
    for (final listener in listeners) {
      listener.canceled = true;
    }
    _streamEmitter.close();
  }

  EventListener<MessageType> _createListener<MessageType>(String? topic, void Function(MessageType data) callback, Stream<MessageType> stream) {
    final listener = EventListener<MessageType>(topic, callback, stream);
    listener.onCancel = _removeListener;
    listeners.add(listener);
    return listener;
  }

  void _removeListener(EventListener listener) => listeners.remove(listener);
}

/// # Event Listener
/// A listener is a subscription to a specific topic and type.
/// 
/// This includes all the objects used to attach a listener to an emitter.
class EventListener<MessageType> {
  String? topic;
  Type messageType = MessageType;
  void Function(MessageType data) callback;
  final Stream<MessageType> stream;
  final StreamSubscription<MessageType> subscription;
  bool canceled = false;

  void Function(EventListener)? onCancel;

  EventListener(this.topic, this.callback, this.stream) : subscription = stream.listen(callback);
  EventListener.fromSubscription(this.topic, this.callback, this.stream, this.subscription);

  Future<void> cancel() async {
    canceled = true;
    onCancel?.call(this);
    await subscription.cancel();
  }
}