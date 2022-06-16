import 'package:bot_toast/bot_toast.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:chat/app/modules/message_content/compontent/bubble.dart';
import 'package:chat/app/modules/message_content/compontent/constant.dart';
import 'package:chat/app/modules/message_content/compontent/extended_text/my_special_text_span_builder.dart';
import 'package:chat/app/modules/message_content/compontent/wx_expression.dart';
import 'package:chat/app/modules/search_friend/views/search_friend_view.dart';
import 'package:chat/app/widgets/confirm_alert.dart';
import 'package:chat/app/widgets/primary_appbar.dart';
import 'package:chat/main.dart';
import 'package:extended_list/extended_list.dart';
import 'package:extended_text/extended_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import '../controllers/message_content_controller.dart';

class MessageContentView extends GetView<MessageContentController> {
  ImService imService = Get.find<ImService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PrimaryAppbar(
        title: Text(Get.arguments.toString()),
        centerTitle: true,
      ),
      body: WeChatInput(
        contentController: controller.contentController,
        send: (value) {
          ImService imService = Get.find<ImService>();
          Map<String, dynamic> message = {
            "receiver": Get.arguments,
            "content": value,
            "action": "2",
            "sender": imService.userId,
            "time": DateTime.now().millisecondsSinceEpoch,
            "messageType": 0,
            "chatType": 2,
          };
          imService.sendPrivateMessageText(
              receiver: Get.arguments.toString(), content: value);

          controller.list.insert(0, message);

          imService.updateList(message);
        },
        content: Container(
          // margin: EdgeInsets.only(bottom: 65),
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Obx(
            () => ExtendedListView.builder(
              reverse: true,
              itemCount: controller.list.length,
              extendedListDelegate:
                  const ExtendedListDelegate(closeToTrailing: true),
              itemBuilder: (BuildContext context, int index) {
                var item = controller.list[index];
                print(item);
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Bubble(
                    unread: 0,
                    content: item["content"],
                    myHead: Constant.default_avatar,
                    head: Constant.default_avatar,
                    direction: imService.userId == item["sender"].toString()
                        ? BubbleDirection.right
                        : BubbleDirection.left,
                    padding: EdgeInsets.all(10),
                    userId: imService.userId,
                    action: '1',
                    child: ExtendedText(
                      item["content"],
                      specialTextSpanBuilder: MySpecialTextSpanBuilder(),
                    ),
                  ),
                );
              },
            ),
          ),
          // child: Column(
          //   children: [
          //

          //   ],
          // ),
        ),
      ),
    );
  }
}

class WeChatInput extends StatefulWidget {
  TextEditingController contentController;
  Function send;
  Widget content;

  WeChatInput(
      {Key? key,
      required this.content,
      required this.send,
      required this.contentController})
      : super(key: key);

  @override
  _WeChatInputState createState() => _WeChatInputState();
}

