part of 'camera_cubit.dart';

abstract class CameraState {}

class CameraInitialState extends CameraState {}

class CameraInitializedState extends CameraState {}

class CameraAccessDenied extends CameraState {}

class CamerSwitchingState extends CameraState {}
class NoCameraState extends CameraState {}
