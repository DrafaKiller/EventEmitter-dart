[![Pub.dev package](https://img.shields.io/badge/pub.dev-events__emitter-blue)](https://pub.dev/packages/events_emitter)
[![GitHub repository](https://img.shields.io/badge/GitHub-EventEmitter--dart-blue?logo=github)](https://github.com/DrafaKiller/EventEmitter-dart)

# Event Emitter

An Event-based system, highly inspired by [NodeJS's Event Emitter](https://nodejs.org/api/events.html). This implementation uses generic types to allow for multiple data types while being very intuitive.

Based on JavaScript and suitable for Dart and Flutter with type safety.

## Features

* Attach multiple listeners to an event emitter.
* Listen to events with a specific **event type** and **data type**.
* Emit an event of a specific type to be broadcasted to all listeners.
* Type safety, only the right type will be passed in.
* Use callbacks with `EventEmitter`.
* Use streams with `StreamEventEmitter`.
* Can be extended to create custom event emitters and events.
* Custom events can hold custom data to be used in the listeners.

## Getting started

Install it using pub:
```
dart pub add events_emitter
```

And import the package:
```dart
import 'package:events_emitter/events_emitter.dart';
```

## Usage

```dart
final events = EventEmitter();

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
final listener = events.on('message', ... ));
listener.cancel();
```

Remove listeners, by targeting an **event type**, **data type** and **callback**.
```dart
// Remove all listeners
events.off();

// Remove listeners of type `String`
events.off<String>();

// Remove listeners on topic `message`
events.off(topic: 'message');

// Remove listeners of type `String` on topic `message`
events.off<String>(topic: 'message');
```

## Listeners

Listeners are attached to an event emitter and are called when an event matches its signature, they can be added manually for flexibility.

```dart
final events = EventEmitter();
  ...
final listener = EventListener('message', (String data) => print('String: $data'));
events.addEventListener(listener);
  ...
listener.cancel();
```

Specific properties can be set on the listener to change its behavior.
- `once`: If set to `true`, the listener will be removed after the first call.
- `protected`: If set to `true`, the listener will not be removed when calling `events.off()`.

Add callbacks to a listener.
- `onAdd`: Called when the listener is added to the event emitter.
- `onRemove`: Called when the listener is removed from the event emitter.
- `onCancel`: Called when the listener is canceled.

```dart
final events = EventEmitter();
  ...
final listener = EventListener(
  'message',
  (String data) => ... ,
  
  once: false,
  protected: false,

  onAdd: (emitter, listener) => ... ,
  onRemove: (emitter, listener) => ... ,
  onCancel: (listener) => ... ,
);
```

## Why is this package different?

`events_emitter` implements the Event-based system using **callbacks** and **streams**, making it very easy to use and very flexible, allowing you to choose the best way to use it. If you need to fit your needs, you can extend the `EventEmitter` and `Event` classes to create your own custom interface.

And something very important, `events_emitter` allows you to use **type-safe** events, so you can use the same event type for different data types. Not having to worry about the wrong type being passed in.

## Example

The `EventEmitter` class can be used by itself or can be extended to create a custom event emitter.

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
* [StreamEventEmitter](https://github.com/DrafaKiller/EventEmitter-dart/blob/main/example/lib/event_emitter_stream.dart)
* [Sync](https://github.com/DrafaKiller/EventEmitter-dart/blob/main/example/lib/sync.dart)
* [Extendable](https://github.com/DrafaKiller/EventEmitter-dart/blob/main/example/lib/extendable.dart)
* [CustomEvents](https://github.com/DrafaKiller/EventEmitter-dart/blob/main/example/lib/custom_event.dart)