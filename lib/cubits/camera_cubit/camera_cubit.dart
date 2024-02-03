import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitialState()) {
    initCamera();
  }
  CameraController? cameraController;

  Future<void> initCamera() async {
    print("callled");
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      PermissionStatus cStatus = await Permission.camera.request();
    print("callled 1");

      if (cStatus.isDenied || cStatus.isPermanentlyDenied) {
    print("callled 2");

        return;
      }
    }

    List<CameraDescription> cameras = await availableCameras();
    print(cameras);
    // if (cameras.isEmpty) {
    //   emit(NoCameraState());
    //   return;
    // }
    print("jerrr");

    cameraController = CameraController(cameras[1], ResolutionPreset.max, enableAudio: true);

    try {
      await cameraController!.initialize();
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            emit(CameraAccessDenied());
            break;
          default:
            break;
        }
      }
    }
    print("jerrr 1");
    emit(CameraInitializedState());
  }
}
