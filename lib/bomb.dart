import 'dart:html';

import 'package:gamedart/collider.dart';
import 'package:gamedart/explosion.dart';
import 'package:gamedart/game.dart';
import 'package:gamedart/game_object.dart';

const acc = 0.005;

class Bomb extends GameObject {
  late CanvasImageSource source;

  Explosion? _explosion;

  Bomb(Game game, double x, double y) : super(game, x: x, y: y) {
    source = querySelector('#bomb') as CanvasImageSource;
    width = 128 * 0.15;
    height = 192 * 0.15;
    vx = -0.02;
  }

  @override
  Collider get collider {
    return Collider(
      x: x,
      y: y,
      width: width,
      height: height,
    );
  }

  void explode({GameObject? target}) {
    if (target != null) {
      _explosion ??= ExplosionAir(
        game,
        x: target.collider.x + target.collider.width / 2,
        y: target.collider.y + target.collider.height / 2,
      );
    } else {
      _explosion ??= Explosion(game, x: x + width);
    }
  }

  @override
  void update() {
    super.update();
    vy += acc;
    if (y > game.height && _explosion == null) {
      explode();
    }

    if (_explosion != null) {
      _explosion!.update();
      if (!_explosion!.active) {
        active = false;
      }
    }
  }

  @override
  void draw() {
    if (!active) return;

    if (_explosion == null) {
      game.context.drawImageScaled(source, x, y, width, height);
    } else {
      _explosion!.draw();
    }
  }
}
