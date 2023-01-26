import 'dart:async';

void main() {
  final controller = StreamController<Event>();
}

class Event<T> {
  final String type;
  final T data;

  const Event(this.type, this.data);
}

class EventEmitter extends Stream<Event> {
  final EventController controller;

  EventEmitter({ EventController? controller }) : controller = controller ?? EventController();

  bool emit(Event event) {
    controller.add(event);
    return true;
  }
  
  @override StreamSubscription<Event> listen(
    void Function(Event event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError
  }) {
    
  }
}

typedef EventController = StreamController<Event>;