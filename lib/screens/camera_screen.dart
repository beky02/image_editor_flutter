import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_editor/components/app_bar.dart';
import 'package:flutter_image_editor/cubits/camera_cubit/camera_cubit.dart';
import 'package:flutter_image_editor/cubits/image_editor_cubit/image_editor_cubit.dart';
import 'package:flutter_image_editor/screens/image_editor_screen.dart';
import 'package:flutter_svg/svg.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(builder: (context, state) {
      if (state is CameraInitialState) {
        return const Scaffold(
          body: Center(
            child: SizedBox(
                width: 40,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                )),
          ),
        );
      }

      if (state is CameraInitializedState) {
        CameraController? cameraController = context.read<CameraCubit>().cameraController;
        return Scaffold(
          appBar: CustomAppBar(),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Transform.scale(
                    scale: 1.2,
                    child: Center(
                      child: CameraPreview(
                        cameraController!,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(color: Colors.black),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          cameraController.takePicture().then((image) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlocProvider<ImageEditorCubit>(
                                        create: (context) =>
                                            ImageEditorCubit(imageFilePath: image.path),
                                        child: const ImageEditorScreen())));
                          });
                        },
                        child: SvgPicture.asset('assets/icons/camera_button.svg')),
                    const SizedBox(
                      height: 70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('assets/icons/image.svg'),
                        SvgPicture.asset('assets/icons/switch_camera.svg'),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
