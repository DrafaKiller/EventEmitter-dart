part of 'emitter.dart';

class EventListener<T extends Event> implements Interface.EventListener<T> {
  final Interface.EventTarget<T> target;
  late final Interface.EventEmitter emitter;

  final bool protected;
  final bool once;
  
  final Interface.EventCallback? _aliasCallback;

  EventListener(this.target, {
    Interface.EventCallback? aliasCallback,

    this.protected = false,
    this.once = false,
  }) : _aliasCallback = aliasCallback;

  /* -= Event Methods =- */

  Stream<T> get stream => _onEvent.stream;
  
  bool accept(Interface.Event event) {
    if (!target.accept(event)) return false;
    return execute(event as T);
  }

  bool execute(T event) {
    if (cancelled) return false;
    if (!_onEvent.hasListener) return false;

    _onEvent.add(event);

    if (once) cancel();
    return true;
  }

  /* -= Subscription Methods =- */

  bool get cancelled => _onCancel.isCompleted;
  bool cancel() {
    if (cancelled) return false;

    _onCancel.complete();
    return true;
  }

  void bind(Interface.EventEmitter emitter) {
    this.emitter = emitter;
    _onAdd.complete(emitter);
  }
  void unbind();

  /* -= Callbacks =- */

  Future<EventEmitter> get onAdd => _onAdd.future;
  Future<void> get onRemove => _onRemove.future;
  Future<void> get onCancel => _onCancel.future;

  /* -= Controllers =- */

  final _onEvent = StreamController<T>.broadcast();

  final _onAdd = Completer<EventEmitter>();
  final _onRemove = Completer<void>();
  final _onCancel = Completer<void>();
}