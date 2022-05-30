import 'package:flutter/material.dart';

//  内容页面Model
class ChatMoreModel {
  final String title;
  final String icon;

  ChatMoreModel({required this.title, required this.icon});
}

class wxC {
  // 聊天内容页面 第一页面选项
  static List<ChatMoreModel> chatModePage0 = [
    ChatMoreModel(title: "照片", icon: "assets/chat_content/more/照片.svg"),
    ChatMoreModel(title: "拍照", icon: "assets/chat_content/more/拍照.svg"),
    // ChatMoreModel(title: "交换手机号", icon: "assets/chat_content/more/转账.svg"),
  ];

//通用的输入框默认样式
  static InputDecoration commonInputStyle = const InputDecoration(
      isDense: true,
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      contentPadding: EdgeInsets.all(10));
}
