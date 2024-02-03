import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';

part 'image_editor_state.dart';

class ImageEditorCubit extends Cubit<ImageEditorState> {
  final String imageFilePath;
  ImageEditorCubit({required this.imageFilePath}) : super(ImageEditorInitialState()) {
    startFaceDetection();
  }

  List<Face> faces = [];
  ui.Image? image;

  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  Future<void> startFaceDetection() async {
    emit(ProcessingImageState());

    File loadedImage = await getImageFileFromAssets('images/user_image.jpeg');
    final data = await loadedImage.readAsBytes();
    await decodeImageFromList(data).then((value) => image = value);
    faceDetector.processImage(InputImage.fromFile(loadedImage)).then((faces) {
      faces = faces;
    });
    if (faces.length >= 2) {
      emit(MoreThanTwoFaceDetectedState());
      return;
    }
    emit(FaceExtractedState());
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }
}
