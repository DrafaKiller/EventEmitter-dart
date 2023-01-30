// ignore_for_file: camel_case_extensions

part of 'listenable.dart';

/* -= Basic =- */ 

extension EmptyListenable on Listenable {
  void call() => callbacks.forEach((callback) => callback());
}

extension SingleListenable<T> on Listenable<Function(T)> {
  void call(T data) => callbacks.forEach((callback) => callback(data));

  Stream<T> get stream {
    final controller = StreamController<T>();
    final listening = listen((data) => controller.add(data));
    controller.onCancel = listening.cancel;
    return controller.stream;
  }
}

extension OptionalListenable<T> on Listenable<Function([ T? ])> {
  void call([ T? data ]) => callbacks.forEach((callback) => callback(data));
}

/* -= Advanced =- */

// 2 Arguments

extension ArgumentListenable2<T1, T2> on Listenable<Function(T1, T2)> {
  void call(T1 argument1, T2 argument2) => callbacks.forEach((callback) => callback(argument1, argument2));
}

extension OptionalListenable2<T1, T2> on Listenable<Function([ T1?, T2? ])> {
  void call([ T1? argument1, T2? argument2 ]) => callbacks.forEach((callback) => callback(argument1, argument2));
}

extension MixedListenable2_Required1<T1, T2> on Listenable<Function(T1, [ T2? ])> {
  void call(T1 argument1, [ T2? argument2 ]) => callbacks.forEach((callback) => callback(argument1, argument2));
}

// 3 Arguments

extension ArgumentListenable3<T1, T2, T3> on Listenable<Function(T1, T2, T3)> {
  void call(T1 argument1, T2 argument2, T3 argument3) => callbacks.forEach((callback) => callback(argument1, argument2, argument3));
}

extension OptionalListenable3<T1, T2, T3> on Listenable<Function([ T1?, T2?, T3? ])> {
  void call([ T1? argument1, T2? argument2, T3? argument3 ]) => callbacks.forEach((callback) => callback(argument1, argument2, argument3));
}

extension MixedListenable3_Required1<T1, T2, T3> on Listenable<Function(T1, [ T2?, T3? ])> {
  void call(T1 argument1, [ T2? argument2, T3? argument3 ]) => callbacks.forEach((callback) => callback(argument1, argument2, argument3));
}

extension MixedListenable3_Required2<T1, T2, T3> on Listenable<Function(T1, T2, [ T3? ])> {
  void call(T1 argument1, T2 argument2, [ T3? argument3 ]) => callbacks.forEach((callback) => callback(argument1, argument2, argument3));
}

// 4 Arguments

extension ArgumentListenable4<T1, T2, T3, T4> on Listenable<Function(T1, T2, T3, T4)> {
  void call(T1 argument1, T2 argument2, T3 argument3, T4 argument4) => callbacks.forEach((callback) => callback(argument1, argument2, argument3, argument4));
}

extension OptionalListenable4<T1, T2, T3, T4> on Listenable<Function([ T1?, T2?, T3?, T4? ])> {
  void call([ T1? argument1, T2? argument2, T3? argument3, T4? argument4 ]) => callbacks.forEach((callback) => callback(argument1, argument2, argument3, argument4));
}

extension MixedListenable4_Required1<T1, T2, T3, T4> on Listenable<Function(T1, [ T2?, T3?, T4? ])> {
  void call(T1 argument1, [ T2? argument2, T3? argument3, T4? argument4 ]) => callbacks.forEach((callback) => callback(argument1, argument2, argument3, argument4));
}

extension MixedListenable4_Required2<T1, T2, T3, T4> on Listenable<Function(T1, T2, [ T3?, T4? ])> {
  void call(T1 argument1, T2 argument2, [ T3? argument3, T4? argument4 ]) => callbacks.forEach((callback) => callback(argument1, argument2, argument3, argument4));
}

extension MixedListenable4_Required3<T1, T2, T3, T4> on Listenable<Function(T1, T2, T3, [ T4? ])> {
  void call(T1 argument1, T2 argument2, T3 argument3, [ T4? argument4 ]) => callbacks.forEach((callback) => callback(argument1, argument2, argument3, argument4));
}