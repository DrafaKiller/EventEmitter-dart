part of 'emitter.dart';

abstract class EventSubscription<T extends I.Event> implements I.EventSubscription<T> {
  /* -= Mounting Methods =- */
  
  I.EventEmitter? _emitter;
  I.EventEmitter get emitter => _emitter!;
  
  bool get mounted => _emitter != null;

  /* -= Event Methods =- */

  I.EventStream<T> get stream;

  bool get cancelled => _onCancel.isCompleted;
  bool cancel() {
    if (cancelled) return false;
    _onCancel.complete();
    return true;
  }

  /* -= Callbacks =- */

  Future<void> get onCancel => _onCancel.future;

  /* -= Controllers =- */

  final _onCancel = Completer<void>();
}