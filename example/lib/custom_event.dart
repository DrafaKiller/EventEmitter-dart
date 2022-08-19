// ignore_for_file: avoid_print

import 'package:events_emitter/events_emitter.dart';

class Player {
  final String name;
  Player(this.name);
}

class JumpEvent extends Event<Player> {
  final DateTime time;
  final Player player;
  JumpEvent(this.player) : time = DateTime.now(), super('jump', player);
}

void main() {
  final events = EventEmitter();
  
  events.on('jump', (Player player) => print('Player ${player.name} jumped!'));
  events.on('jump', (JumpEvent event) => print('Player ${event.player.name} jumped at ${event.time}!'));
  
  events.emitEvent(JumpEvent(Player('John')));

  // [Output]
  // Player John jumped!
  // Player John jumped at 2022-01-01 01:23:45.000!
}
