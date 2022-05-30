import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  String userId = '';

  @override
  void onInit() {
    userId = Get.arguments.toString();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
