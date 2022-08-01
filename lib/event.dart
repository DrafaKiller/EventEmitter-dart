/// # Event
/// A event is a message that was broadcasted to all listeners that with a type and topic.
class Event<MessageType> {
  final String topic;
  final MessageType message;

  const Event(this.topic, this.message);
}