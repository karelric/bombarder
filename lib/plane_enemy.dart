import 'dart:html';
import 'dart:math';

import 'package:gamedart/collider.dart';
import 'package:gamedart/enemy.dart';
import 'package:gamedart/game.dart';

class PlaneEnemy extends Enemy {
  final frames = <List<int>>[
    [0, 5],
    [0, 4],
    [1, 5],
    [0, 3],
    [1, 4],
    [2, 5],
    [0, 2],
    [1, 3],
    [2, 4],
    [3, 5],
    [0, 1],
    [1, 2],
    [2, 3],
    [3, 4],
    [4, 5],
    [0, 0],
    [1, 1],
    [2, 2],
    [3, 3],
    [4, 4],
  ];
  int _frame = 0;

  PlaneEnemy(Game game) : super(game) {
    source = querySelector('#enemy-plane') as CanvasImageSource;
    spriteWidth = 667 / 5;
    spriteHeight = 582 / 6;
    width = spriteWidth * 0.7;
    height = spriteHeight * 0.7;

    final maxY = (game.height * 0.7).toInt();
    y = Random.secure().nextInt(maxY).toDouble();
    vx = -(Random.secure().nextDouble() * 0.09 + 0.09);
    frameSpeed = 40;
  }

  @override
  Collider get collider {
    return Collider(
      x: x,
      y: y + 10,
      width: width - 35,
      height: height - 20,
    );
  }

  @override
  void update() {
    x += vx * game.deltaTime;
    y += vy * game.deltaTime;
    if (frameTimer > frameSpeed) {
      _frame++;
      if (_frame >= frames.length) {
        _frame = 0;
      }
      frameTimer = 0;
    } else {
      frameTimer += game.deltaTime;
    }

    frameX = frames[_frame][0];
    frameY = frames[_frame][1];
  }

  @override
  void draw() {
    game.context.drawImageScaledFromSource(
      source,
      frameX * (spriteWidth + 12),
      frameY * spriteHeight,
      spriteWidth,
      spriteHeight,
      x,
      y,
      width,
      height,
    );
  }
}
