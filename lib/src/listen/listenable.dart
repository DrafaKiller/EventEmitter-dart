library listenable;

import 'dart:async';

part 'listening.dart';
part 'call.dart';

class Listenable<CallbackT extends Function> {
  final callbacks = <CallbackT>[];

  Listening<CallbackT> listen(CallbackT callback, { ListenableCancelCallback? onCancel }) {
    callbacks.add(callback);
    return Listening(this, callback, onCancel: onCancel);
  }
}

typedef ListenableCancelCallback = void Function();