import 'dart:async';

import 'components/cancelable.dart';
import 'components/mountable.dart';
import 'utils/types.dart';

part 'definitions.dart';
part 'event.dart';
part 'listener.dart';
part 'subscription.dart';
part 'target.dart';

class EventEmitter {
  /* -= Listeners =- */

  final List<EventListener> listeners = [];

  void addEventListener(EventListener listener) {
    if (listener.mounted) return;

    listeners.add(listener);
    listener.onCancel.then((_) => removeEventListener(listener));
    listener._add.complete(this);
  }

  void removeEventListener(EventListener listener) {
    if (!listener.mounted) return;

    listeners.remove(listener);
    listener._remove.complete(this);
  }
  
  /* -= Emitting Methods =- */

  EventStream get events => _controller.stream;

  bool emit<T>(String type, [ T? data ]);

  bool dispatch<T extends Event>(T event) => 

  /* -= Listening Methods =- */

  EventSubscription<Event<T>> on<T>(String type, [ EventCallback<T>? callback ]);
  EventSubscription<Event<T>> once<T>(String type, [ EventCallback<T>? callback ]);
  EventSubscription<T> onDispatch<T extends Event>([ EventDispatchCallback<T>? callback ]);

  bool off<T extends Event>({ String? type, EventCallback<T>? callback });

  /* -= Controllers =- */

  final _controller = EventController<Event>.broadcast();
}