import 'package:events_emitter/events_emitter.dart';

/// ## RestrictedEventEmitter
/// 
/// A **EventEmitter** with properties that allows to control and restrict.
/// - The max number of listeners that can be added to the emitter.
/// - The list of allowed/disallowed event types 
class RestrictedEventEmitter extends EventEmitter {
  /// List of allowed event types.
  final Set<String>? allow;

  /// List of disallowed event types.
  final Set<String>? disallow;

  /// Max number of listeners that can be added to the emitter.
  final int? maxListeners;

  /// ## RestrictedEventEmitter
  /// 
  /// ```dart
  /// RestrictedEventEmitter events = RestrictedEventEmitter(allow: { 'message', 'data', 'error' }, maxListeners: 3);
  /// 
  /// events.on('message', (String data) => print('String: $data'));
  /// events.on('message', (int data) => print('Integer: $data'));
  /// ```
  RestrictedEventEmitter({ this.allow, this.disallow, this.maxListeners });
  
  @override
  bool addEventListener<T>(EventListener<T> listener) {
    if (!_checkAllowed(listener.type)) throw EventNotAllowedException(listener.type!);
    if (maxListeners != null && listeners.length >= maxListeners!) throw MaxListenersException(maxListeners!);
    return super.addEventListener(listener);
  }

  bool _checkAllowed(String? type) =>
    !(
      type != null && 
      (
        (allow != null && !allow!.contains(type)) || 
        (disallow != null && disallow!.contains(type))
      )
    );
}

class EventNotAllowedException implements Exception {
  final String type;
  const EventNotAllowedException(this.type);

  @override
  String toString() => 'Event type "$type" is not allowed, in $RestrictedEventEmitter';
}

class MaxListenersException implements Exception {
  final int maxListeners;
  const MaxListenersException(this.maxListeners);

  @override
  String toString() => 'Max listeners reached ($maxListeners), in $RestrictedEventEmitter';
}