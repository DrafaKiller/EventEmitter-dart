import 'dart:async';

abstract class Mountable<T> {
  bool get mounted;

  /* -= Callbacks =- */

  Future<T> get onAdd;
  Future<T> get onRemove;
}
