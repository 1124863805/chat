import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/**
 * 自定义快速写法
 */
class LT extends StatelessWidget {
  final String text;

  Color? color;

  double? fontSize;

  FontWeight? weight;

  double? left;
  double? top;
  double? right;
  double? bottom;
  int? maxLine;

  LT(
      {Key? key,
      required this.text,
      this.color,
      this.fontSize,
      this.weight,
      this.left,
      this.right,
      this.top,
      this.maxLine,
      this.bottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: left ?? 0,
          top: top ?? 0,
          right: right ?? 0,
          bottom: bottom ?? 0),
      child: new Text(
        text,
        style: new TextStyle(
          color: color ?? Colors.black,
          fontSize: fontSize == null ? 12.w : fontSize,
          fontWeight: weight ?? FontWeight.normal,
        ),
        maxLines: maxLine ?? null,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
