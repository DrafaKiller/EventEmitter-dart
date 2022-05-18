# Event Emitter
A Event-based system, highly inspired by [NodeJS's EventEmitter](https://nodejs.org/api/events.html). This implementation uses generic types to allow for multiple data types, while still being intuitive.

Based on JavaScript and suitable for Dart and Flutter.

## Features

* Attach multiple listeners to an event.
* Listen to a **topic** and **data type**. 
* Emit a message on a specific topic to be broadcasted to all listeners.
* Use callbacks with `EventEmitter`.
* Use streams with `EventStreamEmitter`.
* Can be extented to create custom event emitter objects.

## Getting started

Install it using pub:
```
flutter pub add events_emitter
```

And import the package:
```dart
import 'package:events_emitter/events_emitter.dart';
```

## Usage

```dart
EventEmitter events = EventEmitter();

events.on('message', (String data) => print('String: $data'));
events.on('message', (int data) => print('Integer: $data'));

events.emit('message', 'Hello World');
events.emit('message', 42);

// [Output]
// String: Hello World
// Integer: 42
``` 

To remove a specific listener, you can use the subscription to stop it.
```dart
final subscription = events.on('message', ... ));
subscription.cancel();
```

Remove listeners, by targeting a **type**, **topic** and **callback**.
```dart
// Remove all listeners
events.off();

// Remove listeners of type `String`
events.off<String>();

// Remove listeners on topic `message`
events.off(topic: 'message');

// Combine methods above
events.off<String>(topic: 'message');
```

## GitHub

The package code is available on Github: [Dart - EventEmitter](https://github.com/DrafaKiller/EventEmitter-dart)

## Example

The `EventEmitter` class can be used by itself or can be extend to create a custom event emitter.

```dart
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

```
More examples:
* [EventEmitter](https://github.com/DrafaKiller/EventEmitter-dart/blob/main/example/lib/main.dart)
* [EventStreamEmitter](https://github.com/DrafaKiller/EventEmitter-dart/blob/main/example/lib/main_stream.dart)
* [Sync](https://github.com/DrafaKiller/EventEmitter-dart/blob/main/example/lib/sync_example.dart)
* [Extendable](https://github.com/DrafaKiller/EventEmitter-dart/blob/main/example/lib/extendable.dart)