part of 'image_editor_cubit.dart';

abstract class ImageEditorState {}

class ImageEditorInitialState extends ImageEditorState {}

class ProcessingImageState extends ImageEditorState {}

class FaceExtractedState extends ImageEditorState {}
class MoreThanTwoFaceDetectedState extends ImageEditorState {}

