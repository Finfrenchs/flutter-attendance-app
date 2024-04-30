import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_attendance_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_attendance_app/data/model/response/login_response_model.dart';
import 'package:flutter_attendance_app/ui/auth/bloc/update_user_register_face/update_user_register_face_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../../core/core.dart';
import '../../../data/model/ML/Recognition.dart';
import '../../../data/model/ML/Recognizer.dart';
import '../widgets/face_detector_painter.dart';
import 'attendance_success_page.dart';
import 'location_page.dart';

class RegisterFaceAttendancePage extends StatefulWidget {
  const RegisterFaceAttendancePage({super.key});

  @override
  State<RegisterFaceAttendancePage> createState() =>
      _RegisterFaceAttendancePageState();
}

class _RegisterFaceAttendancePageState
    extends State<RegisterFaceAttendancePage> {
  List<CameraDescription>? _availableCameras;
  late CameraDescription description = _availableCameras![1];
  CameraController? _controller;
  bool isBusy = false;
  late List<RecognitionEmbedding> recognitions = [];
  late Size size;
  CameraLensDirection camDirec = CameraLensDirection.front;

  //TODO declare face detectore
  late FaceDetector detector;

  //TODO declare face recognizer
  late Recognizer recognizer;

  @override
  void initState() {
    super.initState();

    //TODO initialize face detector
    detector = FaceDetector(
        options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast));

    //TODO initialize face recognizer
    recognizer = Recognizer();

    _initializeCamera();
    requestStoragePermission();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  _initializeCamera() async {
    _availableCameras = await availableCameras();
    _controller = CameraController(description, ResolutionPreset.high);
    await _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      // Mengatur ukuran kamera yang baru diinisialisasi
      size = _controller!.value.previewSize!;

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
    performFaceRecognition(faces);
  }

  img.Image? image;
  bool register = false;
  // TODO perform Face Recognition
  performFaceRecognition(List<Face> faces) async {
    recognitions.clear();

    //TODO convert CameraImage to Image and rotate it so that our frame will be in a portrait
    image = convertYUV420ToImage(frame!);
    image = img.copyRotate(image!,
        angle: camDirec == CameraLensDirection.front ? 270 : 90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      //TODO crop face
      img.Image croppedFace = img.copyCrop(image!,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt());

      //TODO pass cropped face to face recognition model
      RecognitionEmbedding recognition =
          recognizer.recognize(croppedFace, face.boundingBox);

      recognitions.add(recognition);

      //TODO show face registration dialogue
      if (register) {
        showFaceRegistrationDialogue(croppedFace, recognition);
        register = false;
      }
    }

    setState(() {
      isBusy = false;
      _scanResults = recognitions;
    });
  }

  //TODO Convert Uint8List to XFILE
  Future<XFile> convertToXFile(img.Image image, {String format = 'jpg'}) async {
    // Tentukan direktori sementara
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/temporary_file.$format';

    // Membuat file sementara di direktori sementara
    final tempFile = File(tempFilePath);

    // Ubah `img.Image` ke `jpeg` atau `png` berdasarkan parameter `format`
    if (format == 'jpg') {
      await tempFile.writeAsBytes(img.encodeJpg(image));
    } else if (format == 'png') {
      await tempFile.writeAsBytes(img.encodePng(image));
    }

    // Membuat objek `XFile` dari file sementara
    final xfile = XFile(tempFile.path);

    return xfile;
  }

//   Future<XFile> convertToXFile(Uint8List imageBytes) async {
//     // Dapatkan direktori sementara
//     final tempDir = await getTemporaryDirectory();
//     final tempFilePath = '${tempDir.path}/temporary_file.jpg';

//     // Membuat file sementara di direktori sementara
//     final tempFile = File(tempFilePath);
//     await tempFile.writeAsBytes(imageBytes);

//     // Membuat objek XFile dari file sementara
//     final xfile = XFile(tempFile.path);

//     return xfile;
// }

  Future<void> requestStoragePermission() async {
    // Periksa status izin penyimpanan
    var status = await Permission.storage.status;

    // Jika izin belum diberikan, minta izin
    if (!status.isGranted) {
      // Meminta izin
      status = await Permission.storage.request();

      // Periksa status izin setelah permintaan
      if (status.isGranted) {
        // Izin diberikan
        print("Izin penyimpanan diberikan.");
      } else {
        // Izin ditolak
        print("Izin penyimpanan ditolak.");
      }
    }
  }

  //TODO Face Registration Dialogue
  void showFaceRegistrationDialogue(
      img.Image croppedFace, RecognitionEmbedding recognition) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Face Registration", textAlign: TextAlign.center),
          alignment: Alignment.center,
          content: SizedBox(
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.memory(
                  Uint8List.fromList(img.encodeBmp(croppedFace)),
                  width: 200,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocConsumer<UpdateUserRegisterFaceBloc,
                      UpdateUserRegisterFaceState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        orElse: () {},
                        error: (message) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );
                          }
                        },
                        loaded: (responseModel) {
                          AuthLocalDataSource()
                              .reSaveAuthData(responseModel.user!);

                          Navigator.pop(context);
                          context
                              .pushReplacement(const AttendanceSuccessPage());
                        },
                      );
                    },
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return Button.filled(
                            width: 160,
                            height: 40,
                            onPressed: () async {
                              XFile imageFile = await convertToXFile(
                                  croppedFace,
                                  format: 'jpg');
                              final User user = User(
                                faceEmbedding: recognition.embeddings.join(','),
                                image: imageFile.path,
                              );
                              context.read<UpdateUserRegisterFaceBloc>().add(
                                    UpdateUserRegisterFaceEvent
                                        .updateUserRegisterFace(
                                      user,
                                      imageFile,
                                    ),
                                  );
                            },
                            label: 'Register',
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      );
    }
  }

  //ketika absen authdata->face_embedding compare dengan yang dari tflite.

  // TODO method to convert CameraImage to Image
  img.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width: width, height: height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final index = h * width + w;
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data!.setPixelR(w, h, yuv2rgb(y, u, v)); //= yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
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
    final camera = description;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(frame!.format.raw);

    final int bytesPerRow =
        frame?.planes.isNotEmpty == true ? frame!.planes.first.bytesPerRow : 0;

    final inputImageMetaData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: bytesPerRow,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, metadata: inputImageMetaData);

    return inputImage;
  }

  void _takePicture() async {
    await _controller!.takePicture();
    if (mounted) {
      setState(() {
        register = true;
      });
    }
  }

  void _reverseCamera() async {
    if (camDirec == CameraLensDirection.back) {
      camDirec = CameraLensDirection.front;
      description = _availableCameras![1];
    } else {
      camDirec = CameraLensDirection.back;
      description = _availableCameras![0];
    }
    await _controller!.stopImageStream();
    setState(() {
      _controller;
    });
    // Inisialisasi kamera dengan deskripsi kamera baru
    _initializeCamera();
  }

  // TODO Show rectangles around detected faces
  Widget buildResult() {
    if (_scanResults == null || !_controller!.value.isInitialized) {
      return const Center(child: Text('Camera is not initialized'));
    }
    final Size imageSize = Size(
      _controller!.value.previewSize!.height,
      _controller!.value.previewSize!.width,
    );
    CustomPainter painter =
        FaceDetectorPainter(imageSize, _scanResults, camDirec);
    return CustomPaint(
      painter: painter,
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              width: size.width,
              height: size.height,
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
            ),
            Positioned(
                top: 0.0,
                left: 0.0,
                width: size.width,
                height: size.height,
                child: buildResult()),
            Positioned(
              bottom: 5.0,
              left: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
            ),
          ],
        ),
      ),
    );
  }
}
