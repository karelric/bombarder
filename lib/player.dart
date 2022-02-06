import 'dart:html';
import 'dart:math';

import 'package:gamedart/bomb.dart';
import 'package:gamedart/collider.dart';
import 'package:gamedart/explosion.dart';
import 'package:gamedart/game.dart';
import 'package:gamedart/game_object.dart';

const speedfactor = 6;
const double maxAngle = 15.0;

class Player extends GameObject {
  late CanvasImageSource source;
  final double speed;
  var bombs = <Bomb>[];
  final int bombsInterval;
  double _bombsTimer = 0;
  Explosion? _explosion;
  bool _dead = false;
  bool _enter = false;
  double _angle = 0;

  Player(
    Game game, {
    this.speed = 0.025,
    this.bombsInterval = 1500,
  }) : super(game) {
    spriteWidth = 1000 / 4;
    spriteHeight = 116;
    width = spriteWidth * 0.5;
    height = spriteHeight * 0.5;
    x = 0 - width / 2 - 10;
    y = 80;
    vx = speed;
    vy = speed;
    source = querySelector('#plane') as CanvasImageSource;
  }

  bool get isDead => _dead;

  @override
  Collider get collider {
    return Collider(
      x: x + 10 - width / 2,
      y: y - height / 2,
      width: width - 12,
      height: height - 15,
    );
  }

  void explode({bool air = false}) {
    _dead = true;
    if (air) {
      _explosion ??= ExplosionAir(
        game,
        x: collider.x + collider.width * 0.75,
        y: collider.y + collider.height * 0.6,
      );
    } else {
      _explosion ??= Explosion(game, x: x + width * 0.25);
    }
  }

  void drop() {
    if (_bombsTimer > bombsInterval && !_dead) {
      bombs.add(Bomb(
        game,
        collider.x + collider.width / 2,
        collider.y + collider.height / 2,
      ));
      _bombsTimer = 0;
    }
  }

  @override
  void update() {
    if (collider.y + collider.height > game.height && _explosion == null) {
      explode();
    }

    _bombsTimer += game.deltaTime;
    bombs = bombs.where((b) => b.active).toList();
    for (var b in bombs) {
      b.update();
    }

    if (_explosion != null) {
      if (_explosion!.active) {
        _explosion!.update();
      } else {
        game.lose();
      }

      return;
    }

    if (game.canShoot) drop();

    if (frameTimer > frameSpeed) {
      frameX++;
      if (frameX > 3) frameX = 0;
      frameTimer = 0;
    } else {
      frameTimer += game.deltaTime;
    }

    if (game.isKeyUp) {
      vy = -speed * speedfactor;
    } else if (game.isKeyDown) {
      vy = speed * speedfactor;
    } else if (vy < 0) {
      vy = -speed;
    } else {
      vy = speed;
    }

    if (game.isKeyLeft && _enter) {
      vx = -speed * speedfactor;
    } else if (game.isKeyRight) {
      vx = speed * speedfactor;
    } else if (vx < 0) {
      vx = -speed;
    } else if (vx != 0) {
      vx = speed;
    }

    _angle = () {
      if (vy > speed) {
        return min(maxAngle, _angle + game.deltaTime * 0.1);
      } else if (vy < -speed) {
        return max(-maxAngle, _angle - game.deltaTime * 0.1);
      } else if (vy > 0) {
        if (_angle <= 0) return 0.0;
        return _angle - game.deltaTime * 0.15;
      } else if (vy < 0) {
        if (_angle >= 0) return 0.0;
        return _angle + game.deltaTime * 0.15;
      }
      return _angle;
    }();

    super.update();
    if (collider.x - 10 > 0) {
      _enter = true;
    }

    if (collider.x - 10 < 0 && _enter) {
      x = 0 + width / 2;
    }

    if (collider.x + collider.width > game.width && _enter) {
      x = game.width - width / 2;
      vx = -speed;
    }
    if (collider.y < 0) y = 0 + height / 2;
  }

  @override
  void draw() {
    for (var b in bombs) {
      b.draw();
    }

    if (_explosion != null) {
      _explosion!.draw();
      return;
    }

    game.context
      ..save()
      ..translate(x, y)
      ..rotate(pi / 180 * _angle)
      ..drawImageScaledFromSource(
        source,
        frameX * spriteWidth,
        0,
        spriteWidth,
        spriteHeight,
        0 - width / 2,
        0 - height / 2,
        width,
        height,
      )
      ..restore();
  }
}
