import 'package:events_emitter/events_emitter.dart';

void main() {
  // Turning the [sync] true or false has different effects on the emitted events.
  final emitter = EventEmitter(sync: true);

  emitter.on('message', (String message) => print('String: $message'));
  emitter.on('message', (int message) => print('Number: $message'));

  Future.delayed(const Duration(seconds: 1), () async {
    emitter.emit('message', 'Hello');
    emitter.emit('message', 1);

    await Future.delayed(const Duration(seconds: 1));

    emitter.emit('message', 'World');
    emitter.off<String>(topic: 'message');
    emitter.emit('message', 'Not showing this message');
    emitter.emit('message', 2);
  });
}
