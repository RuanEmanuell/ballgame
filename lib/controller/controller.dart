import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Controller extends ChangeNotifier {
  late SpriteComponent ball;
  late SpriteComponent player;
  late SpriteComponent enemy;
  late SpriteComponent line;
  late ParallaxComponent grass;
  late ParallaxComponent crowd;

  late dynamic camera;
  double cameraPosition = 2000.0;

  int kickable = 2;

  late double ballAcelleration;
  late int accelerationController;

  var random = Random();

  void kickBall() async {
    ballAcelleration = player.angle;
    accelerationController = (ballAcelleration.abs() * 20).toInt();

    grass.parallax?.baseVelocity = Vector2(accelerationController * 2.toDouble(), 0);
    crowd.parallax?.baseVelocity = Vector2(accelerationController / 2.toDouble(), 0);

    if (ballAcelleration <= -0.6) {
      camera.zoom++;
    }

    for (var i = 0; i < accelerationController; i++) {
      await Future.delayed(const Duration(milliseconds: 100), () {});
      ball.x = ball.x - ballAcelleration * 5;
      ball.y = ball.y + ballAcelleration * 5;
      camera.followVector2(Vector2(ball.x, 200));
    }
    if (ballAcelleration <= -0.6) {
      Future.delayed(const Duration(milliseconds: 200), () {
        camera.zoom--;
      });
    }

    await Future.delayed(Duration(milliseconds: accelerationController), () async {
      for (var i = 0; i < accelerationController; i++) {
        await Future.delayed(const Duration(milliseconds: 125), () {});
        ball.x = ball.x - ballAcelleration * 5;
        ball.y = ball.y - ballAcelleration * 5;
        camera.followVector2(Vector2(ball.x, 200));
      }
    });
    grass.parallax?.baseVelocity = Vector2.zero();
    crowd.parallax?.baseVelocity = Vector2.zero();
  }
}
