import 'package:event_emitter/event_emitter.dart';

void main() {
  final emitter = EventEmitter();
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