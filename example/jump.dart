import 'package:events_emitter/events_emitter.dart';

void main() {
  final events = EventEmitter();
  final listener = events.on('jump', (double height) => print('Jumped $height meters!'));
  events.onEvent((Jump jump) => print('[Event] Jumped ${ jump.height } meters!'));
  

  events.emitEvent(Jump('John', 1.5));
}

class Jump extends Event<double> {
  final String name;
  final double height;
  
  Jump(this.name, this.height) : super('jump', height);
}