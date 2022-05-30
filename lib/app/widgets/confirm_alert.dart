import 'package:chat/app/widgets/primary_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmAlert extends StatelessWidget {
  final EdgeInsets? padding;
  final String? title;
  final String? text;
  final bool showDone;
  final bool showCancle;
  final String? doneText;
  final String? cancleText;

  ConfirmAlert({
    Key? key,
    this.title,
    this.text,
    this.showDone = true,
    this.showCancle = true,
    this.doneText,
    this.cancleText,
    this.padding =
        const EdgeInsets.only(left: 32, right: 32, top: 28, bottom: 24),
  }) : super(key: key);

  /// 展示详情页浮窗
  static Future<bool?> show(
    BuildContext context, {
    Key? key,
    String? title,
    String? text,
    bool showCancle = true,
    String? cancleText,
    bool showDone = true,
    String? doneText,
    EdgeInsets padding =
        const EdgeInsets.only(left: 32, right: 32, top: 28, bottom: 24),
  }) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 150),
      barrierColor: Color(0x99090909),
      pageBuilder: (BuildContext context, _, __) {
        return ConfirmAlert(
          key: key,
          title: title,
          text: text,
          showCancle: showCancle,
          cancleText: cancleText,
          showDone: showDone,
          doneText: doneText,
          padding: padding,
        );
      },
    );
  }

  /// 展示详情页浮窗
  static Future<bool?> done(
    BuildContext context, {
    Key? key,
    String? title,
    String? text,
    Widget Function(Widget widget)? builder,
    String doneText = '确认',
    EdgeInsets padding =
        const EdgeInsets.only(left: 32, right: 32, top: 28, bottom: 24),
  }) async {
    return showGeneralDialog<bool>(
        context: context,
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 150),
        barrierColor: Color(0x99090909),
        pageBuilder: (BuildContext context, _, __) {
          return ConfirmAlert(
            key: key,
            title: title,
            text: text,
            showCancle: false,
            showDone: true,
            doneText: doneText,
            padding: padding,
            // builder: builder,
          );
        });
  }

  /// 关闭详情页浮窗
  static void dismiss(BuildContext context) async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 44),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildContent(context),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    List<Widget> widgetList = [];
    if (this.title != null) {
      widgetList.add(
        Text(
          this.title!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 17.w,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    if (this.title != null && this.text != null) {
      widgetList.add(
        SizedBox(height: 14),
      );
    }
    if (this.text != null) {
      widgetList.add(
        Text(
          this.text!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 15.w,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }

    return Padding(
      padding: this.padding ?? EdgeInsets.zero,
      child: Column(
        children: widgetList,
      ),
    );
  }

  /// 取消/确定
  Widget _buildFooter(BuildContext context) {
    List<Widget> buttonList = [];
    if (showCancle) {
      buttonList.add(
        Expanded(
          child: InkResponse(
            highlightShape: BoxShape.rectangle,
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: Center(
              child: Text(
                this.cancleText ?? '取消',
                style: TextStyle(
                  fontSize: 17.w,
                  color: Color(0xff2a2a2a),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (showCancle && showDone) {
      // buttonList.add(
      //   VerticalDivider(
      //     indent: 8,
      //     endIndent: 8,
      //     color: Color(0x12000000),
      //     thickness: 1,
      //     width: 0,
      //   ),
      // );
    }

    if (showDone) {
      buttonList.add(
        Expanded(
          child: InkResponse(
            highlightShape: BoxShape.rectangle,
            onTap: () {
              Navigator.of(context).pop(true);
            },
            child: Container(
              height: 50,
              color: Color(0xFF2ECE7E),
              alignment: Alignment.center,
              child: Text(
                this.doneText ?? '确定',
                style: TextStyle(
                  fontSize: 17.w,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 50,
      child: Center(
        child: Row(
          children: buttonList,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x12000000)),
        ),
      ),
    );
  }
}

class InputAlert extends StatelessWidget {
  final EdgeInsets? padding;
  final String? title;
  final String? text;
  final bool showDone;
  final bool showCancle;
  final String? doneText;
  final String? cancleText;

  final TextEditingController controller;

  InputAlert({
    Key? key,
    this.title,
    this.text,
    this.showDone = true,
    this.showCancle = true,
    this.doneText,
    this.cancleText,
    this.padding =
        const EdgeInsets.only(left: 32, right: 32, top: 28, bottom: 24),
    required this.controller,
  }) : super(key: key);

  /// 展示详情页浮窗
  static Future<bool?> show(
    BuildContext context,
    TextEditingController controller, {
    Key? key,
    String? title,
    String? text,
    bool showCancle = true,
    String? cancleText,
    bool showDone = true,
    String? doneText,
    EdgeInsets padding =
        const EdgeInsets.only(left: 32, right: 32, top: 28, bottom: 24),
  }) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 150),
      barrierColor: Color(0x99090909),
      pageBuilder: (BuildContext context, _, __) {
        return InputAlert(
          key: key,
          title: title,
          text: text,
          showCancle: showCancle,
          cancleText: cancleText,
          showDone: showDone,
          doneText: doneText,
          padding: padding,
          controller: controller,
        );
      },
    );
  }

  /// 关闭详情页浮窗
  static void dismiss(BuildContext context) async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 44),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildContent(context),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    List<Widget> widgetList = [];
    if (this.title != null) {
      widgetList.add(
        Text(
          this.title!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 17.w,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    widgetList.add(PrimaryTextField(
      autofocus: true,
      controller: controller,
      maxLines: 10,
      hintText: "请点击输入举报内容",
    ));

    if (this.title != null && this.text != null) {
      widgetList.add(
        SizedBox(height: 14),
      );
    }
    if (this.text != null) {
      widgetList.add(
        Text(
          this.text!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 15.w,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }

    return Padding(
      padding: this.padding ?? EdgeInsets.zero,
      child: Column(
        children: widgetList,
      ),
    );
  }

  /// 取消/确定
  Widget _buildFooter(BuildContext context) {
    List<Widget> buttonList = [];
    if (showCancle) {
      buttonList.add(
        Expanded(
          child: InkResponse(
            highlightShape: BoxShape.rectangle,
            onTap: () {
              Navigator.of(context).pop(false);
            },
            child: Center(
              child: Text(
                this.cancleText ?? '取消',
                style: TextStyle(
                  fontSize: 17.w,
                  color: Color(0xff2a2a2a),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (showCancle && showDone) {
      // buttonList.add(
      //   VerticalDivider(
      //     indent: 8,
      //     endIndent: 8,
      //     color: Color(0x12000000),
      //     thickness: 1,
      //     width: 0,
      //   ),
      // );
    }

    if (showDone) {
      buttonList.add(
        Expanded(
          child: InkResponse(
            highlightShape: BoxShape.rectangle,
            onTap: () {
              Navigator.of(context).pop(true);
            },
            child: Container(
              height: 50,
              color: Color(0xFF2ECE7E),
              alignment: Alignment.center,
              child: Text(
                this.doneText ?? '确定',
                style: TextStyle(
                  fontSize: 17.w,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 50,
      child: Center(
        child: Row(
          children: buttonList,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x12000000)),
        ),
      ),
    );
  }
}
