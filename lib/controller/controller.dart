import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Controller extends ChangeNotifier {
  late SpriteComponent ball;
  late SpriteComponent player;
  late SpriteComponent enemy;
  late SpriteComponent goal;
  late ParallaxComponent grass;
  late ParallaxComponent crowd;

  late dynamic camera;
  double cameraPosition = 800.0;

  int kickable = 2;

  late double ballAcelleration;
  late int accelerationController;

  var random = Random();

  void kickBall() async {
    ballAcelleration = player.angle;
    accelerationController = (ballAcelleration.abs() * 20).toInt();

    grass.parallax?.baseVelocity = Vector2(accelerationController * 2.toDouble(), 0);
    crowd.parallax?.baseVelocity = Vector2(accelerationController / 2.toDouble(), 0);

    for (var i = 0; i < accelerationController; i++) {
      await Future.delayed(const Duration(milliseconds: 20), () {});
      ball.x = ball.x - ballAcelleration / 3;
      ball.y = ball.y + ballAcelleration / 3;
      camera.followVector2(Vector2(ball.x, 200));
    }

    await Future.delayed(Duration(milliseconds: accelerationController), () async {
      for (var i = 0; i < accelerationController; i++) {
        await Future.delayed(const Duration(milliseconds: 25), () {});
        ball.x = ball.x - ballAcelleration / 3;
        ball.y = ball.y - ballAcelleration / 3;
        camera.followVector2(Vector2(ball.x, 200));
      }
    });
    grass.parallax?.baseVelocity = Vector2.zero();
    crowd.parallax?.baseVelocity = Vector2.zero();
  }
}
