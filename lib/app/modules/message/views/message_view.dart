import 'package:chat/app/modules/search_friend/views/search_friend_view.dart';
import 'package:chat/app/relative_date_format.dart';
import 'package:chat/app/routes/app_pages.dart';
import 'package:chat/app/widgets/custom_text.dart';
import 'package:chat/app/widgets/primary_appbar.dart';
import 'package:chat/app/widgets/primary_network_image.dart';
import 'package:chat/app/widgets/primary_textfield.dart';
import 'package:chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/message_controller.dart';

class MessageView extends GetView<MessageController> {
  ImService imService = Get.find<ImService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(1.sw, 60.w),
        child: SafeArea(
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: LT(
                  text: "聊天列表",
                  fontSize: 16.w,
                  weight: FontWeight.bold,
                ),
              ),
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
                        cursorColor: Colors.black,
                        margin: EdgeInsets.only(top: 2.w, left: 8.w),
                        hintText: "请输入",
                        textStyle:
                            TextStyle(color: Color(0xFFB7B7B7), fontSize: 14.w),
                      ))
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 12.w),
                child: InkResponse(
                  onTap: () {
                    Get.toNamed(Routes.SEARCH_FRIEND);
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () => ListView.builder(
            itemCount: imService.list.length,
            itemBuilder: (context, index) {
              var item = imService.list[index];
              return InkResponse(
                onTap: () {
                  Get.toNamed(Routes.MESSAGE_CONTENT,
                      arguments: item["userId"]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  margin: EdgeInsets.only(bottom: 12.w,top: 12.w),
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
                              text: item["userId"].toString(),
                              right: 20.w,
                              fontSize: 16.w,
                              weight: FontWeight.w400,
                            ),
                            SizedBox(height: 8.w),
                            if (item["lastMessage"] != null)
                              buildLastMessage(item["lastMessage"])
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LT(
                              text:
                                  "${RelativeDateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(item["lastMessage"]["time"].toString())))}",
                              color: Color(0xFF838383),
                              fontSize: 12.w,
                              weight: FontWeight.w400),
                          // SizedBox(height: 8.w),
                          // if (imList.unread != 0)
                          //   Container(
                          //       padding: EdgeInsetsmmetric(
                          //           horizontal: 5.w, vertical: 2.w),
                          //       decoration: BoxDecoration(
                          //           color: Color(0xFFFF3737), shape: BoxShape.circle),
                          //       child: LT(
                          //         text: "${imList.unread}",
                          //         fontSize: 10.w,
                          //         color: Colors.white,
                          //       ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  //action == 2 文本消息
  Widget buildLastMessage(dynamic message) {
    if (message["messageType"] == 0) {
      return Container(
        width: 200,
        child: new Text('${message["content"]}',
            style: new TextStyle(color: Color(0xFFB4B7BD), fontSize: 14.w),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      );
    }else {
      return new Text('[未知消息]',
          style: new TextStyle(color: Color(0xFFB4B7BD), fontSize: 14.w));
    }
  }
}
