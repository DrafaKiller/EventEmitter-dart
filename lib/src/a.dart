

class Event<DataT> extends CustomEvent<EventCallback<DataT>> {
  final DataT data;

  Event(String type, DataT data) :
    data = data,
    super(type, (callback) => callback(data));

  static CustomEvent<T> custom<T extends Function>(String type, EventHandler<T> handler) => CustomEvent(type, handler);
}

class CustomEvent<T extends Function> {
  final String type;
  final EventHandler<T> handler;

  CustomEvent(this.type, this.handler);
}

typedef EventHandler<T extends Function> = void Function(T callback);

typedef EventCallback<DataT> = void Function(DataT data);
