import 'package:events_emitter/events_emitter.dart';

void main() {
  final events = EventEmitter();
  final subscription = events.on('jump', (double height) => print('Jumped $height meters!'));
  subscription.listener.
}