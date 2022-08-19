// ignore_for_file: avoid_print

import 'package:events_emitter/emitters/stream_event_emitter.dart';

void main() {
  final events = StreamEventEmitter();

  events.on<String>('message').listen((String data) => print('String: $data'));
  events.on<int>('message').listen((int data) => print('Integer: $data'));
  
  events.emit('message', 'Hello World');
  events.emit('message', 42);
  
  // [Output]
  // String: Hello World
  // Integer: 42
}
