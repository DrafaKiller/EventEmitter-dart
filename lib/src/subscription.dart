part of 'emitter.dart';


class EventSubscription<T extends Event> extends Listening<EventListenerOnEvent<T>> {
  final EventEmitter emitter;
  final EventListener<T> listener;

  final onCancel = Listenable<EventSubscriptionOnCancel>();

  EventSubscription(this.emitter, this.listener) : super();

  bool get isCancelled => !emitter.listeners.contains(listener);
  bool cancel() {
    if (isCancelled) return false;
    listener.subscriptions.remove(this);
    onCancel();
    listener.onCancel();
    return emitter.removeEventListener(listener);
  }
}
