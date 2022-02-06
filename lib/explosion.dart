import 'dart:html';

import 'package:gamedart/game.dart';
import 'package:gamedart/game_object.dart';

class Explosion extends GameObject {
  late CanvasImageSource source;
  late AudioElement audio;

  Explosion(Game game, {double? x, double? y}) : super(game) {
    source = querySelector('#explosion') as CanvasImageSource;
    audio = AudioElement('assets/explosion.wav');
    spriteWidth = 1000 / 10;
    spriteHeight = 500 / 5;
    width = spriteWidth * 1.2;
    height = spriteHeight * 1.2;
    frameSpeed = 50;
    vx = -0.05;
    if (x != null) {
      this.x = x - width / 2;
    } else {
      this.x = game.width / 2 - width / 2;
    }
    if (y != null) {
      this.y = y - height / 2;
    } else {
      this.y = game.height - height;
    }
  }

  @override
  void update() {
    if (frameX == 0 && frameY == 0) audio.play();

    if (frameTimer > frameSpeed) {
      frameTimer = 0;
      frameX++;
      if (frameX > 9) {
        frameX = 0;
        frameY++;
        if (frameY > 4) {
          frameY = 0;
          active = false;
        }
      }
    } else {
      frameTimer += game.deltaTime;
    }
    super.update();
  }

  @override
  void draw() {
    if (!active) return;
    game.context.drawImageScaledFromSource(
      source,
      frameX * spriteWidth,
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

class ExplosionAir extends Explosion {
  ExplosionAir(Game game, {double? x, double? y}) : super(game) {
    source = querySelector('#explosion2') as CanvasImageSource;
    spriteWidth = 1000 / 10;
    spriteHeight = 600 / 6;
    width = spriteWidth * 1;
    height = spriteHeight * 1;
    frameSpeed = 1;
    if (x != null) {
      this.x = x - width / 2;
    } else {
      this.x = game.width / 2 - width / 2;
    }
    if (y != null) {
      this.y = y - height / 2;
    } else {
      this.y = game.height - height;
    }
    vx = -0.03;
  }

  @override
  void update() {
    if (frameX == 0 && frameY == 0) audio.play();

    if (frameTimer > frameSpeed) {
      frameTimer = 0;
      frameX++;
      if (frameX > 9) {
        frameX = 0;
        frameY++;
        if (frameY > 5) {
          frameY = 0;
          active = false;
        }
      }
    } else {
      frameTimer += game.deltaTime;
    }
    x += vx * game.deltaTime;
    y += vy * game.deltaTime;
  }
}