class _WeChatInputState extends State<WeChatInput>
    with TickerProviderStateMixin {
  // var controller = Get.find<MessageContentController>();

  // 0 键盘  1 表情
  int iconState = 0;

  // 0 默认 1 表情 2 添加 3 声音
  int state = 0;

  int tabIndex = 0;

  bool inputState = false;

  bool sendState = false;

  List<String> list = ["表情"];

  late TabController tabController;

  FocusNode commentFocus = FocusNode();

  // late Animation<double> animation;
  // late AnimationController controller;

  @override
  void dispose() {
    super.dispose();
    // controller.dispose();
    tabController.dispose();
  }

  @override
  void initState() {
    // controller = new AnimationController(
    //     duration: const Duration(milliseconds: 150), vsync: this);
    // animation = new Tween(begin: 0.0, end: 340.0).animate(controller)
    //   ..addListener(() {
    //     setState(() {
    //       // the state that has changed here is the animation object’s value
    //     });
    //   });

    tabController =
        TabController(length: list.length, vsync: this, initialIndex: 0);

    tabController.addListener(() {
      tabIndex = tabController.index;
      setState(() {});
    });

    commentFocus.addListener(() {
      if (commentFocus.hasFocus) {
        iconState = 0;
        setState(() {});
      }
    });

    widget.contentController.addListener(() {
      var text = widget.contentController.value.text;

      if (text.isNotEmpty && !sendState) {
        sendState = true;
      }
      if (text.isEmpty && sendState) {
        sendState = false;
      }
      if (text.isNotEmpty && !inputState) {
        inputState = true;
      }
      if (text.isEmpty) {
        inputState = false;
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getBottomBar(context),
      backgroundColor: Color(0xFFf6f5f7),
      body: Column(
        children: [
          Flexible(child: widget.content),
          bottomSheet(),
        ],
      ),
    );
  }

  // 获取到底部样式
  Widget getBottomBar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Offstage(
          offstage: !(state == 1),
          // offstage: commentFocus.hasFocus,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFededed),
            ),
            height: 340,
            child: Column(
              children: [
                Container(
                  color: Color(0xFFf6f5f7),
                  padding: EdgeInsets.all(6),
                  child: Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: TabBar(
                                  padding: EdgeInsets.zero,
                                  indicatorPadding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.zero,
                                  isScrollable: true,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BubbleTabIndicator(
                                    indicatorHeight: 40,
                                    indicatorColor: Colors.white,
                                    tabBarIndicatorSize:
                                        TabBarIndicatorSize.tab,
                                    indicatorRadius: 10,
                                  ),
                                  tabs: list
                                      .asMap()
                                      .keys
                                      .map((e) => Container(
                                            width: 40,
                                            height: 40,
                                            margin: EdgeInsets.only(
                                                right: 5, left: 5),
                                            padding: EdgeInsets.all(10),
                                            // decoration: BoxDecoration(
                                            // ),
                                            child: SvgPicture.asset(
                                                "assets/chat_content/expression_content/${list[e]}.svg"),
                                          ))
                                      .toList(),
                                  controller: tabController),
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                  // child: TabBarView(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Stack(
                        children: [
                          WeChatExpression((Expression expression) {
                            widget.contentController.text =
                                widget.contentController.text +
                                    "[${expression.name}]";
                            widget.contentController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset:
                                        widget.contentController.text.length));
                            setState(() {});
                          }),
                          Positioned(
                            bottom: 0,
                            right: 11,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFFececec),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFFececec),
                                        offset: Offset(0, -8.0), //阴影xy轴偏移量
                                        blurRadius: 15.0, //阴影模糊程度
                                        spreadRadius: 12.0 //阴影扩散程度
                                        )
                                  ]),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 40),
                                child: SafeArea(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 20),
                                      InkResponse(
                                        onTap: () {
                                          if (inputState) {
                                            // 特殊处理 删除表情情况
                                            String currentText = widget
                                                .contentController.value.text;
                                            String lastText =
                                                currentText.substring(
                                                    currentText.length - 1,
                                                    currentText.length);
                                            if (lastText == "]") {
                                              int indexOf =
                                                  currentText.lastIndexOf("[");
                                              if (indexOf == -1) {
                                                widget.contentController.text = widget
                                                    .contentController.text
                                                    .substring(
                                                        0,
                                                        widget.contentController
                                                                .text.length -
                                                            1);
                                              } else {
                                                widget.contentController.text =
                                                    widget
                                                        .contentController.text
                                                        .substring(0, indexOf);
                                              }
                                            } else {
                                              widget
                                                ..contentController.text = widget
                                                    .contentController
                                                    .value
                                                    .text
                                                    .substring(
                                                        0,
                                                        widget.contentController
                                                                .text.length -
                                                            1);
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 40,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: SvgPicture.asset(
                                            "assets/chat_content/删除.svg",
                                            color: inputState
                                                ? Colors.black
                                                : Color(0xFFe0e0e0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      InkResponse(
                                        onTap: () {
                                          widget.send(
                                              widget.contentController.text);
                                          widget.contentController.text = "";
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 40,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: inputState
                                                  ? Color(0xFF73ba74)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: new Text('发送',
                                              style: new TextStyle(
                                                  color: inputState
                                                      ? Colors.white
                                                      : Color(0xFFe0e0e0),
                                                  fontSize: 13)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: state != 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFe8e8e8))),
            ),
            height: 257,
            child: buildAddMore(context, chatModePage: wxC.chatModePage0),
          ),
        ),
        Offstage(
          offstage: state == 1,
          child: Container(child: SafeArea(child: SizedBox.shrink())),
        )
      ],
    );
  }

  Widget buildAddMore(BuildContext context,
      {required List<ChatMoreModel> chatModePage}) {
    return Row(
      children: chatModePage
          .map((e) => Container(
                margin: EdgeInsets.only(right: 20),
                child: InkResponse(
                  onTap: () async {
                    if (e.title == "照片") {
                      await Permission.photos.request();
                      final List<AssetEntity>? assets =
                          await AssetPicker.pickAssets(
                        context,
                      );
                      if (assets == null || assets.isEmpty) return null;
                      for (AssetEntity item in assets) {
                        // sendPhoto(item, userId: controller.parameter.userId);
                      }
                    } else if (e.title == "拍照") {
                      final AssetEntity? assets =
                          await CameraPicker.pickFromCamera(context);
                      if (assets == null) return null;
                      // sendPhoto(assets, userId: controller.parameter.userId);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: SvgPicture.asset(
                          e.icon,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(e.title,
                          style: new TextStyle(
                              color: Color(0xFF989898), fontSize: 12)),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget bottomSheet() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: const BoxDecoration(
                  color: Color(0xFFf6f5f7),
                  border: Border(top: BorderSide(color: Color(0xFFdcdddc)))),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: state == 3
                        ? Container()
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7)),
                            constraints: state == 3
                                ? BoxConstraints(
                                    maxHeight: 37,
                                  )
                                : null,
                            child: inputText()),
                  ),
                  SizedBox(width: 10),
                  InkResponse(
                      onTap: () {
                        if (iconState == 0 && state == 0) {
                          iconState = 1;
                          state = 1;
                          commentFocus.unfocus();
                          // controller.forward();
                          setState(() {});
                        } else if (state == 1 && iconState == 0) {
                          iconState = 1;
                          commentFocus.unfocus();
                        } else if (state == 2) {
                          state = 1;
                          iconState = 1;
                          // controller.forward();
                          setState(() {});
                        } else {
                          FocusScope.of(Get.context!)
                              .requestFocus(commentFocus);
                          iconState = 0;
                          setState(() {});
                        }
                      },
                      child: SvgPicture.asset(
                        "assets/chat_content/${iconState != 0 ? '键盘' : '表情'}.svg",
                        width: 27,
                        height: 28,
                      )),
                  SizedBox(width: 10),
                  Offstage(
                    offstage: !sendState,
                    child: InkResponse(
                      onTap: () {
                        widget.send(widget.contentController.text);
                        widget.contentController.text = "";
                        setState(() {});
                      },
                      child: Container(
                        width: 50,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color:
                                inputState ? Color(0xFF73ba74) : Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: new Text('发送',
                            style: new TextStyle(
                                color: inputState
                                    ? Colors.white
                                    : Color(0xFFe0e0e0),
                                fontSize: 13)),
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: sendState,
                    child: Builder(builder: (context) {
                      return InkResponse(
                          onTap: () {
                            state = 2;
                            commentFocus.unfocus();
                            setState(() {});
                          },
                          child: SvgPicture.asset(
                            "assets/chat_content/添加.svg",
                            width: 25,
                            height: 25,
                          ));
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputText() {
    return ExtendedTextField(
      onEditingComplete: () async {
        widget.send(widget.contentController.text);
      },
      cursorColor: Color(0xFF56bd69),
      specialTextSpanBuilder: MySpecialTextSpanBuilder(),
      minLines: 1,
      maxLines: 5,
      textInputAction: TextInputAction.send,
      controller: widget.contentController,
      focusNode: commentFocus,
      decoration: wxC.commonInputStyle,
    );
  }
}
