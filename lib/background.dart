import 'dart:html';

import 'package:gamedart/game.dart';
import 'package:gamedart/game_object.dart';

class Background extends GameObject {
  late CanvasImageSource source;
  final tiles = <Tile>[];

  Background(Game game) : super(game) {
    tiles.add(Tile(game));
  }

  @override
  void update() {
    if (tiles.length < 2 && tiles.last.x < 0) {
      tiles.add(
        Tile(game)..x = tiles.last.x + tiles.last.width - 1,
      );
    }
    tiles.removeWhere((t) => t.x + t.width < 0);
    for (var t in tiles) {
      t.update();
    }
  }

  @override
  void draw() {
    for (var t in tiles) {
      t.draw();
    }
  }
}

class Tile extends GameObject {
  late CanvasImageSource source;

  Tile(Game game) : super(game) {
    source = querySelector('#background') as CanvasImageSource;
    spriteWidth = 1150;
    spriteHeight = 446;
    height = game.height + 56;
    width = height * spriteWidth / spriteHeight;
    y = -10;
    vx = -0.05;
  }

  @override
  void draw() {
    game.context.drawImageScaledFromSource(
      source,
      0,
      0,
      spriteWidth,
      spriteHeight,
      x,
      y,
      width,
      height,
    );
  }
}
