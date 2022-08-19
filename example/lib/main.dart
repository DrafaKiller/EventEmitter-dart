// ignore_for_file: avoid_print

import 'package:events_emitter/events_emitter.dart';
import 'package:events_emitter/listeners/stream.dart';

void main() {
  final events = EventEmitter();

  events.on('message', (String data) => print('String: $data'));
  events.on('message', (int data) => print('Integer: $data'));

  events.emit('message', 'Hello World');
  events.emit('message', 42);

  final listener2 = EventListener<String>('type', (data) {});
  listener2.appendCallback(
    onAdd: (emitter, listener) => print('Added'),
    onRemove: (emitter) => print('Removed'),
    onCall: (listener, data) => print('Called'),
  );
  events.addEventListener(listener2);

  events.off();

  print(events.listeners.length);

  return;

  final listener = StreamEventListener<String>('message');
  events.addEventListener(listener);

  listener.stream.listen((data) => print('Stream: $data'));

  events.emit('message', 'Hello World');
  Future.delayed(const Duration(seconds: 1), () => events.emit('message', 'Hello World 2'));
  Future.delayed(const Duration(seconds: 2), () => events.emit('message', 'Hello World 3'));


  // [Output]
  // String: Hello World
  // Integer: 42
}
