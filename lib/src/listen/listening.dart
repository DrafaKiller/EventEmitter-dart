part of 'listenable.dart';

class Listening<CallbackT extends Function> {
  final Listenable<CallbackT> listenable;
  final CallbackT callback;

  final Function? onCancel;

  const Listening(this.listenable, this.callback, { this.onCancel });

  /* -= Action Methods =- */

  bool cancel() {
    onCancel?.singleHandler();
    return listenable.callbacks.remove(callback);
  }

  /* -= Properties =- */

  bool get isCancelled => !listenable.callbacks.contains(callback);
}
