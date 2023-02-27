abstract class Cancelable {
  bool get canceled;
  Future<void> cancel();

  /* -= Callbacks =- */

  Future<void> get onCancel;
}
