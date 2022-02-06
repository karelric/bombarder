import 'dart:html';
import 'dart:math';

import 'package:gamedart/background.dart';
import 'package:gamedart/enemy.dart';
import 'package:gamedart/plane_enemy.dart';
import 'package:gamedart/player.dart';

typedef GameOver = void Function(Game game);

class Game {
  late CanvasElement canvas;
  late CanvasRenderingContext2D context;
  late Player player;
  late Background background;

  AudioElement? theme;
  double _lastTime = 0;
  double _deltaTime = 1;

  final _enemies = <Enemy>[];
  final int _enemyInterval = 5000;
  double _enemyTimer = 0;
  int score = 0;
  bool _gameOver = true;
  GameOver? onGameOver;

  // ignore: prefer_collection_literals
  final _keys = Set<int>();

  Game({this.onGameOver}) {
    canvas = querySelector('#canvas') as CanvasElement;
    canvas
      ..width = canvas.clientWidth
      ..height = canvas.clientHeight;
    context = canvas.getContext('2d') as CanvasRenderingContext2D;

    window.onClick.listen((_) {
      if (!_gameOver) player.drop();
    });
    window.onKeyDown.listen((e) {
      if (e.keyCode == KeyCode.UP ||
          e.keyCode == KeyCode.DOWN ||
          e.keyCode == KeyCode.LEFT ||
          e.keyCode == KeyCode.RIGHT ||
          e.keyCode == KeyCode.SPACE) {
        _keys.add(e.keyCode);
      }
    });
    window.onKeyUp.listen((e) {
      if (e.keyCode == KeyCode.UP ||
          e.keyCode == KeyCode.DOWN ||
          e.keyCode == KeyCode.LEFT ||
          e.keyCode == KeyCode.RIGHT ||
          e.keyCode == KeyCode.SPACE) {
        _keys.remove(e.keyCode);
      }
    });
  }
  bool get isKeyUp => _keys.contains(KeyCode.UP);
  bool get isKeyDown => _keys.contains(KeyCode.DOWN);
  bool get isKeyLeft => _keys.contains(KeyCode.LEFT);
  bool get isKeyRight => _keys.contains(KeyCode.RIGHT);
  bool get canShoot => _keys.contains(KeyCode.SPACE);

  double get width => (canvas.width ?? 0).toDouble();

  double get height => (canvas.height ?? 0).toDouble();

  double get deltaTime => _deltaTime;

  Future<void> start() async {
    _gameOver = false;
    _enemyTimer = 0;
    background = Background(this);
    player = Player(this);
    _enemies.clear();
    score = 0;
    _deltaTime = 1;
    _lastTime = 0;
    update(0);
  }

  void createEnemy() {
    if (_enemyTimer > _enemyInterval) {
      final ran = Random.secure().nextInt(2);
      if (ran == 0) {
        _enemies.add(PlaneEnemy(this));
      } else {
        _enemies.add(Enemy(this));
      }

      _enemyTimer = 0;
    } else {
      _enemyTimer += deltaTime;
    }
  }

  void update(double timestamp) {
    if (_gameOver) {
      onGameOver?.call(this);
      return;
    }

    try {
      if (_lastTime > 0) _deltaTime = timestamp - _lastTime;
      _lastTime = timestamp;

      background.update();
      checkColition();
      createEnemy();
      _enemies.removeWhere((e) => !e.active);
      for (var e in _enemies) {
        e.update();
      }
      player.update();

      context.clearRect(0, 0, width, height);
      background.draw();
      for (var e in _enemies) {
        e.draw();
      }
      player.draw();
      drawUi();
    } catch (e) {
      window.console.error(e);
    } finally {
      window.requestAnimationFrame((n) => update(n.toDouble()));
    }
  }

  void clear() => context.clearRect(0, 0, width, height);

  void lose() => _gameOver = true;

  void checkColition() {
    for (var e in _enemies) {
      if (!player.isDead && player.collider.checkCollition(e.collider)) {
        player.explode(air: true);
        e.active = false;
        return;
      }

      for (var b in player.bombs) {
        if (b.collider.checkCollition(e.collider)) {
          score++;
          b.explode(target: e);
          e.active = false;
        }
      }
    }
  }

  void drawUi() {
    final fps = (1000 / deltaTime).round();
    context
      ..save()
      ..font = '20px -apple-system, Roboto, Helvetica, serif'
      ..fillStyle = '#000000'
      ..fillText('Score: $score', 15, 31)
      ..fillStyle = '#ffffff'
      ..fillText('Score: $score', 16, 32)
      //
      ..font = '16px -apple-system, Roboto, Helvetica, serif'
      ..fillStyle = '#000000'
      ..fillText('fps: $fps', 15, 50)
      ..fillStyle = '#ffffff'
      ..fillText('fps: $fps', 16, 51)
      ..restore();
  }

  Future<void> playSound() async {
    final isPaused = theme?.paused ?? true;
    if (!isPaused) return;

    try {
      theme = AudioElement('assets/theme.ogg')..loop = true;
      await theme!.play();
    } catch (e) {
      window.onClick.first.then((_) => playSound());
      window.onKeyDown.first.then((_) => playSound());
    }
  }
}
