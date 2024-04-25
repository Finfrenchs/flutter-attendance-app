import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../data/model/ML/Recognition.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
    this.absoluteImageSize,
    this.faces,
    this.camDire2,
  );

  final Size absoluteImageSize;
  // final List<Face> faces;
  final List<Recognition> faces;
  CameraLensDirection camDire2;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.indigoAccent;

    // for (Face face in faces) {
    for (Recognition face in faces) {
      // canvas.drawRect(
      //   Rect.fromLTRB(
      //     camDire2 == CameraLensDirection.front
      //         ? (absoluteImageSize.width - face.boundingBox.right) * scaleX
      //         : face.boundingBox.left * scaleX,
      //     face.boundingBox.top * scaleY,
      //     camDire2 == CameraLensDirection.front
      //         ? (absoluteImageSize.width - face.boundingBox.left) * scaleX
      //         : face.boundingBox.right * scaleX,
      //     face.boundingBox.bottom * scaleY,
      //   ),
      //   paint,
      canvas.drawRect(
        Rect.fromLTRB(
          camDire2 == CameraLensDirection.front
              ? (absoluteImageSize.width - face.location.right) * scaleX
              : face.location.left * scaleX,
          face.location.top * scaleY,
          camDire2 == CameraLensDirection.front
              ? (absoluteImageSize.width - face.location.left) * scaleX
              : face.location.right * scaleX,
          face.location.bottom * scaleY,
        ),
        paint,
      );

      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 20),
          text: "${face.name}  ${face.distance.toStringAsFixed(2)}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas,
          Offset(face.location.left * scaleX, face.location.top * scaleY));
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return true;
  }
}
