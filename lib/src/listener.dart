part of 'emitter.dart';

class EventListener<EventT extends Event> {
  final String? type;
  
  final bool once;
  final bool protected;

  EventListener(this.type, {
    this.once = false,
    this.protected = false,

    // Callbacks
    EventListenerOnAdd? onAdd,
    EventListenerOnRemove? onRemove,
    EventListenerOnEvent<EventT>? callback,
    EventListenerOnCancel? onCancel,
  }) {
    if (onAdd != null) this.onAdd.listen(onAdd);
    if (onRemove != null) this.onRemove.listen(onRemove);
    if (callback != null) this.onEvent.listen(callback);
    if (onCancel != null) this.onCancel.listen(onCancel);
  }

  /* -= Event Methods =- */

  bool accept<T extends Event>(T event) {
    if (isForWrapped && !event.isWrapped) return accept(event.wrap());

    if (!validate(event)) return false;
    execute(event as EventT);
    return true;
  }

  bool validate(Event event) => event is EventT && (type == null || event.type == type);

  void execute(EventT event) => onEvent(event);

  void cancel() => onCancel();

  /* -= Streams =- */

  Stream<EventT> get events => onEvent.stream;

  /* -= Callbacks =- */
  
  final onAdd = Listenable<EventListenerOnAdd>();
  final onRemove = Listenable<EventListenerOnRemove>();
  final onEvent = Listenable<EventListenerOnEvent<EventT>>();
  final onCancel = Listenable<EventListenerOnCancel>();
}

/* -= Event Callbacks =- */

typedef EventListenerOnAdd = void Function(EventEmitter emitter);
typedef EventListenerOnRemove = void Function(EventEmitter emitter);
typedef EventListenerOnEvent<T extends Event> = void Function(T event);
typedef EventListenerOnData<T> = void Function(T data);
typedef EventListenerOnCancel = void Function();

/* -= Extended Functionality =- */

extension _WrappedListener on EventListener {
  bool get isForWrapped => this is EventListener<Event<Event>>;
}