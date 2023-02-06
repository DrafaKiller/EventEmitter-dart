import 'dart:collection';

import 'package:events_emitter/src/interface/emitter.dart';

void main() {
  final events = EventEmitter();
  final subscription = events.on('jump', (double height) => print('Jumped $height meters!'));
  [].add(value)
}
