import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class BallGame extends FlameGame {
  late SpriteComponent ball;
  late SpriteComponent player;

  var random = Random();

  @override
  Future<void> onLoad() async {
    final ballSprite = await Sprite.load("ball.png");
    final ballSize = Vector2(size[0] / 5, size[1] / 3);
    ball = SpriteComponent(
        size: ballSize, 
        sprite: ballSprite, 
        position: Vector2(200, 350), 
        anchor: Anchor.center);

    add(ball);

    final whichPlayer = random.nextInt(4) + 1;
    final playerSprite = await Sprite.load("player$whichPlayer.png");
    final playerSize = Vector2(size[0] / 3, size[1] / 1.5);
    player = SpriteComponent(
        size: playerSize, 
        sprite: playerSprite, 
        position: Vector2(100, 275), 
        anchor: Anchor.center);

    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    ball.angle = ball.angle + 0.1;
  }
}
