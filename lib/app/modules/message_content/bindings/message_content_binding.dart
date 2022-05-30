import 'package:get/get.dart';

import '../controllers/message_content_controller.dart';

class MessageContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageContentController>(
      () => MessageContentController(),
    );
  }
}
