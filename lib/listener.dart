import 'package:events_emitter/emitters/event_emitter.dart';
import 'package:events_emitter/event.dart';
import 'package:events_emitter/utils/type.dart';

/// # Event Listener
/// A listener is a subscription to a specific **event type** and **data type**.
/// 
/// This includes all the information needed for how to react with an event emitter.
class EventListener<CallbackDataT> {
  final String? type;
  final EventCallback<CallbackDataT> callback;
  final Type dataType = CallbackDataT;
  
  final bool once;
  final bool protected;
  EventCallbackAdd<CallbackDataT>? onAdd;
  EventCallbackRemove<CallbackDataT>? onRemove;
  EventCallbackCall<CallbackDataT>? onCall;
  EventCallbackCancel<CallbackDataT>? onCancel;

  bool _canceled = false;
  bool get canceled => _canceled;

  /// ## Event Listener
  /// A listener is a subscription to a specific **event type** and **data type**.
  /// 
  /// This includes all the information needed for how to react with an event emitter.
  EventListener(this.type, this.callback, {
    this.once = false,
    this.protected = false,
    this.onAdd, this.onRemove, this.onCall, this.onCancel,
    bool cancelAdded = true,
  }) {
    if (cancelAdded) {
      appendCallback(
        onAdd: (emitter, listener) {
          listener.appendCallback(
            onCancel: (listener) => emitter.removeEventListener(listener),
          );
        },
      );
    }
  }

  /// Checks if the listener matches the event.
  /// If the event is valid, the callback will be called.
  /// 
  /// This method will not call the callback if the listener is canceled.
  /// 
  /// Returns `true` if the callback was satisfied.
  /// Listeners that don't match the event count as satisfied.
  bool call<T extends Event>(T event) {
    if (!canceled && validate(event)) {
      final data = (event.data is CallbackDataT ? event.data : event) as CallbackDataT;
      final satisfied = callback(data);
      if (once) cancel();
      
      onCall?.call(this, data);
      
      if (satisfied is bool) return satisfied;
      return true;
    }
    return false;
  }

  /// Checks if the listener matches a given event.
  bool validate<T extends Event>(T event) =>
    (
      event is CallbackDataT || 
      event.data is CallbackDataT ||
      isSubtype<T, CallbackDataT>() || 
      isSubtype<T, Event<CallbackDataT>>()
    ) && 
    (event.type == type || type == null);
  
  /// Checks if the listener matches the **event type**, **data type** and **callback**.
  bool matches<T>([ String? type, EventCallback<T>? callback ]) =>
    (
      isSubtype<CallbackDataT, T>() || 
      isSubtype<Event<CallbackDataT>, T>()
    ) &&
    (this.type == type || this.type == null || type == null) &&
    (this.callback == callback || callback == null);

  /// Cancel the listener.
  /// 
  /// This will also call the [onCancel] callback,
  /// which by default will be remove the listener from the emitter.
  void cancel() {
    if (!canceled) {
      _canceled = true;
      onCancel?.call(this);
    }
  }

  void appendCallback({
    EventCallbackAdd<CallbackDataT>? onAdd,
    EventCallbackRemove<CallbackDataT>? onRemove,
    EventCallbackCall<CallbackDataT>? onCall,
    EventCallbackCancel<CallbackDataT>? onCancel,
  }) {
    if (onAdd != null) {
      final oldAdd = this.onAdd;
      this.onAdd = (EventEmitter emitter, EventListener<CallbackDataT> listener) {
        oldAdd?.call(emitter, listener);
        onAdd.call(emitter, listener);
      };
    }

    if (onRemove != null) {
      final oldRemove = this.onRemove;
      this.onRemove = (EventEmitter emitter) {
        oldRemove?.call(emitter);
        onRemove.call(emitter);
      };
    }

    if (onCall != null) {
      final oldCall = this.onCall;
      this.onCall = (EventListener<CallbackDataT> listener, CallbackDataT data) {
        oldCall?.call(listener, data);
        onCall.call(listener, data);
      };
    }
    
    if (onCancel != null) {
      final oldCancel = this.onCancel;
      this.onCancel = (EventListener<CallbackDataT> listener) {
        oldCancel?.call(listener);
        onCancel.call(listener);
      };
    }
  }
}

typedef EventCallback<T> = dynamic Function(T data);

typedef EventCallbackAdd<T> = void Function(EventEmitter emitter, EventListener<T> listener);
typedef EventCallbackRemove<T> = void Function(EventEmitter emitter);
typedef EventCallbackCall<T> = void Function(EventListener<T> listener, T data);
typedef EventCallbackCancel<T> = void Function(EventListener<T> listener);
