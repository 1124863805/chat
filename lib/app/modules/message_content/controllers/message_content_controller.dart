import 'package:chat/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../http_util.dart';

class MessageContentController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController contentController = TextEditingController();

  RxList list = RxList([]);

  String userId = "";

  @override
  void onInit() {
    userId = Get.arguments.toString();
    super.onInit();
    getData();
  }

  Future<void> getData({page, size}) async {
    ImService service = Get.find<ImService>();
    var res = await HttpUtil().get(
        "messageHistory?myId=${service.userId}&chatId=${Get.arguments}&page=${page ?? 1}&size=${size ?? 10}");
    List<dynamic> data = res["data"];

    list.value = data.reversed.toList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
