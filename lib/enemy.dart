import 'dart:html';
import 'dart:math';

import 'package:gamedart/collider.dart';
import 'package:gamedart/game.dart';
import 'package:gamedart/game_object.dart';

class Enemy extends GameObject {
  late CanvasImageSource source;

  Enemy(Game game) : super(game) {
    source = querySelector('#tank') as CanvasImageSource;
    spriteWidth = 600 / 3;
    spriteHeight = 200;
    width = spriteWidth * 0.7;
    height = spriteHeight * 0.7;
    x = game.width + 10;
    y = game.height - height + 47;
    vx = -(Random.secure().nextDouble() * 0.08 + 0.08);
    frameX = 0;
    frameSpeed = 120 - 120 * vx;
    frameTimer = 0;
  }

  @override
  void update() {
    super.update();
    if (x + width + 10 < 0) {
      active = false;
      //game.lives--;
    }
    if (frameTimer > frameSpeed) {
      frameTimer = 0;
      frameX++;
      if (frameX > 2) {
        frameX = 0;
      }
    } else {
      frameTimer += game.deltaTime;
    }
  }

  @override
  Collider get collider {
    return Collider(
      x: x + 42,
      y: y + 58,
      width: width - 60,
      height: height - 105,
    );
  }

  @override
  void draw() {
    if (!active) return;

    game.context.drawImageScaledFromSource(
      source,
      frameX * spriteWidth,
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
