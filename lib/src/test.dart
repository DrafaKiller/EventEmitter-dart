import 'dart:async';

class EventEmitter {
  final listeners = <StreamSubscription<Event>>{};


}

class Event<T> {
  final String type;
  final T data;

  Event(this.type, this.data);
}

class EventListener<T> extends StreamSubscription<T> {
  @override
  Future<E> asFuture<E>([E? futureValue]) {
    // TODO: implement asFuture
    throw UnimplementedError();
  }

  @override
  Future<void> cancel() {
    // TODO: implement cancel
    throw UnimplementedError();
  }

  @override
  // TODO: implement isPaused
  bool get isPaused => throw UnimplementedError();

  @override
  void onData(void Function(T data)? handleData) {
    // TODO: implement onData
  }

  @override
  void onDone(void Function()? handleDone) {
    // TODO: implement onDone
  }

  @override
  void onError(Function? handleError) {
    // TODO: implement onError
  }

  @override
  void pause([Future<void>? resumeSignal]) {
    // TODO: implement pause
  }

  @override
  void resume() {
    // TODO: implement resume
  }
}