import 'dart:async';

class EventEmitter {
  EventStream get events => _events.stream;

  /* -= Controllers =- */

  final _events = EventController.broadcast();
}

typedef EventStream<T extends Event> = Stream<T>;
typedef EventController<T extends Event> = StreamController<T>;

class Event<T> {
  final String type;
  final T data;

  const Event(this.type, this.data);
}



void main() {
  final observableList = ObservableList<int>();
  
  observableList.itemAddedStream.listen((value) => print(value));
  
  observableList.add(1);
  observableList.add(2);
  observableList.add(3);
  observableList.add(4);
}