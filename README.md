# Event Emitter
A Event-based system, highly inspired by [NodeJS's EventEmitter](https://nodejs.org/api/events.html). This implementation uses generic types to allow for multiple data types, while still being intuitive.

## Features

* Attach multiple listeners to an event.
* Listen to a **topic** and **data type**. 
* Emit a message on a specific topic to be broadcasted to all listeners.
* Use callbacks with `EventEmitter`.
* Use streams with `EventStreamEmitter`.
* Can be extented to create custom event emitters objects.

## Getting started

Install it using pub:
```
flutter pub add event_emitter
```

And import the package:
```dart
import 'package:event_emitter/event_emitter.dart';
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

To remove a specific listener, you can store and use the subscription to stop it.
```dart
final subscription = events.on('message', ... ));
subscription.cancel();
```

Remove listeners, targeting by **type**, **topic** and **callback**.
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

## Example

The `EventEmitter` class can be used by itself or can be extend to create a custom event emitter.

```dart
import 'package:event_emitter/event_emitter.dart';

class Person extends EventEmitter {
    String name;

    Person(this.name, this.age);

    void eat(String food) => emit('eat', food);
    void jump(double height) => emit('jump', height);
}

final person = Person('John');
person.on('eat', (String food) => print('${person.name} ate $food'));
person.on('jump', (double height) => print('${person.name} jumped $height meters'));

person.eat('apple');
person.jump(0.5);

// [Output]
// John ate apple
// John jumped 0.5 meters
```

## GitHub

The package code is available on Github: [Dart - EventEmitter](https://github.com/DrafaKiller/EventEmitter-dart)