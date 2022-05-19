import 'package:events_emitter/events_emitter.dart';

class Person extends EventEmitter {
  String name;

  Person(this.name);

  void say(String message) => emit('say', message);
  void eat(String food) => emit('eat', food);
  void jump(double height) => emit('jump', height);
}

void main() {
  final person = Person('John');
  
  person.on('say', (String message) => print('${person.name} said: $message'));
  person.on('eat', (String food) => print('${person.name} ate $food'));
  person.on('jump', (double height) => print('${person.name} jumped $height meters'));

  person.say('I\'m a human!');
  person.eat('apple');
  person.jump(0.5);

  // [Output]
  // John said: I'm a human!
  // John ate apple
  // John jumped 0.5 meters
}