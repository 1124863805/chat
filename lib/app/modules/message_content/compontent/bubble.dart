import 'dart:convert';

import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/cust_widget.dart';
import 'package:chat/app/widgets/custom_text.dart';
import 'package:chat/app/widgets/primary_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const _ArrowWidth = 7.0; //箭头宽度
const _ArrowHeight = 10.0; //箭头高度
const _MinHeight = 44.0; //内容最小高度
const _MinWidth = 50.0; //内容最小宽度

class Bubble extends StatelessWidget {
  final BubbleDirection? direction;
  final Radius? borderRadius;
  final Widget? child;
  final BoxDecoration? decoration;

  final Color? color;
  final double _left;
  final double _right;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Alignment? alignment;
  final String head;
  final String myHead;
  final String action;
  final String content;

  final int unread;

  final String userId;

  Bubble(
      {Key? key,
      this.direction,
      this.borderRadius,
      this.child,
      this.decoration,
      this.padding,
      this.margin,
      this.constraints,
      this.width,
      this.height,
      this.alignment,
      this.color,
      required this.head,
      required this.myHead,
      required this.action,
      required this.content,
      required this.unread,
      required this.userId})
      : _left = direction == BubbleDirection.left ? _ArrowWidth : 0.01,
        _right = direction == BubbleDirection.right ? _ArrowWidth : 0.02,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: direction != BubbleDirection.left
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: direction != BubbleDirection.left
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (direction == BubbleDirection.left)
                InkResponse(
                  onTap: () {
                    // Get.toNamed(Routes.MERCHANT, arguments: userId);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 7),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: PrimaryNetworkImage(
                        head,
                        width: 38,
                        height: 38,
                      ),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // if (direction == BubbleDirection.right)
                    // LT(
                    //   text: unread > 0 ? '已读' : '未读',
                    //   bottom: 10,
                    //   right: 10,
                    //   left: 10,
                    // ),
                  getContent(context, action),
                  // if (direction == BubbleDirection.left)
                  //   LT(
                  //     text: unread > 0 ? '已读' : '未读',
                  //     bottom: 10,
                  //     right: 10,
                  //     left: 10,
                  //   ),
                ],
              ),
              if (direction == BubbleDirection.right)
                Container(
                  margin: EdgeInsets.only(left: 7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: PrimaryNetworkImage(
                      myHead,
                      width: 38,
                      height: 38,
                    ),
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget getContent(BuildContext context, String action) {
    if (action == "3") {
      dynamic map = json.decode(content);
      return SizedBox(
        width:
            MediaQuery.of(context).size.width * 0.42 - 10, // 45% of total width
        child: AspectRatio(
          aspectRatio: 1.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: InkResponse(
                onTap: () {
                  LPhotoView.toPhotoViewGallery(context, [map["url"]]);
                },
                child: PrimaryNetworkImage(map["url"], fit: BoxFit.fitWidth)),
          ),
        ),
      );
    }
    return Container(
      constraints: BoxConstraints(
          maxWidth: color != null
              ? double.infinity
              : (MediaQuery.of(context).size.width - 24) * 0.76),
      child: ClipPath(
        clipper: _BubbleClipper(
            direction!, this.borderRadius ?? Radius.circular(5.0)),
        child: AnimatedContainer(
          alignment: this.alignment,
          width: this.width,
          height: this.height,
          constraints: (this.constraints ?? BoxConstraints()).copyWith(
            minHeight: _MinHeight,
            minWidth: _MinWidth,
          ),
          margin: this.margin,
          decoration: this.decoration,
          color: color != null
              ? color
              : this.direction == BubbleDirection.right
                  ? Color(0xFFa7e678)
                  : Colors.white,
          padding: EdgeInsets.fromLTRB(this._left, 0.0, this._right, 0.0)
              .add(this.padding ?? EdgeInsets.fromLTRB(17.0, 5.0, 17.0, 5.0)),
          // curve: Curves,
          duration: Duration(milliseconds: 200),
          child: this.child,
        ),
      ),
    );
  }
}

///方向
enum BubbleDirection { left, right, down }

class _BubbleClipper extends CustomClipper<Path> {
  final BubbleDirection? direction;
  final Radius radius;

  _BubbleClipper(this.direction, this.radius);

  @override
  Path getClip(Size size) {
    final path = Path();
    final path2 = Path();
    final centerPoint = (size.height / 2).clamp(_MinHeight / 2, _MinHeight / 2);

    if (this.direction == BubbleDirection.left) {
      //绘制左边三角形
      path.moveTo(0, centerPoint);
      path.lineTo(_ArrowWidth, centerPoint - _ArrowHeight / 2);
      path.lineTo(_ArrowWidth, centerPoint + _ArrowHeight / 2);
      path.close();
      //绘制矩形
      path2.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(
              _ArrowWidth, 0, (size.width - _ArrowWidth), size.height),
          this.radius));
      //合并
      path.addPath(path2, Offset(0, 0));
    } else if (this.direction == BubbleDirection.right) {
      //绘制右边三角形
      path.moveTo(size.width, centerPoint);
      path.lineTo(size.width - _ArrowWidth, centerPoint - _ArrowHeight / 2);
      path.lineTo(size.width - _ArrowWidth, centerPoint + _ArrowHeight / 2);
      path.close();
      //绘制矩形
      path2.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, (size.width - _ArrowWidth), size.height),
          this.radius));
      //合并
      path.addPath(path2, Offset(0, 0));
    } else {
      // final centerPoint = (size.width-10 / 2).clamp(_MinHeight / 2, _MinHeight / 2);
      // path.moveTo(0, centerPoint);
      // path.lineTo(_ArrowWidth, centerPoint - _ArrowHeight / 2);
      // path.lineTo(_ArrowWidth, centerPoint + _ArrowHeight / 2);
      // path.close();
      //绘制矩形
      path2.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(
              _ArrowWidth, 0, (size.width - _ArrowWidth), size.height),
          this.radius));
      //合并
      path.addPath(path2, Offset(0, 0));
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
