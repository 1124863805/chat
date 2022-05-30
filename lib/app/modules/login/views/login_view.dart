import 'package:bot_toast/bot_toast.dart';
import 'package:chat/app/widgets/custom_text.dart';
import 'package:chat/app/widgets/primary_button.dart';
import 'package:chat/app/widgets/primary_textfield.dart';
import 'package:chat/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../controllers/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: Column(
          children: [
            Row(
              children: [
                LT(
                  text: "欢迎登陆",
                  fontSize: 24,
                  color: Color(0xFF333333),
                  left: 12.w,
                ),
                LT(text: "IM", fontSize: 24, color: Color(0xFFF99029)),
              ],
            ),
            SizedBox(
              height: 153.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryTextField(
                    controller: controller.userIdController,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    cursorColor: Colors.black,
                    hintColor: Color(0xFFB7B7B7),
                    hintText: "请输入用户ID",
                    maxLength: 11,
                    keyboardType: TextInputType.number,
                    decoration: BoxDecoration(
                        color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  PrimaryButton(
                    top: 24.w,
                    height: 48,
                    color: Color(0xFF2BDBA8),
                    text: "登陆",
                    onTap: () {
                      ImService im = Get.find<ImService>();
                      im.init(userId: controller.userIdController.text);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
