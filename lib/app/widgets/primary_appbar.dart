import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryAppbar extends AppBar {
  final double height;

  PrimaryAppbar({
    Key? key,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    String? titleText,
    Widget? title,
    List<Widget>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double elevation = 0,
    ShapeBorder? shape,
    Color? backgroundColor,
    Color textColor = Colors.black,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    TextTheme? textTheme,
    bool primary = true,
    bool centerTitle = true,
    double titleSpacing = NavigationToolbar.kMiddleSpacing,
    double toolbarOpacity = 1.0,
    double bottomOpacity = 1.0,
    double? leadingWidth,
    this.height = 44,
  }) : super(
            key: key,
            leading: leading,
            automaticallyImplyLeading: automaticallyImplyLeading,
            title: DefaultTextStyle(
              style: TextStyle(
                height: 1,
                fontSize: 17,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              child: title != null ? title : Text(titleText ?? ''),
            ),
            actions: actions,
            flexibleSpace: flexibleSpace,
            bottom: bottom,
            elevation: elevation,
            shape: shape,
            backgroundColor: backgroundColor,
            iconTheme: iconTheme,
            actionsIconTheme: actionsIconTheme,
            textTheme: textTheme,
            primary: primary,
            centerTitle: centerTitle,
            titleSpacing: titleSpacing,
            toolbarOpacity: toolbarOpacity,
            bottomOpacity: bottomOpacity,
            leadingWidth: leadingWidth);

  PrimaryAppbar.theme({
    Key? key,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    String? titleText,
    Widget? title,
    List<PrimaryAppbarItem>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double elevation = 0,
    ShapeBorder? shape,
    Color backgroundColor = Colors.white,
    bool primary = true,
    bool centerTitle = true,
    double titleSpacing = 0,
    double toolbarOpacity = 1.0,
    double bottomOpacity = 1.0,
    PrimaryAppbarTheme theme = PrimaryAppbarTheme.dark,
    this.height = 44,
  }) : super(
          key: key,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
          title: DefaultTextStyle(
            style: TextStyle(
              height: 1,
              fontSize: 17,
              color: getThemeColor(theme),
              fontWeight: FontWeight.bold,
            ),
            child: title != null ? title : Text(titleText ?? ''),
          ),
          actions: () {
            if (actions == null) return null;
            List<Widget> children = [];

            for (var i = 0; i < actions.length; i++) {
              var item = actions[i];

              Widget itemWidget;
              if (item is PrimaryAppbarWidgetItem) {
                itemWidget = item.child;
              } else if (item is PrimaryAppbarImageItem) {
                itemWidget = Image.asset(item.imgPath, width: 24, height: 24);
              } else if (item is PrimaryAppbarTextItem) {
                itemWidget = Text(
                  item.text,
                  style: (item.style ?? TextStyle(fontSize: 17)),
                );
              } else {
                itemWidget = FlutterLogo();
              }

              children.add(InkResponse(
                highlightShape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                radius: 0,
                child: Container(
                  // color: Colors.red,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: itemWidget,
                ),
                onTap: () {
                  if (item.onTap != null) {
                    item.onTap!();
                  }
                },
              ));
            }

            // children.add(Container(width: 8));
            return children;
          }(),
          bottom: bottom,
          elevation: elevation,
          shape: shape,
          backgroundColor: backgroundColor,
          systemOverlayStyle: getThemeBrightness(theme),
          iconTheme: IconThemeData(color: getThemeColor(theme)),
          actionsIconTheme: IconThemeData(color: getThemeColor(theme)),
          primary: primary,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          toolbarOpacity: toolbarOpacity,
          bottomOpacity: bottomOpacity,
        );

  @override
  Size get preferredSize {
    double bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size(super.preferredSize.width, this.height + bottomHeight);
  }
}

enum PrimaryAppbarTheme {
  light,
  dark,
}

getThemeBrightness(PrimaryAppbarTheme theme) {
  switch (theme) {
    case PrimaryAppbarTheme.light:
      return SystemUiOverlayStyle.light;
    case PrimaryAppbarTheme.dark:
      return SystemUiOverlayStyle.dark;
  }
}

getThemeColor(PrimaryAppbarTheme theme) {
  switch (theme) {
    case PrimaryAppbarTheme.light:
      return Colors.white;
    case PrimaryAppbarTheme.dark:
      return Colors.black;
  }
}

abstract class PrimaryAppbarItem {
  Function? onTap;
}

class PrimaryAppbarWidgetItem implements PrimaryAppbarItem {
  Widget child;
  Function? onTap;

  PrimaryAppbarWidgetItem({
    required this.child,
    this.onTap,
  });
}

class PrimaryAppbarImageItem implements PrimaryAppbarItem {
  String imgPath;
  Function? onTap;

  PrimaryAppbarImageItem({
    required this.imgPath,
    this.onTap,
  });
}

class PrimaryAppbarTextItem implements PrimaryAppbarItem {
  String text;
  TextStyle? style;
  Function? onTap;

  PrimaryAppbarTextItem({
    required this.text,
    this.style,
    this.onTap,
  });
}
