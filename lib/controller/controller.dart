import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Controller extends ChangeNotifier {
  late SpriteComponent ball;
  late SpriteComponent player;
  late SpriteComponent line;
  late ParallaxComponent grass;

  int kickable = 0;

  late double ballAcelleration;
  late int accelerationController;

  var random = Random();

  void kickBall() async {
    ballAcelleration = player.angle;
    accelerationController = (ballAcelleration.abs() * 20).toInt();

    grass.parallax?.baseVelocity = Vector2(accelerationController.toDouble(), 0);

    for (var i = 0; i < accelerationController; i++) {
      await Future.delayed(const Duration(milliseconds: 100), () {});
      ball.x = ball.x - ballAcelleration * 5;
      ball.y = ball.y + ballAcelleration * 5;
    }
    await Future.delayed(Duration(milliseconds: accelerationController), () async {
      for (var i = 0; i < accelerationController; i++) {
        await Future.delayed(const Duration(milliseconds: 150), () {});
        ball.x = ball.x - ballAcelleration * 5;
        ball.y = ball.y - ballAcelleration * 5;
      }
    });
    grass.parallax?.baseVelocity = Vector2.zero();
  }
}
