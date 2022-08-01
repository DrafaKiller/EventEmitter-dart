import 'dart:async';

/// # Event Listener
/// A listener is a subscription to a specific topic and type.
/// 
/// This includes all the objects used to attach a listener to an emitter.
class EventListener<MessageType> {
  String? topic;
  Type messageType = MessageType;
  void Function(MessageType data) callback;
  final Stream<MessageType> stream;
  final StreamSubscription<MessageType> subscription;
  bool canceled = false;

  void Function(EventListener)? onCancel;

  EventListener(this.topic, this.callback, this.stream) : subscription = stream.listen(callback);
  EventListener.fromSubscription(this.topic, this.callback, this.stream, this.subscription);

  Future<void> cancel() async {
    canceled = true;
    onCancel?.call(this);
    await subscription.cancel();
  }
}