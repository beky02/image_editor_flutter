import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_editor/components/app_bar.dart';
import 'package:flutter_image_editor/components/button.dart';
import 'package:flutter_image_editor/components/draggable_oval_shape.dart';
import 'package:flutter_image_editor/cubits/image_editor_cubit/image_editor_cubit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ImageEditorScreen extends StatefulWidget {
  const ImageEditorScreen({super.key});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  List<Widget> draggableBoxes = [];
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            )),
      ),
      body: BlocConsumer<ImageEditorCubit, ImageEditorState>(listener: (context, state) {
        log("FaceRecognitionCubit state -- $state");
        if (state is MoreThanTwoFaceDetectedState) {
          Flushbar(
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0.4),
            duration: const Duration(seconds: 4),
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            borderRadius: BorderRadius.circular(13),
            margin: const EdgeInsets.only(top: 100, left: 50, right: 50),
            messageText: const SizedBox(
              height: 69,
              child: Center(
                child: Text(
                  "2개 이상의 얼굴이 감지되었어요!",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ),
          ).show(context);
        }
      }, builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Screenshot(
                controller: screenshotController,
                child: Stack(
                  children: [
                    if (state is FaceExtractedState || state is MoreThanTwoFaceDetectedState)
                      FittedBox(
                          child: SizedBox(
                              width: context.read<ImageEditorCubit>().image?.width.toDouble(),
                              height: context.read<ImageEditorCubit>().image?.height.toDouble(),
                              child: RawImage(image: context.read<ImageEditorCubit>().image))),
                    // Draggable Box
                    ...draggableBoxes.toList(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/back.svg'),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '다시찍기',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (state is! MoreThanTwoFaceDetectedState)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomButton(
                          height: 60,
                          width: 60,
                          onPressed: () {
                            addDraggableOvalShape();
                          },
                          child: const Text(
                            '눈',
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        CustomButton(
                          height: 60,
                          width: 60,
                          onPressed: () {
                            addDraggableOvalShape(width: 75, height: 40);
                          },
                          child: const Text(
                            '입',
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 60,
                  ),
                  if (state is! MoreThanTwoFaceDetectedState)
                    CustomButton(
                        height: 40,
                        disabled: draggableBoxes.isEmpty,
                        onPressed: () {
                          _saveImage(context);
                        },
                        backgroundColor: const Color(0xFF7B8FF7),
                        child: const Text(
                          '저장하기',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                        )),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void addDraggableOvalShape({double? width, double? height}) {
    setState(() {
      draggableBoxes.add(
        DraggableOvalShape(
          key: UniqueKey(),
          width: width,
          height: height,
          position: const Offset(100.0, 100.0),
        ),
      );
    });
  }

  Future<void> _saveImage(BuildContext context) async {
    try {
      final capturedImage = await screenshotController.capture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/image.png').create();

      if (capturedImage != null) {
        await imagePath.writeAsBytes(capturedImage);
      }

      await GallerySaver.saveImage(imagePath.path);
    } catch (_) {}
  }
}
