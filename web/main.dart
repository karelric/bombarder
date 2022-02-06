import 'dart:html';

import 'package:gamedart/game.dart';

void main() {
  final menu = querySelector('.menu');
  final game = Game(onGameOver: (game) {
    window.alert('Game Over!');
    menu?.style.display = 'flex';
    game.clear();
  });
  game.playSound();

  querySelector('#start')?.onClick.listen((_) {
    menu?.style.display = 'none';
    game.start();
  });
}
