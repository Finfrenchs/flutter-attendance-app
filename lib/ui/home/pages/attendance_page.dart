import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../core/core.dart';
import '../widgets/face_detector_painter.dart';
import 'attendance_success_page.dart';
import 'location_page.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<CameraDescription>? _availableCameras;
  CameraController? _controller;
  bool isBusy = false;

  //TODO declare face detector
  late FaceDetector detector;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    //TODO initialize face detector
    detector = FaceDetector(
        options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast));
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _initializeCamera() async {
    _availableCameras = await availableCameras();
    _initCamera(_availableCameras!.first);
  }

  void _initCamera(CameraDescription description) async {
    _controller = CameraController(description, ResolutionPreset.max);
    await _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller!.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          frame = image;
          doFaceDetectionOnFrame();
        }
      });
    });
  }

  //TODO face detection on a frame
  dynamic _scanResults;
  CameraImage? frame;
  doFaceDetectionOnFrame() async {
    //TODO convert frame into InputImage format
    InputImage inputImage = getInputImage();

    //TODO pass InputImage to face detection model and detect faces
    List<Face> faces = await detector.processImage(inputImage);

    for (Face face in faces) {
      print("Face location ${face.boundingBox}");
    }

    //TODO perform face recognition on detected faces
    //performFaceRecognition(faces);
    
  }

  //TODO convert CameraImage to InputImage
  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in frame!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(frame!.width.toDouble(), frame!.height.toDouble());
    final camera = _availableCameras;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera![1].sensorOrientation);
    // if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(frame!.format.raw);
    // if (inputImageFormat == null) return null;

    ///---------------THIS USE MLKIT VERSI 0.4.0--------------------
    // final planeData = frame!.planes.map(
    //   (Plane plane) {
    //     return InputImagePlaneMetadata(
    //       bytesPerRow: plane.bytesPerRow,
    //       height: plane.height,
    //       width: plane.width,
    //     );
    //   },
    // ).toList();

    // final inputImageData = InputImageData(
    //   size: imageSize,
    //   imageRotation: imageRotation!,
    //   inputImageFormat: inputImageFormat!,
    //   planeData: planeData,
    // );
    ///---------------THAT USE MLKIT VERSI 0.4.0--------------------

    ///---------------THIS USE MLKIT VERSI 0.9.0 (LATEST VERSION)--------------------
    final int bytesPerRow =
        frame?.planes.isNotEmpty == true ? frame!.planes.first.bytesPerRow : 0;

    final inputImageMetaData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: bytesPerRow,
    );

    ///---------------THAT USE MLKIT VERSI 0.9.0 (LATEST VERSION)--------------------

    final inputImage =
        InputImage.fromBytes(bytes: bytes, metadata: inputImageMetaData);

    return inputImage;
  }

  void _takePicture() async {
    await _controller!.takePicture();
    if (mounted) {
      context.pushReplacement(const AttendanceSuccessPage());
    }
  }

  void _reverseCamera() {
    final lensDirection = _controller!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _availableCameras!.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = _availableCameras!.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }
    _initCamera(newDescription);
  }

  // TODO Show rectangles around detected faces
  // Widget buildResult() {
  //   if (_scanResults == null || !_controller!.value.isInitialized) {
  //     return const Center(child: Text('Camera is not initialized'));
  //   }
  //   final Size imageSize = Size(
  //     _controller!.value.previewSize!.height,
  //     _controller!.value.previewSize!.width,
  //   );
  //   CustomPainter painter =
  //       FaceDetectorPainter(imageSize, _scanResults, );
  //   return CustomPaint(
  //     painter: painter,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          AspectRatio(
            aspectRatio: context.deviceWidth / context.deviceHeight,
            child: CameraPreview(_controller!),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.47),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Absensi Datang',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Kantor',
                            style: TextStyle(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push(const LocationPage());
                        },
                        child: Assets.images.seeLocation.image(height: 30.0),
                      ),
                    ],
                  ),
                ),
                const SpaceHeight(80.0),
                Row(
                  children: [
                    IconButton(
                      onPressed: _reverseCamera,
                      icon: Assets.icons.reverse.svg(width: 48.0),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _takePicture,
                      icon: const Icon(
                        Icons.circle,
                        size: 70.0,
                      ),
                      color: AppColors.red,
                    ),
                    const Spacer(),
                    const SpaceWidth(48.0)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
