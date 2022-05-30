import 'package:get/get.dart';

import '../controllers/search_friend_controller.dart';

class SearchFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFriendController>(
      () => SearchFriendController(),
    );
  }
}
