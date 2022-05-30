import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/layout_controller.dart';

class LayoutView extends GetView<LayoutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      primary: false,
      body: Obx(
        () => IndexedStack(
          index: controller.index.isNotEmpty
              ? controller.items
                  .indexWhere((e) => e.id == controller.index.value)
              : 0,
          children: controller.items.map((e) {
            return e.page;
          }).toList(),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF6F6F6))),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.04),
                    offset: Offset(0, -1),
                    blurRadius: 20)
              ]),
          height: 57 + ScreenUtil().bottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: controller.items.map((e) {
              return Expanded(
                child: buildBottomWidgetItem(e),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildBottomWidgetItem(TabbarControllerItem item) {
    return Obx(() {
      var isSelect = item.id == controller.index.value;
      return InkResponse(
        onTap: () {
          controller.index.value = item.id;
          FocusScope.of(Get.context!).requestFocus(FocusNode());
        },
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              item.iconBuild(isSelect),
              if (item.title != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.5),
                  child: Text(
                    item.title!,
                    style: TextStyle(
                        color: Color(isSelect ? 0xFFF99029 : 0xFF000000),
                        fontSize: 10),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
