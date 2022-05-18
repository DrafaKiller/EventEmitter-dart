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
  /// A [EventListener] is returned, which has all information about the listener and can be used to cancel the subscription.
  /// 
  /// ```
  /// EventEmitter events = EventEmitter();
  /// events.on('message', (String data) => print('String: $data'));
  /// ```
  EventListener on<MessageType> (String topic, void Function(MessageType data) callback) {
    final stream = _eventStreamEmitter.on<MessageType>(topic);
    final listener = EventListener<MessageType>(topic, callback, stream);
    listener.subscription.onDone(() => listeners.remove(listener));
    listeners.add(listener);
    return listener;
  }

  /// Same as [on] but with a [callback] is only called once.
  void once<MessageType> (String topic, void Function(MessageType data) callback) => _eventStreamEmitter.once<MessageType>(topic).then(callback);

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
  void emit<MessageType> (String topic, MessageType data) => _eventStreamEmitter.emit<MessageType>(topic, data);
  
  /// Same as [emit] but with an empty [topic].
  void send<MessageType> (MessageType data) => _eventStreamEmitter.send<MessageType>(data);

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
  Stream<MessageType> on<MessageType>(String topic) => onAny()
    .where((event) => event.topic == topic && event.message is MessageType)
    .map((event) => event.message);

  /// Same as [on] but with a [callback] is only called once.  
  Future<MessageType> once<MessageType>(String topic) => on<MessageType>(topic).first;
  
  /// Emit a message on a specific **type** and **topic**. This will broadcast the message to all listeners that match the same type and topic.
  /// 
  /// ```
  /// EventStreamEmitter events = EventStreamEmitter();
  /// events.on<String>('message').listen((String data) => print('String: $data'));
  /// events.emit('message', 'Hello World');
  /// // [Output]
  /// // String: Hello World
  /// ```
  void emit<MessageType>(String topic, MessageType data) => _eventEmitterController.add(Event(topic, data));

  /// Same as [emit] but with an empty [topic].
  void send<MessageType>(MessageType data) => emit('', data);

  /// Close the emitter. This will close all attached listeners.
  void close() => _eventEmitterController.close();
}

/// # Event
/// A event is a message that was broadcasted to all listeners that with a type and topic.
class Event<MessageType> {
  final String topic;
  final MessageType message;

  const Event(this.topic, this.message);
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

  void cancel() => subscription.cancel();
}