import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/rendering.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class BallGame extends FlameGame with HasDraggableComponents, HasCollisionDetection {
  var context;
  var value;

  var distancer = 0;

  BallGame({required this.context, required this.value});

  @override
  Future<void> onLoad() async {
    value.crowd = await ParallaxComponent.load([
      ParallaxImageData("crowd.png"),
    ], size: size, baseVelocity: Vector2(0, 0), velocityMultiplierDelta: Vector2.all(2));

    add(value.crowd);

    final goalSprite = await Sprite.load("goal.png");
    final goalSize = Vector2(size[0] / 1.6, size[1]);
    value.goal = Goal(value: value)
      ..size = goalSize
      ..sprite = goalSprite
      ..position = Vector2(1000, 200)
      ..anchor = Anchor.center;

    add(value.goal);

    value.grass = await ParallaxComponent.load([
      ParallaxImageData("grass.png"),
    ],
        size: Vector2(size[0], size[1] / 4.5),
        position: Vector2(0, 325),
        baseVelocity: Vector2(0, 0),
        velocityMultiplierDelta: Vector2.all(2));

    add(value.grass);

    final whichPlayer = value.random.nextInt(4) + 1;
    final playerSprite = await Sprite.load("player$whichPlayer.png");
    final playerSize = Vector2(size[0] / 5, size[1] / 2.5);
    value.player = Player(value: value)
      ..size = playerSize
      ..sprite = playerSprite
      ..position = Vector2(50, 320)
      ..anchor = Anchor.center;

    add(value.player);

    value.camera = camera;
    for (var i = 0; i < 2; i++) {
      final enemySprite = await Sprite.load(
          whichPlayer != 4 ? "player${whichPlayer + 1}.png" : "player${whichPlayer - 1}.png");
      value.enemy = Enemy(value: value)
        ..size = playerSize
        ..sprite = enemySprite
        ..position = Vector2((500 + distancer).toDouble(), 320)
        ..anchor = Anchor.center;

      add(value.enemy);

      distancer = distancer + 150;
    }

    final ballSprite = await Sprite.load("ball.png");
    final ballSize = Vector2(size[0] / 7.5, size[1] / 5);
    value.ball = Ball(value: value)
      ..size = ballSize
      ..sprite = ballSprite
      ..position = Vector2(100, 370)
      ..anchor = Anchor.center;

    add(value.ball);

    final spriteSheet = SpriteSheet(image: await images.load("meter.png"), srcSize: Vector2(384, 384));

    value.meter1 = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 1);
    value.meter2 = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 1, to: 2);
    value.meter3 = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 2, to: 3);
    value.meter4 = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 3, to: 4);

    final meterSize = Vector2(size[0] / 6, size[1] / 2.5);
    value.meter = Meter(value: value)
      ..animation = value.meter1
      ..size = meterSize
      ..position = Vector2(150, 100);

    add(value.meter);
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (value.kickable == 2 && value.cameraPosition >= 300) {
      value.cameraPosition = value.cameraPosition - 10;
      camera.followVector2(Vector2(value.cameraPosition, 200));
    } else {
      value.kickable = 0;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (value.kickable == 0) {
      value.player.angle = value.player.angle + event.delta[1] / 20 + event.delta[0] / 20;
      switch (value.player.angle.round()) {
        case 0:
          value.meter.animation = value.meter1;
          break;
        case 1:
          value.meter.animation = value.meter2;
          break;
        case 2:
          value.meter.animation = value.meter3;
          break;
        case 3:
          value.meter.animation = value.meter4;
          break;
      }
    }
  }
}

class Player extends SpriteComponent with CollisionCallbacks, HasGameRef {
  dynamic value;

  Player({required this.value});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (value.player.angle < -0.1) {
      value.kickBall();
      value.kickable = 1;
    }
  }
}

class Enemy extends SpriteComponent with CollisionCallbacks {
  dynamic value;

  Enemy({required this.value});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox()..isSolid = true);
  }

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollision(intersectionPoints, other);
    while (value.ballAcelleration > 100) {
      value.ballAcelleration = value.ballAcelleration - 100;
    }
  }
}

class Ball extends SpriteComponent with CollisionCallbacks {
  dynamic value;

  Ball({required this.value});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox()..isSolid = true);
  }
}

class Meter extends SpriteAnimationComponent {
  dynamic value;

  Meter({required this.value});
}

class Goal extends SpriteComponent with CollisionCallbacks {
  dynamic value;

  Goal({required this.value});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox()..isSolid = true);
  }

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollision(intersectionPoints, other);
    while (value.ballAcelleration > 0.0) {
      value.ballAcelleration = value.ballAcelleration - 20;
    }
  }
}
