library events_emitter;

import 'dart:async';

/// # Event Emitter
/// A Event-based system, highly inspired by [NodeJS's EventEmitter](https://nodejs.org/api/events.html). This implementation uses generic types to allow for multiple data types, while still being intuitive.
/// 
/// * Attach multiple listeners to an event.
/// * Listen to a **topic** and **data type**. 
/// * Emit a message on a specific topic to be broadcasted to all listeners.
/// * Use callbacks with `EventEmitter`.
/// * Use streams with `EventStreamEmitter`.
/// * Can be extented to create custom event emitter objects.
/// 
/// ### Usage:
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
  final EventStreamEmitter _eventStreamEmitter;

  EventEmitter({ bool sync = true }) : _eventStreamEmitter = EventStreamEmitter(sync: sync);

  /// List of event listeners.
  final listeners = <EventListener>[];

  /// Attach a listener to an emitter. Calls the [callback] whenever there's a new event of any **type** and **topic**.  
  StreamSubscription<Event> onAny(void Function(Event event) callback) => _eventStreamEmitter.onAny().listen(callback);
  
  /// Attach a listener to an emitter. Calls the [callback] whenever there's a new event of the specified **type** and **topic**.
  /// 
  /// If the emitted event doesn't match the specified type and topic, the callback will not be called. This method can be used with generalized types, such as `Object` and other super classes.
  /// 
  /// A [StreamSubscription] is returned, which can be used to cancel the subscription.
  /// 
  /// ```
  /// EventEmitter events = EventEmitter();
  /// events.on('message', (String data) => print('String: $data'));
  /// ```
  StreamSubscription<Message> on<Message> (String topic, void Function(Message data) callback) {
    final stream = _eventStreamEmitter.on<Message>(topic);
    final subscription = stream.listen(callback);
    final listener = EventListener(topic, Message, callback, stream, subscription);
    subscription.onDone(() => listeners.remove(listener));
    listeners.add(listener);
    return subscription;
  }

  /// Same as [on] but with a [callback] is only called once.
  void once<Message> (String topic, void Function(Message data) callback) => _eventStreamEmitter.once<Message>(topic).then(callback);

  /// Remove an attached listener, by [type], [topic] and [callback]. This can also be achieved by using the returned [StreamSubscription].
  void off<Message> ({ String? topic, void Function(Message data)? callback }) {
    listeners.removeWhere((listener) {
      if (
        (topic == null || listener.topic == topic) &&
        (callback == null || listener.callback == callback) && 
        listener.messageType == Message
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
  void emit<Message> (String topic, Message data) => _eventStreamEmitter.emit<Message>(topic, data);
  
  /// Same as [emit] but with an empty [topic].
  void send<Message> (Message data) => _eventStreamEmitter.send<Message>(data);

  /// Close the emitter. This will close all attached listeners.
  void close() => _eventStreamEmitter.close();
}



/// # Event Stream Emitter
/// A Event-based system, highly inspired by [NodeJS's EventEmitter](https://nodejs.org/api/events.html). This implementation uses generic types to allow for multiple data types, while still being intuitive.
/// 
/// * Attach multiple listeners to an event.
/// * Listen to a **topic** and **data type**. 
/// * Emit a message on a specific topic to be broadcasted to all listeners.
/// * Use callbacks with `EventEmitter`.
/// * Use streams with `EventStreamEmitter`.
/// * Can be extented to create custom event emitter objects.
/// 
/// ### Usage:
/// ```dart
/// EventStreamEmitter events = EventStreamEmitter();
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

class EventStreamEmitter {
  final StreamController<Event> _eventEmitterController;

  EventStreamEmitter({ bool sync = true }) : _eventEmitterController = StreamController<Event>.broadcast(sync: sync);

  /// Attach a listener to an emitter. Returns a stream that receives new events of any **type** and **topic**.
  Stream<Event> onAny() => _eventEmitterController.stream;

  /// Attach a listener to an emitter. Returns a stream that receives new events of the specified **type** and **topic**.
  /// 
  /// If the emitted event doesn't match the specified type and topic, the streams will not receive it. This method can be used with generalized types, such as `Object` and other super classes.
  /// 
  /// This can be canceled using the [StreamSubscription] from the `.listen( ... )`.
  /// 
  /// ```
  /// EventStreamEmitter events = EventStreamEmitter();
  /// events.on<String>('message').listen((String data) => print('String: $data'));
  /// ```
  Stream<Message> on<Message>(String topic) => onAny()
    .where((event) => event.topic == topic && event.message is Message)
    .map((event) => event.message);

  /// Same as [on] but with a [callback] is only called once.  
  Future<Message> once<Message>(String topic) => on<Message>(topic).first;
  
  /// Emit a message on a specific **type** and **topic**. This will broadcast the message to all listeners that match the same type and topic.
  /// 
  /// ```
  /// EventStreamEmitter events = EventStreamEmitter();
  /// events.on<String>('message').listen((String data) => print('String: $data'));
  /// events.emit('message', 'Hello World');
  /// // [Output]
  /// // String: Hello World
  /// ```
  void emit<Message>(String topic, Message data) => _eventEmitterController.add(Event(topic, data));

  /// Same as [emit] but with an empty [topic].
  void send<Message>(Message data) => emit('', data);

  /// Close the emitter. This will close all attached listeners.
  void close() => _eventEmitterController.close();
}

/// # Event
/// A event is a message that was broadcasted to all listeners that with a type and topic.
class Event<Message> {
  final String topic;
  final Message message;

  const Event(this.topic, this.message);
}

/// # Event Listener
/// A listener is a subscription to a specific topic and type.
/// 
/// This includes all the objects used to attach a listener to an emitter.
class EventListener {
  final String topic;
  final Type messageType;
  final Function callback;
  final Stream stream;
  final StreamSubscription subscription;

  const EventListener(this.topic, this.messageType, this.callback, this.stream, this.subscription);
}