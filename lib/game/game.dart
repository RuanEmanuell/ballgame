import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';

import '../controller/controller.dart';

class BallGame extends FlameGame with HasDraggableComponents {
  var context;

  BallGame({required this.context});

  late SpriteComponent ball;
  late SpriteComponent player;
  late SpriteComponent line;

  late double ballAcelleration;

  var random = Random();

  void kickBall() {
    ballAcelleration = player.angle;
    ball.x = ball.x - ballAcelleration;
    ball.y = ball.y + ballAcelleration;
  }

  @override
  Future<void> onLoad() async {
    final ballSprite = await Sprite.load("ball.png");
    final ballSize = Vector2(size[0] / 5, size[1] / 3);
    ball = SpriteComponent(
        size: ballSize, sprite: ballSprite, position: Vector2(200, 350), anchor: Anchor.center);

    add(ball);

    final whichPlayer = random.nextInt(4) + 1;
    final playerSprite = await Sprite.load("player$whichPlayer.png");
    final playerSize = Vector2(size[0] / 3, size[1] / 1.5);
    player = SpriteComponent(
        size: playerSize, sprite: playerSprite, position: Vector2(100, 275), anchor: Anchor.center);

    add(player);

    final lineSprite = await Sprite.load("line.png");
    final lineSize = Vector2(size[0] / 3, size[1] / 1.5);
    line = SpriteComponent(
        size: lineSize, sprite: lineSprite, position: Vector2(370, 300), anchor: Anchor.center);
  }

  @override
  void render(canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    ball.angle = ball.angle + 0.2;

    line.angle = player.angle;

    if (player.angle <= 0.5) {
      kickBall();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    player.angle = player.angle + event.delta[1] / 20 + event.delta[0] / 20;
  }
}
