import 'dart:async';

import 'interface/emitter.dart' as I;
import 'utils/type.dart';

part 'event.dart';
part 'listener.dart';
part 'subscription.dart';
part 'target.dart';

class EventEmitter implements I.EventEmitter {
  final listeners = <I.EventListener>{};
  I.EventStream get events => _onEvent.stream;

  /* -= Listener Methods =- */

  bool addEventListener(I.EventListener listener) {
    if (!listeners.add(listener)) return false;
    listener.onCancel.then((_) => removeEventListener(listener));
    listener.bind(this);
    return true;
  }
  
  bool removeEventListener(I.EventListener listener) {
    if (!listeners.remove(listener)) return false;
    listener.unbind();
    return true;
  }

  /* -= Emitting Methods =- */

  bool emit<T>(String type, [ T? data ]) => dispatch(data != null ? Event<T>(type, data) : Event<T?>(type, null));
  
  bool dispatch<T extends I.Event>(T event) {
    final consumed = listeners.fold(false, (bool consumed, listener) => listener.accept(event) || consumed);
    _onEvent.add(event);
    return consumed;
  }

  /* -= Listening Methods =- */

  I.EventSubscription<Event<T>> on<T>(String type, [ I.EventCallback<T>? callback ]) {
    final listener = EventListener<Event<T>>(EventTarget(type), alias: callback);
    addEventListener(listener);
    return EventSubscription<Event<T>>(this, listener);
  }

  I.EventSubscription<Event<T>> once<T>(String type, [ I.EventCallback<T>? callback ]);

  I.EventSubscription<T> onDispatch<T extends I.Event>([ I.EventDispatchCallback<T>? callback ]);

  bool off<T extends I.Event>({ String? type, I.EventCallback<T>? callback }) {

  }

  /* -= Controllers =- */

  final _onEvent = StreamController<I.Event>.broadcast();
}