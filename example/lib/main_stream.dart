import 'package:event_emitter/event_emitter.dart';

void main() {
  EventStreamEmitter events = EventStreamEmitter();
  
  events.on<String>('message').listen((String data) => print('String: $data'));
  events.on<int>('message').listen((int data) => print('Integer: $data'));
  
  events.emit('message', 'Hello World');
  events.emit('message', 42);
  
  // [Output]
  // String: Hello World
  // Integer: 42
}