part of 'emitter.dart';

class EventDispatcher<T extends Event> extends EventStream<T> {


  @override
  EventSubscription<T> listen(EventDispatchCallback<T>? onData, { Function? onError, void Function()? onDone, bool? cancelOnError }) {

  }
  
}