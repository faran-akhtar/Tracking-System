import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Helpers{
   static Widget assetImage(
    String? path, {
    Color? color,
    double? width,
    double? height,
    BoxFit boxFit = BoxFit.contain,
    BlendMode? blendMode,
  }) {
    if (path != null) {
      if (path.endsWith('.svg')) {
        return SvgPicture.asset(
          path,
          width: width,
          height: height,
          fit: boxFit,
          color: color,
        );
      } else if (path.endsWith('.png') ||
          path.endsWith('.jpg') ||
          path.endsWith('.gif')) {
        return Image.asset(
          path,
          width: width,
          height: height,
          fit: boxFit,
          color: color,
          colorBlendMode: blendMode,
        );
      }
    }
    return const SizedBox.shrink();
  }


   static showToast({
    required BuildContext context,
    required String title,
  }) {
    Fluttertoast.showToast(
      msg: title,
    );
  }
}