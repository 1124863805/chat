import 'package:chat/app/modules/message/views/message_view.dart';
import 'package:chat/app/modules/mine/views/mine_view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController {
  final index = 'MessageView'.obs;

  final RxList<TabbarControllerItem> items = RxList();

  @override
  void onInit() {
    super.onInit();

    items.value = [
      TabbarControllerItem(
        id: 'MessageView',
        iconBuild: (isSelect) => SvgPicture.asset(
          'assets/tab3.svg',
          width: 18,
          height: 18,
          color: isSelect ? Color(0xFFF99029) : Color(0xFF000000),
        ),
        page: MessageView(),
        title: '消息',
      ),
      TabbarControllerItem(
        id: 'mine',
        iconBuild: (isSelect) => SvgPicture.asset(
          'assets/tab5.svg',
          width: 18,
          height: 18,
          color: isSelect ? Color(0xFFF99029) : Color(0xFF000000),
        ),
        page: MineView(),
        title: '我的',
      ),
    ];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}

class TabbarControllerItem {
  String id;
  Widget page;
  String? title;
  Widget Function(bool isSelect) iconBuild;

  TabbarControllerItem({
    required this.id,
    required this.iconBuild,
    required this.page,
    this.title,
  });
}
