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

  final Map<int, Vector2> _dragPositions = {};
  double _previousDistance = 0;

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    _dragPositions[pointerId] = info.eventPosition.game;
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    _dragPositions.remove(pointerId);
  }

  @override
  void onDragCancel(int pointerId) {
    _dragPositions.remove(pointerId);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    _dragPositions[pointerId] = info.eventPosition.game;

    // If two fingers are on the screen, zoom in/out
    if (_dragPositions.length == 2) {
      final distance = _dragPositions.values.first.distanceTo(
        _dragPositions.values.last,
      );

      if (_previousDistance != 0) {
        if (distance < _previousDistance) {
          kamera.zoom = (kamera.zoom * 1.05).clamp(0.1, 5);
        }
        if (distance > _previousDistance) {
          kamera.zoom = (kamera.zoom * (1.0 / 1.05)).clamp(0.1, 5);
        }
      }
      _previousDistance = distance;
    } else {
      kamera.moveBy(
        Vector2.copy(-info.delta.game)
          ..rotate(kamera.viewfinder.angle)
          ..scale(1.0 / kamera.viewfinder.zoom),
      );
    }
  }
}
