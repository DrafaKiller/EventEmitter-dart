import 'dart:async';

part 'definitions.dart';
part 'event.dart';
part 'listener.dart';
part 'subscription.dart';
part 'target.dart';

part 'controllers/emitter.dart';
part 'controllers/listener.dart';

abstract class EventEmitter {
  EventStream get events;

  /* -= Emitting Methods =- */

  bool emit<T>(String type, [ T? data ]);
  bool dispatch<T extends Event>(T event);

  /* -= Listening Methods =- */

  EventSubscription<Event<T>> on<T>(String type, [ EventCallback<T>? callback ]);
  EventSubscription<Event<T>> once<T>(String type, [ EventCallback<T>? callback ]);
  EventSubscription<T> onDispatch<T extends Event>([ EventDispatchCallback<T>? callback ]);

  bool off<T extends Event>({ String? type, EventCallback<T>? callback });
}