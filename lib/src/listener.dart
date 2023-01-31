part of 'emitter.dart';

abstract class EventListener<T extends Event> {
  final EventTarget<T> target;
  final subscriptions = <EventSubscription<T>>{};

  final bool protected;
  final bool once;

  EventListener(this.target, {
    this.protected = false,
    this.once = false,

    EventListenerOnEvent<T>? onEvent,
  }) {
    if (onEvent != null) this.onEvent.listen(onEvent);
  }

  /* -= Event Methods =- */

  Stream<T> get stream => onEvent.stream;
  
  bool accept(Event event) {
    if (!target.accept(event)) return false;
    return execute(event as T);
  }

  bool execute(T event);

  /* -= Subscription Methods =- */

  bool get isCancelled => subscriptions.isEmpty;
  bool cancel() {
    if (isCancelled) return false;
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    return true;
  }

  /* -= Listener Callbacks =- */

  final onAdd = Listenable<EventListenerOnAdd>();
  final onRemove = Listenable<EventListenerOnRemove>();
  final onEvent = Listenable<EventListenerOnEvent<T>>();
  final onCancel = Listenable<EventListenerOnCancel>();
}
