class Event<T> {
  final String type;
  final T data;
  
  Event(this.type, this.data);
}