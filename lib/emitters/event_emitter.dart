import 'dart:async';

import 'package:events_emitter/event.dart';
import 'package:events_emitter/listener.dart';

/// # Event Emitter
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
  /// List of all listeners active in the emitter.
  /// 
  /// This list is used to match **event types** and **data types** when an event is emitted.
  final Set<EventListener> listeners = {};

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
  EventEmitter();

  /// Adds a listener to the emitter.
  /// When an event is emitted, the listeners added will be matched.
  /// 
  /// This methods calls the `onAdd` method of the listener.
  bool addEventListener(EventListener listener) {
    final previousOnCancel = listener.onCancel;
    listener.onCancel = (listener) {
      previousOnCancel?.call(listener);
      removeEventListener(listener);
    };
    listener.onAdd?.call(this, listener);
    return listeners.add(listener);
  }
  
  /// Removes a listener from the emitter.
  /// 
  /// This methods calls the `onRemove` method of the listener.
  bool removeEventListener(EventListener listener) {
    final removed = listeners.remove(listener);
    listener.onRemove?.call(this, listener);
    return removed;
  }

  /// Emits an event to all listeners.
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
  /// it's expected to have the same effect as a normal event.
  bool emitEvent<T extends Event>(T event) {
    bool allSatisfied = true;
    for (final listener in listeners.toList()) {
      final satisfied = listener.call<T>(event);
      if (!satisfied) allSatisfied = false;
    }
    return allSatisfied;
  }

  /* -= Simpler Alternative =- */
  
  /// Emit a event with a specific **event type** and **data type**.
  /// This will broadcast the message to all listeners that match the same **event type** and **data type**.
  /// 
  /// ```dart
  ///   EventEmitter events = EventEmitter();
  ///     ...
  ///   events.emit('message', 'Hello World');
  /// ```
  /// 
  /// Same as [emitEvent], but with a simpler syntax.
  void emit<T>(String type, T data) => emitEvent(Event<T>(type, data));

  /// Attach a listener to an emitter.
  /// Calls the [callback] whenever there's a new event of the specified **event type** and **data type**.
  /// 
  /// If the emitted event doesn't match the specified type and data type, the callback will not be called.
  /// This method can be used with generalized types, such as `Object`/`dynamic` and other super classes.
  /// 
  /// A [EventListener] is returned, which has all information about the listener and can be used to cancel the subscription.
  /// 
  /// ```dart
  ///   EventEmitter events = EventEmitter();
  ///     ...
  ///   events.on('message', (String data) => print('String: $data'));
  ///   events.on('message', (Event<String> event) => print('String event: ${event.data}'));
  /// 
  ///   // [Output]
  ///   // String: Hello World
  ///   // String event: Hello World
  /// ```
  /// 
  /// When using the callback, it's possible to handle the event data, as well as the event itself.
  /// Do this by using the types `Event<T>` and `T` in the callback.
  EventListener<T> on<T>(String? type, EventCallback<T> callback) {
    final listener = EventListener<T>(type, callback);
    addEventListener(listener);
    return listener; 
  }

  /// Same as [on] but with a callback that is only called once.
  /// 
  /// ```dart
  ///   EventEmitter events = EventEmitter();
  ///     ...
  ///   events.once('message', (String data) => print('String: $data'));
  /// ```
  /// 
  /// Can be used asynchronously, such as:
  /// ```dart
  ///   EventEmitter events = EventEmitter();
  ///   final dynamicValue = await events.once('message');
  ///   final stringValue = await events.once<String>('message');
  /// ```
  Future<T> once<T>(String? type, [ EventCallback<T>? callback ]) {
    final completer = Completer<T>();
    final listener = EventListener<T>(
      type, (data) {
        callback?.call(data);
        completer.complete(data);
      },
      once: true,
    );
    addEventListener(listener);
    return completer.future;
  }

  /// Same as [on] but without a type.
  EventListener<T> onAny<T>(EventCallback<T> callback) => on(null, callback);

  /// Remove an attached listener, by **event type**, **data type** and **callback**...
  bool off<T>({ String? type, EventCallback<T>? callback }) {
    bool removed = false;
    final toRemove = <EventListener>[];
    for (final listener in listeners) {
      if (listener.protected) continue;
      if (listener.matches(type, callback)) {
        toRemove.add(listener);
        removed = true;
      }
    }
    for (final listener in toRemove) {
      removeEventListener(listener);
    }
    return removed;
  }
}
