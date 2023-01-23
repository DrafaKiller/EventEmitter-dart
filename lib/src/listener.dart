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

  bool accept(Event event) {
    if (this is EventListener<Event<Event>>) return accept(Event(event.type, event));
    if (!validate(event)) return false;
    emit(event as EventT);
    return true;
  }

  bool validate(Event event) => event is EventT && event.type == type;

  void emit(EventT event) => onEvent(event);

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






extension Environment on Platform {
  static String getString(String name, [ String? defaultValue ]) {
    final value = Platform.environment[name];
    if (value == null) return defaultValue ?? (throw EnvironmentNotSetError(name));
    return value;
  }

  static bool getBool(String name, [ bool? defaultValue ]) {
    final value = Platform.environment[name];
    if (value == null) return defaultValue ?? (throw EnvironmentNotSetError(name));
    if (value == 'true') return true;
    if (value == 'false') return false;
    throw EnvironmentParsingError(name, value, bool);
  }

  static int getInt(String name, [ int? defaultValue ]) {
    final value = Platform.environment[name];
    if (value == null) return defaultValue ?? (throw EnvironmentNotSetError(name));
    final result = int.tryParse(value);
    if (result == null) throw EnvironmentParsingError(name, value, int);
    return result;
  }

  static double getDouble(String name, [ double? defaultValue ]) {
    final value = Platform.environment[name];
    if (value == null) return defaultValue ?? (throw EnvironmentNotSetError(name));
    final result = double.tryParse(value);
    if (result == null) throw EnvironmentParsingError(name, value, double);
    return result;
  }
}












class EnvironmentParsingError extends Error {
  EnvironmentParsingError(this.name, this.value, this.type);

  final String name;
  final Type type;
  final String value;

  @override
  String toString() => 'Could not parse environment variable $name (value: $value) to $type.';
}

class EnvironmentNotSetError extends Error {
  EnvironmentNotSetError(this.variableName);
  final String variableName;

  @override
  String toString() => 'Environment variable $variableName not set.';
}