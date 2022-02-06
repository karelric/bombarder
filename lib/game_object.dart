import 'package:gamedart/collider.dart';
import 'package:gamedart/game.dart';

abstract class GameObject {
  final Game game;

  double x,
      y,
      vx,
      vy,
      width,
      height,
      spriteWidth,
      spriteHeight,
      frameSpeed,
      frameTimer;

  int frameX, frameY;

  bool active;

  GameObject(
    this.game, {
    this.x = 0,
    this.y = 0,
    this.vx = 0,
    this.vy = 0,
    this.width = 0,
    this.height = 0,
    this.spriteWidth = 0,
    this.spriteHeight = 0,
    this.frameX = 0,
    this.frameY = 0,
    this.frameSpeed = 0,
    this.frameTimer = 0,
    this.active = true,
  });

  Collider get collider => Collider(x: x, y: y, width: width, height: height);

  void update() {
    x += vx * game.deltaTime;
    y += vy * game.deltaTime;
  }

  void draw() {
    game.context.fillRect(x, y, width, height);
  }
}
