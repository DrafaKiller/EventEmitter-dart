import 'dart:async';
import 'dart:collection';

import 'package:events_emitter/listenable.dart';
import 'package:events_emitter/src/utils/type.dart';

part 'definitions.dart';
part 'event.dart';
part 'listener.dart';
part 'subscription.dart';
part 'target.dart';

abstract class EventEmitter {
  final listeners = <EventListener>{};

  /* -= Listener Methods =- */

  bool addEventListener(EventListener listener) {
    final added = listeners.add(listener);
    if (added) listener.onAdd(this);
    return added;
  }
  bool removeEventListener(EventListener listener) {
    final removed = listeners.remove(listener);
    if (removed) listener.onRemove(this);
    return removed;
  }

  /* -= Emitting Methods =- */

  bool emit<T>(String type, [ T? data ]) => dispatch(data != null ? Event<T>(type, data) : Event<T?>(type, null));
  bool dispatch(Event event) {
    if (listeners.isEmpty) return false;
    for (final listener in listeners) {
      listener.accept(event);
    }
    return true;
  }

  /* -= Listening Methods =- */

  EventSubscription<Event<T>> on<T>(String type, [ EventListenerOnData<T>? callback ]);
  EventSubscription<Event<T>> once<T>(String type, [ EventListenerOnData<T>? callback ]);
  EventSubscription<T> onDispatch<T extends Event>([ EventListenerOnEvent<T>? callback ]);

  bool off<T extends Event>([ String? type ]) {
    final target = EventTarget<Event<T>>(type);
    return listeners
      .where((listener) => listener.target.matches<Event<T>>(type) || listener.target.matches<Event<T>>(type))
      .fold(false, (removed, listener) => listener.cancel() || removed);
  }

  void main() {
    this.on('jump', (Event<String> event) => print('jumped'));
  }
}

/* 

T = Event<String>
T = Event<Event<String>>

class JumpEvent extends Event<String> {
  JumpEvent(String data) : super('jump', data);
}

class CrouchEvent extends Event<String> {
  CrouchEvent(String data) : super('crouch', data);
}

matches<T extends Event>() => ...;

isAssignable<T, Event>() && matches<T as Event>()

*/