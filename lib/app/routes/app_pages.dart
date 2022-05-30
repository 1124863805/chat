import 'package:get/get.dart';

import 'package:chat/app/modules/home/bindings/home_binding.dart';
import 'package:chat/app/modules/home/views/home_view.dart';
import 'package:chat/app/modules/layout/bindings/layout_binding.dart';
import 'package:chat/app/modules/layout/views/layout_view.dart';
import 'package:chat/app/modules/login/bindings/login_binding.dart';
import 'package:chat/app/modules/login/views/login_view.dart';
import 'package:chat/app/modules/message/bindings/message_binding.dart';
import 'package:chat/app/modules/message/views/message_view.dart';
import 'package:chat/app/modules/message_content/bindings/message_content_binding.dart';
import 'package:chat/app/modules/message_content/views/message_content_view.dart';
import 'package:chat/app/modules/mine/bindings/mine_binding.dart';
import 'package:chat/app/modules/mine/views/mine_view.dart';
import 'package:chat/app/modules/search_friend/bindings/search_friend_binding.dart';
import 'package:chat/app/modules/search_friend/views/search_friend_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.LAYOUT,
      page: () => LayoutView(),
      binding: LayoutBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE,
      page: () => MessageView(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: _Paths.MINE,
      page: () => MineView(),
      binding: MineBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_FRIEND,
      page: () => SearchFriendView(),
      binding: SearchFriendBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGE_CONTENT,
      page: () => MessageContentView(),
      binding: MessageContentBinding(),
    ),
  ];
}
