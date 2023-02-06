part of 'emitter.dart';

class EventSubscription<T extends Event> implements Interface.EventSubscription<T> {
  final EventEmitter emitter;
  final EventListener<T> listener;

  EventSubscription(this.emitter, this.listener);

  bool get cancelled => listener.cancelled;
  bool cancel() {
    if (cancelled) return false;
    
    emitter.removeEventListener(listener);
    _onCancel.complete();

    return true;
  }

  /* -= Callbacks =- */

  Future<void> get onCancel => _onCancel.future;

  /* -= Controllers =- */

  final _onCancel = Completer<void>();
}