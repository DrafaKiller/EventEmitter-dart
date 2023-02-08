import 'dart:async';

part 'declarations.dart';
part 'dispatcher.dart';
part 'event.dart';
part 'listener.dart';
part 'subscription.dart';
part 'target.dart';

abstract class EventEmitter {
  /* -= Listener Methods =- */

  abstract final List<EventListener> listeners;

  bool addEventListener(EventListener listener);
  bool removeEventListener(EventListener listener);
  
  /* -= Emitting Methods =- */

  EventStream get events;

  bool emit<T>(String type, [ T? data ]);
  bool dispatch<T extends Event>(T event);

  /* -= Listening Methods =- */

  EventSubscription<Event<T>> on<T>(String type, [ EventCallback<T>? callback ]);
  EventSubscription<Event<T>> once<T>(String type, [ EventCallback<T>? callback ]);
  EventSubscription<T> onDispatch<T extends Event>([ EventDispatchCallback<T>? callback ]);

  bool off<T extends Event>({ String? type, EventCallback<T>? callback });
}

class EventStream<T extends Event> extends Stream<T> {
  final EventEmitter emitter;

  EventStream(this.emitter);

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
      EventListener<T>? listener,

      Function? onError,
      void Function()? onDone,
      bool? cancelOnError,
    }
  ) {
    if (listener == null) emitter.addEventListener(listener);
    return EventSubscription(this, listener);
  }
  
}

class EventStream