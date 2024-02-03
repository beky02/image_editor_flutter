import 'package:flutter/material.dart';
import 'package:flutter_image_editor/painter/oval_painter.dart';

class DraggableOvalShape extends StatefulWidget {
  final Offset position;
  final double? width;
  final double? height;

  const DraggableOvalShape({Key? key, required this.position, this.width, this.height})
      : super(key: key);

  @override
  _DraggableOvalShapeState createState() => _DraggableOvalShapeState();
}

class _DraggableOvalShapeState extends State<DraggableOvalShape> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        child: CustomPaint(
          painter: OvalPainter(),
          child: SizedBox(
            width: widget.width ?? 50,
            height: widget.height ?? 20,
          ),
        ),
      ),
    );
  }
}
