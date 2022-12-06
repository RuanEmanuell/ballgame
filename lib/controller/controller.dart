import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Controller extends ChangeNotifier {
  late SpriteComponent ball;
  late SpriteComponent player;
  late SpriteComponent line;

  int kickable = 0;

  late double ballAcelleration;

  var random = Random();

  void kickBall() async {
    ballAcelleration = player.angle;
    for (var i = 0; i < ballAcelleration.abs() * 20; i++) {
      await Future.delayed(Duration(milliseconds: 100), () {});
      ball.x = ball.x - ballAcelleration * 10;
      ball.y = ball.y + ballAcelleration * 10;
    }
    Future.delayed(Duration(milliseconds: (ballAcelleration * 20).toInt()), () async {
      for (var i = 0; i < ballAcelleration.abs() * 20; i++) {
        await Future.delayed(Duration(milliseconds: 100), () {});
        ball.x = ball.x - ballAcelleration * 10;
        ball.y = ball.y - ballAcelleration * 10;
      }
    });
  }
}
