import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sashimi/sashimi.dart';

class ExampleGame extends SashimiGame with KeyboardEvents, MultiTouchDragDetector {
  Set<LogicalKeyboardKey> _keysPressed = {};

  @override
  Color backgroundColor() => Colors.blueGrey;

  @override
  Future<void> onLoad() async {
    const double scale = 6;
    final position = Vector3(10, 10, 0);

    final model = Model(
      position: position,
      sliceSize: Vector2.all(16),
      size: Vector3(16, 16, 1),
      scale: Vector3(scale, scale, 1),
      angle: 45 * degrees2Radians,
      image: await images.load('BlueCar.png'),
      horizontalSlices: true,
    );

    await add(model);

    kamera
      ..follow(PositionComponent())
      ..viewfinder.zoom = 1;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    final rotateLeft = _keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final rotateRight = _keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final rotation = rotateLeft ? 1 : (rotateRight ? -1 : 0);
    kamera.rotation += rotation * dt;

    final zoomIn = _keysPressed.contains(LogicalKeyboardKey.keyZ);
    final zoomOut = _keysPressed.contains(LogicalKeyboardKey.keyX);
    final zoom = zoomIn ? 1 : (zoomOut ? -1 : 0);
    kamera.zoom = (kamera.zoom + zoom * dt).clamp(0.1, 5);

    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _keysPressed = keysPressed;
    return KeyEventResult.handled;
  }
}
