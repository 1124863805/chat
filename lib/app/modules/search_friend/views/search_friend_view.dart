import 'package:bot_toast/bot_toast.dart';
import 'package:chat/app/http_util.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/custom_text.dart';
import 'package:chat/app/widgets/primary_appbar.dart';
import 'package:chat/app/widgets/primary_button.dart';
import 'package:chat/app/widgets/primary_network_image.dart';
import 'package:chat/app/widgets/primary_textfield.dart';
import 'package:chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/search_friend_controller.dart';

class Constant {
  static String default_avatar =
      "https://img0.baidu.com/it/u=1356523179,1772235027&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500";
}

class SearchFriendView extends GetView<SearchFriendController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PrimaryAppbar(
        title: Text("查找好友"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
                  padding: EdgeInsets.only(left: 16.w),
                  height: 40.w,
                  decoration: BoxDecoration(
                      color: Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(27.w)),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/搜索.svg",
                        width: 16.w,
                        height: 16.w,
                      ),
                      Expanded(
                          child: PrimaryTextField(
                        controller: controller.controller,
                        cursorColor: Colors.black,
                        margin: EdgeInsets.only(top: 2.w, left: 8.w),
                        hintText: "请输入用户ID",
                        suffix: Container(
                          margin: EdgeInsets.only(right: 5.w),
                          child: SizedBox(
                            width: 56.w,
                            height: 32.w,
                            child: PrimaryButton(
                              onTap: () async {
                                String userId = controller.controller.text;
                                if (userId.isEmpty) {
                                  BotToast.showText(text: "请输入用户ID");
                                  return;
                                }

                                var res = await HttpUtil()
                                    .get("findUserByUserId?userId=${userId}");
                                if (res["data"] != null) {
                                  controller.list.value = res["data"];
                                } else {
                                  BotToast.showText(text: "没有找到该用户");
                                  controller.list.value = [];
                                }
                              },
                              borderRadius: BorderRadius.circular(27.w),
                              color: Color(0xFF2BDBA8),
                              text: "搜索",
                              fontSize: 14.w,
                            ),
                          ),
                        ),
                        textStyle:
                            TextStyle(color: Color(0xFFB7B7B7), fontSize: 14.w),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                  itemCount: controller.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          ClipOval(
                            child: PrimaryNetworkImage(
                              Constant.default_avatar,
                              width: 48.w,
                              height: 48.w,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LT(
                                  text: controller.list[index]["userId"]
                                      .toString(),
                                  right: 20.w,
                                  fontSize: 16.w,
                                  weight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5.w),
                            child: SizedBox(
                              width: 86.w,
                              height: 32.w,
                              child: PrimaryButton(
                                onTap: () async {
                                  ImService im = Get.find<ImService>();
                                  var userId = controller.list[index]["userId"];
                                  if (im.userId.toString() ==
                                      userId.toString()) {
                                    BotToast.showText(text: "自己不能给自己发消息");
                                    return;
                                  }

                                  Get.toNamed(Routes.MESSAGE_CONTENT,
                                      arguments: userId);
                                },
                                borderRadius: BorderRadius.circular(27.w),
                                color: Color(0xFF2BDBA8),
                                text: "发送消息",
                                fontSize: 14.w,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
