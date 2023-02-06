import 'dart:async';

import 'interface/emitter.dart' as Interface;
import 'utils/type.dart';

part 'event.dart';
part 'listener.dart';
part 'subscription.dart';
part 'target.dart';

class EventEmitter implements Interface.EventEmitter {
  final listeners = <Interface.EventListener>{};

  /* -= Listener Methods =- */

  bool addEventListener(Interface.EventListener listener) {
    if (!listeners.add(listener)) return false;
    listener.onCancel.then((_) => removeEventListener(listener));
    listener.bind(this);
    return true;
  }
  
  bool removeEventListener(Interface.EventListener listener) {
    if (!listeners.remove(listener)) return false;
    listener.unbind(this);
    return true;
  }

  /* -= Emitting Methods =- */

  Interface.EventStream get events => _onEvent.stream;

  bool emit<T>(String type, [ T? data ]) => dispatch(data != null ? Event<T>(type, data) : Event<T?>(type, null));
  bool dispatch<T extends Interface.Event>(T event) {
    final consumed = listeners.fold(false, (bool consumed, listener) => listener.accept(event) || consumed);
    _onEvent.add(event);
    return consumed;
  }

  /* -= Listening Methods =- */

  EventSubscription<Event<T>> on<T>(String type, [ Interface.EventCallback<T>? callback ]) {
    final listener = EventListener<Event<T>>(EventTarget(type), aliasCallback: callback);
    addEventListener(listener);
    return EventSubscription<Event<T>>(this, listener);
  }
  
  Interface.EventSubscription<Event<T>> once<T>(String type, [ Interface.EventCallback<T>? callback ]);
  Interface.EventSubscription<T> onDispatch<T extends Event>([ Interface.EventDispatchCallback<T>? callback ]);

  bool off<T extends Event>({ String? type, EventCallback<T>? callback });

  /* -= Controllers =- */

  final _onEvent = StreamController<Interface.Event>.broadcast();
}