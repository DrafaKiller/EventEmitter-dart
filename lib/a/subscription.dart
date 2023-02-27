part of 'emitter.dart';

class EventSubscription<T extends Event> with Cancelable {
  final EventEmitter emitter;
  final EventListener<T> listener;

  EventSubscription(this.emitter, this.listener);

  /* -= Mountable and Cancelable =- */

  bool get canceled => _cancel.isCompleted || listener.canceled;

  Future<void> cancel() async {
    if (canceled) return;
    _cancel.complete();
    await listener.cancel();
  }

  /* -= Callbacks =- */

  Future<void> get onCancel => _cancel.future;

  /* -= Callback Controllers =- */

  final _cancel = Completer<void>();
}