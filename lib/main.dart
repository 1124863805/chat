import 'package:bot_toast/bot_toast.dart';
import 'package:chat/app/modules/message/controllers/message_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'app/modules/message_content/controllers/message_content_controller.dart';
import 'app/routes/app_pages.dart';

var basrUrl = "http://192.168.2.26:9098";

void main() {
  initServices();

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          builder: (context, child) {
            return BotToastInit()(
              context,
              child,
            );
          },
          title: "Application",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          supportedLocales: const [Locale('zh', 'CN')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    ),
  );
}

initServices() async {
  Get.put(ImService());
}

class ImService extends GetxService {
  late Socket socket;
  RxList list = [].obs;

  // 当前用户Id
  late String userId;

  // 初始化连接
  void init({required String userId}) {
    this.userId = userId;
    BotToast.showLoading();
    socket = createSocket("$basrUrl?userId=$userId");
    socket.connect();
    socket.onConnect((_) {
      print("连接成功");
      BotToast.closeAllLoading();

      /// 获取好友列表
      socket.emit("getFriendList", userId);
      Get.offAndToNamed(Routes.LAYOUT);
    });
    // 收到好友列表
    socket.on("getFriendList", (data) {
      list.value = data;
    });

    // 收到一条信息
    socket.on("getMessageInfo", (data) {
      print("收到一条消息");
      var index = list.lastIndexWhere((element) =>
          element["userId"].toString() == data["sender"].toString());
      if (index == -1) {
        list.add({"userId": data["sender"], "lastMessage": data});
      } else {
        for (var item in list) {
          if (item["userId"].toString() == data["sender"].toString()) {
            item["lastMessage"] = data;
          }
        }
        if (Get.currentRoute == "/message-content") {
          // 在聊天对话内
          MessageContentController messageController =
              Get.find<MessageContentController>();
          if (messageController.userId == data["sender"].toString()) {
            messageController.list.insert(0, data);
            messageController.refresh();
          }
        }
      }

      list.refresh();
    });
  }

  // 更新聊天列表
  void updateList(dynamic message) {
    int index =
        list.indexWhere((item) => item["userId"] == message["receiver"]);
    if (index == -1) {
      // 如果不存在就更新聊天列表
      list.insert(0, {"userId": message["receiver"], "lastMessage": message});
    } else {
      for (var item in list) {
        if (item["userId"].toString() == message["receiver"].toString()) {
          item["lastMessage"] = message;
        }
      }
    }

    list.refresh();
  }

  // 创建socket对象
  createSocket(url) {
    return io(
        url,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
  }

  // 私聊发送文本消息
  void sendPrivateMessageText(
      {required String receiver, required String content}) {
    Map data = {
      "sender": userId,
      "receiver": receiver,
      "messageType": 0,
      "chatType": 2,
      "content": content
    };
    socket.emit("sendMessage", data);
  }
}
