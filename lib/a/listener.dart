part of 'emitter.dart';

class EventListener<T extends Event> with Mountable<EventEmitter>, Cancelable {
  final EventTarget<T> target;

  final bool protected;
  final bool once;

  EventListener(this.target, { this.protected = false, this.once = false });

  /* -= Event Methods =- */
  
  bool accept(Event event) {
    if (!target.accepts(event)) return false;
    execute(event as T);
    return true;
  }

  void execute(T event) {
    if (once) cancel();
    _events.add(event);
  }

  /* -= Mountable and Cancelable =- */

  bool get mounted => _add.isCompleted && !_remove.isCompleted && !_cancel.isCompleted;
  bool get canceled => _cancel.isCompleted;

  Future<void> cancel() async {
    if (canceled) return;
    _cancel.complete();
    await _events.close();
  }

  /* -= Callbacks =- */

  EventStream<T> get events => _events.stream;

  Future<EventEmitter> get onAdd => _add.future;
  Future<EventEmitter> get onRemove => _remove.future;
  Future<void> get onCancel => _cancel.future;

  /* -= Callback Controllers =- */

  final _events = EventController<T>.broadcast();

  final _add = Completer<EventEmitter>();
  final _remove = Completer<EventEmitter>();
  final _cancel = Completer<void>();
}
