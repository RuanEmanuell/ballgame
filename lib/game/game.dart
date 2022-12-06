import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/controller.dart';

class BallGame extends FlameGame with HasDraggableComponents, HasCollisionDetection {
  var context;
  var value;

  BallGame({required this.context, required this.value});

  @override
  Future<void> onLoad() async {
    final ballSprite = await Sprite.load("ball.png");
    final ballSize = Vector2(size[0] / 5, size[1] / 3);
    value.ball = Ball(value: value)
      ..size = ballSize
      ..sprite = ballSprite
      ..position = Vector2(200, 350)
      ..anchor = Anchor.center;

    add(value.ball);

    final whichPlayer = value.random.nextInt(4) + 1;
    final playerSprite = await Sprite.load("player$whichPlayer.png");
    final playerSize = Vector2(size[0] / 3, size[1] / 1.5);
    value.player = Player(value: value)
      ..size = playerSize
      ..sprite = playerSprite
      ..position = Vector2(50, 300)
      ..anchor = Anchor.center;

    add(value.player);

    final lineSprite = await Sprite.load("line.png");
    final lineSize = Vector2(size[0] / 3, size[1] / 1.5);
    value.line = SpriteComponent(
        size: lineSize, sprite: lineSprite, position: Vector2(370, 300), anchor: Anchor.center);

    camera.followComponent(value.ball);
  }

  @override
  void render(canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    value.line.angle = value.player.angle;
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
    debugColor = Colors.blue;
    debugMode = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
  }
}

class Ball extends SpriteComponent with CollisionCallbacks {
  dynamic value;

  Ball({required this.value});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
    debugColor = Colors.red;
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
