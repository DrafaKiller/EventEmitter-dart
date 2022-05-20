part of events_emitter;

/// # Event Stream Emitter
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
  final StreamController<Event> _controller;

  EventStreamEmitter({ bool sync = true }) : _controller = StreamController<Event>.broadcast(sync: sync);

  /// Attach a listener to an emitter. Returns a stream that receives new events of any **type** and **topic**.
  /// 
  /// Can be filtered by **type**.
  Stream<Event<MessageType>> onAny<MessageType>() => _controller.stream
    .where((event) => event.message is MessageType)
    .cast<Event<MessageType>>();

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
  Stream<MessageType> on<MessageType>(String topic) => onAny<MessageType>()
    .where((event) => event.topic == topic)
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
  void emit<MessageType>(String topic, MessageType data) => _controller.add(Event<MessageType>(topic, data));

  /// Close the emitter. This will close all attached listeners.
  void close() => _controller.close();
}

/// # Event
/// A event is a message that was broadcasted to all listeners that with a type and topic.
class Event<MessageType> {
  final String topic;
  final MessageType message;

  const Event(this.topic, this.message);
}