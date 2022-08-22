// ignore_for_file: avoid_print

import 'package:events_emitter/events_emitter.dart';

void main() {
  final events = EventEmitter();

  events.on('message', (String data) => print('String: $data'));
  events.on('message', (int data) => print('Integer: $data'));
  
  events.emit('message', 'Hello World');
  events.emit('message', 42);

  // [Output]
  // String: Hello World
  // Integer: 42
}
