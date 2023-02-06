part of 'emitter.dart';

class EventListener<T extends I.Event> extends EventSubscription<T> implements I.EventListener<T> {
  final I.EventTarget<T> target;

  final bool protected;
  final bool once;

  final I.EventCallback? alias;

  EventListener(this.target, {
    this.alias,

    this.protected = false,
    this.once = false,
  });

  /* -= Mounting Methods =- */
  
  void bind(I.EventEmitter emitter) {
    if (mounted) return;
    _emitter = emitter;
    _onAdd.complete(emitter);
  }

  void unbind() {
    if (!mounted) return;
    _emitter = null;
    _onRemove.complete();
  }

  /* -= Event Methods =- */
  
  @override
  I.EventStream<T> get stream => throw UnimplementedError();
  
  bool accept(I.Event event) {
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

  /* -= Callbacks =- */

  Future<I.EventEmitter> get onAdd => _onAdd.future;
  Future<void> get onRemove => _onRemove.future;
  
  /* -= Controllers =- */

  final _onAdd = Completer<I.EventEmitter>();
  final _onRemove = Completer<void>();
  final _onEvent = StreamController<T>.broadcast();
}