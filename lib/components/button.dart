import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final Color? backgroundColor;
  final Color? disableColor;
  final Widget? child;
  final double? width;
  final double? height;
  final bool disabled;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.disabled = false,
    this.disableColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: disabled ? const Color(0xFFD3D3D3) : backgroundColor ?? Colors.white,
      child: Container(
        width: width ?? size.width,
        height: height ?? size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(onTap: disabled ? null : onPressed, child: Center(child: child)),
      ),
    );
  }
}
