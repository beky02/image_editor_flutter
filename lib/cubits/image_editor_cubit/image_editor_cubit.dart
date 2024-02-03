import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

part 'image_editor_state.dart';

class ImageEditorCubit extends Cubit<ImageEditorState> {
  final String imageFilePath;
  ImageEditorCubit({required this.imageFilePath}) : super(ImageEditorInitialState()) {
    startFaceDetection();
  }
  ui.Image? image;
  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  Future<void> startFaceDetection() async {
    emit(ProcessingImageState());

    File image = File(imageFilePath);
    final data = await image.readAsBytes();
    await decodeImageFromList(data).then((value) => image = image);
    List<Face> faces = await faceDetector.processImage(InputImage.fromFile(image));
    if (faces.length >= 2) {
      emit(MoreThanTwoFaceDetectedState());
      return;
    }
    emit(FaceExtractedState());
  }
}
