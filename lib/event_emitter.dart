library event_emitter;

import 'dart:async';

class EventEmitter {
  final _eventStreamEmitter = EventStreamEmitter();
  final listeners = <EventListener>[];
  
  StreamSubscription<Event> onAny(void Function(Event event) callback) => _eventStreamEmitter.onAny().listen(callback);
  
  StreamSubscription<Message> on<Message> (String topic, void Function(Message data) callback) {
    final stream = _eventStreamEmitter.on<Message>(topic);
    final subscription = stream.listen(callback);
    listeners.add(EventListener(topic, Message, callback, stream, subscription));
    return subscription;
  }
  
  void once<Message> (String topic, void Function(Message data) callback) => _eventStreamEmitter.once<Message>(topic).then(callback);

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
  
  void emit<Message> (String topic, Message data) => _eventStreamEmitter.emit<Message>(topic, data);
  
  void send<Message> (Message data) => _eventStreamEmitter.send<Message>(data);

  void close() => _eventStreamEmitter.close();
}

class EventStreamEmitter {
  final _eventEmitterController = StreamController<Event>.broadcast(sync: true);

  Stream<Event> onAny() => _eventEmitterController.stream;

  Stream<Message> on<Message>(String topic) => onAny()
    .where((event) => event.topic == topic && event.message is Message)
    .map((event) => event.message);

  Future<Message> once<Message>(String topic) => on<Message>(topic).first;

  void emit<Message>(String topic, Message data) => _eventEmitterController.add(Event(topic, data));

  void send<Message>(Message data) => emit('', data);

  void close() => _eventEmitterController.close();
}

class Event<Message> {
  final String topic;
  final Message message;

  const Event(this.topic, this.message);
}

class EventListener {
  final String topic;
  final Type messageType;
  final Function callback;
  final Stream stream;
  final StreamSubscription subscription;

  const EventListener(this.topic, this.messageType, this.callback, this.stream, this.subscription);
}