import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final Color? borderColor;
  final String? text;
  final Color? colorText;
  final double? fontSize;

  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final Function? onTap;
  final Alignment? alignment;

  PrimaryButton({
    Key? key,
    this.height,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.text,
    this.colorText,
    this.fontSize,
    this.left,
    this.right,
    this.top,
    this.bottom,
    this.onTap,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: InkResponse(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Container(
            margin: EdgeInsets.only(
              top: top ?? 0,
              left: left ?? 0,
              right: right ?? 0,
              bottom: bottom ?? 0,
            ),
            height: height,
            decoration: BoxDecoration(
                color: color != null ? color : null,
                border: Border.all(color: borderColor ?? Colors.transparent),
                borderRadius:
                    borderRadius ?? BorderRadius.all(Radius.circular(8))),
            alignment: alignment ?? Alignment.center,
            child: new Text(
              "${text ?? ""}",
              style: TextStyle(
                  color: colorText ?? Colors.white, fontSize: fontSize ?? 16.w),
            ),
          ),
        ))
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
//
// class PrimaryButton extends StatelessWidget {
//   final String? text;
//   final double? width;
//   final double? height;
//   final Color? color;
//   final Decoration? decoration;
//   final Decoration? disableDecoration;
//   final PrimaryButtonIconPosition iconPosition;
//   final Widget? icon;
//   final double? innerSpace;
//   final EdgeInsets? padding;
//   final EdgeInsets? margin;
//   final TextStyle? textStyle;
//   final TextStyle? disableTextStyle;
//   final GestureTapCallback? onTap;
//   final bool disable;
//   final bool multiline;
//
//   PrimaryButton({
//     Key? key,
//     this.width,
//     this.height,
//     this.icon,
//     this.text,
//     this.color,
//     this.decoration,
//     this.disableDecoration,
//     this.padding,
//     this.margin,
//     this.iconPosition = PrimaryButtonIconPosition.left,
//     this.innerSpace = 8,
//     this.textStyle,
//     this.disableTextStyle,
//     this.onTap,
//     this.disable = false,
//     this.multiline = false,
//   }) : super(key: key);
//
//   PrimaryButton.ghost({
//     Key? key,
//     this.width,
//     this.height,
//     this.icon,
//     this.text,
//     this.padding,
//     this.margin,
//     this.iconPosition = PrimaryButtonIconPosition.left,
//     this.innerSpace = 2,
//     this.onTap,
//     this.disable = false,
//     this.multiline = false,
//     this.textStyle,
//     this.disableTextStyle,
//     double fontSize = 17,
//   })  : assert(text != null || icon != null),
//         this.color = null,
//         this.decoration = BoxDecoration(
//           border: Border.all(color: textStyle?.color ?? Colors.black),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         this.disableDecoration = BoxDecoration(
//           border: Border.all(color: disableTextStyle?.color ?? Colors.black),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Container(
//         width: this.width,
//         height: this.height,
//         padding: this.padding,
//         margin: this.margin,
//         color: this.color,
//         decoration: disable ? this.disableDecoration ?? this.decoration : this.decoration,
//         child: buildChilds(context),
//       ),
//       onTap: disable ? null : this.onTap,
//     );
//   }
//
//   Widget buildChilds(BuildContext context) {
//     Widget textLabel;
//     double innerSpace;
//     if (this.text is String && this.text!.isNotEmpty) {
//       textLabel = Text(
//         this.text!,
//         style: disable ? disableTextStyle ?? textStyle : textStyle,
//         textAlign: TextAlign.center,
//         overflow: TextOverflow.ellipsis,
//       );
//       if (this.multiline == true) textLabel = Flexible(child: textLabel);
//       innerSpace = this.innerSpace ?? 0;
//     } else {
//       textLabel = Container();
//       innerSpace = 0;
//     }
//
//     List<Widget> children = [];
//
//     if (icon is Widget) {
//       children.add(icon!);
//       switch (iconPosition) {
//         case PrimaryButtonIconPosition.top:
//           children.addAll([SizedBox(height: innerSpace), textLabel]);
//           break;
//         case PrimaryButtonIconPosition.right:
//           children.insertAll(0, [textLabel, SizedBox(width: innerSpace)]);
//           break;
//         case PrimaryButtonIconPosition.bototm:
//           children.insertAll(0, [textLabel, SizedBox(height: innerSpace)]);
//           break;
//         case PrimaryButtonIconPosition.left:
//           children.addAll([SizedBox(width: innerSpace), textLabel]);
//           break;
//       }
//     } else {
//       children.addAll([textLabel]);
//     }
//
//     return Flex(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       direction: iconPosition == PrimaryButtonIconPosition.left || iconPosition == PrimaryButtonIconPosition.right ? Axis.horizontal : Axis.vertical,
//       children: children,
//     );
//   }
// }
//
// enum PrimaryButtonIconPosition {
//   top,
//   right,
//   bototm,
//   left,
// }
