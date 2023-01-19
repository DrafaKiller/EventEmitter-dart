import '../listenable.dart';

typedef EventCallback<T> = void Function(T data);

class EventEmitter {
  final listeners = <EventListener>{};

  EventListener<T> on<T>(String type, [ EventCallback<T>? callback ]) {
    
  }
}

class Event<T> {
  final String type;
  final T data;

  Event(this.type, this.data);
}

class EventListener<T> {
  final String type;

  final onAdd = Listenable<Function(String test2, [ int? okay, dynamic idk ])>();

  EventListener(this.type);

  void main() {
    final subscription = onAdd.listen((test2, [okay, idk]) => print);
    subscription.cancel();

    onAdd.call('123');
  }
}
