import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimarySheetMenu extends StatelessWidget {
  static show(
    BuildContext context, {
    required List<PrimarySheetMenuItem> items,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PrimarySheetMenu(
          items: items,
        );
      },
    );
  }

  final List<PrimarySheetMenuItem> items;

  PrimarySheetMenu({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> tempWidgets = [];
    tempWidgets = items
        .map(
          (item) => _buildItem(context: context, item: item),
        )
        .toList();
    for (var i = items.length - 1; i > 0; i--) {
      tempWidgets.insert(
        i,
        Divider(color: Color(0xffededed), height: 1 / ScreenUtil().pixelRatio!),
      );
    }

    List<Widget> itemWidgets = [];
    itemWidgets.addAll(tempWidgets);
    itemWidgets.add(
      Container(
        height: 10,
        color: Color(0xfffafafa),
      ),
    );
    itemWidgets.add(
      _buildItem(
        context: context,
        item: PrimarySheetMenuItem(
          title: '取消',
          onTap: () {
            return null;
          },
        ),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: itemWidgets,
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required PrimarySheetMenuItem item,
  }) {
    return InkResponse(
      onTap: () async {
        Navigator.of(context).pop(item.value);
        if (item.onTap != null) item.onTap!();
      },
      child: Container(
        color: Colors.white,
        height: 56.h,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          item.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17.w,
            fontWeight: FontWeight.w400,
            color: item.destructive ? Color(0xffff0000) : Color(0xff2a2a2a),
          ),
        ),
      ),
    );
  }
}

class PrimarySheetMenuItem {
  final String title;
  final bool destructive;
  final Object? value;
  final dynamic Function()? onTap;

  PrimarySheetMenuItem({
    this.title = '',
    this.destructive = false,
    this.onTap,
    this.value,
  });
}
