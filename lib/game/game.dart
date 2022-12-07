import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class BallGame extends FlameGame with HasDraggableComponents, HasCollisionDetection {
  var context;
  var value;

  BallGame({required this.context, required this.value});

  @override
  Future<void> onLoad() async {
    value.crowd = await ParallaxComponent.load([
      ParallaxImageData("crowd.png"),
    ], size: size, baseVelocity: Vector2(0, 0), velocityMultiplierDelta: Vector2.all(2));

    add(value.crowd);

    final whichPlayer = value.random.nextInt(4) + 1;
    final playerSprite = await Sprite.load("player$whichPlayer.png");
    final playerSize = Vector2(size[0] / 3, size[1] / 1.5);
    value.player = Player(value: value)
      ..size = playerSize
      ..sprite = playerSprite
      ..position = Vector2(50, 275)
      ..anchor = Anchor.center;

    add(value.player);

    value.grass = await ParallaxComponent.load([
      ParallaxImageData("grass.png"),
    ],
        size: Vector2(size[0], size[1] / 3),
        position: Vector2(0, 325),
        baseVelocity: Vector2(0, 0),
        velocityMultiplierDelta: Vector2.all(2));

    add(value.grass);

    final ballSprite = await Sprite.load("ball.png");
    final ballSize = Vector2(size[0] / 5, size[1] / 3);
    value.ball = Ball(value: value)
      ..size = ballSize
      ..sprite = ballSprite
      ..position = Vector2(200, 360)
      ..anchor = Anchor.center;

    add(value.ball);

    final lineSprite = await Sprite.load("line.png");
    final lineSize = Vector2(size[0] / 3, size[1] / 1.5);
    value.line = SpriteComponent(
        size: lineSize, sprite: lineSprite, position: Vector2(370, 300), anchor: Anchor.center);

    value.camera = camera;

    final enemySprite = await Sprite.load(
        whichPlayer != 4 ? "player${whichPlayer + 1}.png" : "player${whichPlayer - 1}.png");
    value.enemy = Enemy(value: value)
      ..size = playerSize
      ..sprite = enemySprite
      ..position = Vector2(2000, 275)
      ..anchor = Anchor.center;

    add(value.enemy);
  }

  @override
  void update(double dt) {
    super.update(dt);
    value.line.angle = value.player.angle;

    if (value.kickable == 2 && value.cameraPosition >= 200) {
      value.cameraPosition = value.cameraPosition - 10;
      camera.followVector2(Vector2(value.cameraPosition, 200));
    } else {
      value.kickable = 0;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (value.kickable < 1) {
      value.player.angle = value.player.angle + event.delta[1] / 20 + event.delta[0] / 20;
    }
  }
}

class Player extends SpriteComponent with CollisionCallbacks {
  dynamic value;

  Player({required this.value});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }
}

class Enemy extends SpriteComponent with CollisionCallbacks {
  dynamic value;

  Enemy({required this.value});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }
}

class Ball extends SpriteComponent with CollisionCallbacks {
  dynamic value;

  Ball({required this.value});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
    debugMode = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (value.player.angle < -0.1) {
      value.kickable = 1;
      value.kickBall();
    }
  }
}
