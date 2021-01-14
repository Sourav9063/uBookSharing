import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredDialog extends StatelessWidget {
  const BlurredDialog(
      {Key key,
      @required this.height,
      @required this.width,
      this.blurColorWithOpacity = Colors.white30,
      this.child})
      : super(key: key);
  final double height;
  final double width;
  final Color blurColorWithOpacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: blurColorWithOpacity,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(16),
          //   color: blurColorWithOpacity,
          //   border: Border.all(color: Colors.white, width: 2)
          // ),
          height: height,
          width: width,
          child: Padding(padding: const EdgeInsets.all(8.0), child: child),
        ),
      ),
    );
  }
}
