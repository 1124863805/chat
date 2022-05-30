import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:chat/app/widgets/confirm_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:permission_handler/permission_handler.dart';

class ImageUtil {
  /// 保存图片到相册
  ///
  /// 默认为下载网络图片，如需下载资源图片，需要指定 [isAsset] 为 `true`。
  static Future<void> saveImage(BuildContext context, String imageUrl) async {
    BotToast.showLoading();
    try {
      if (imageUrl == null) throw '保存失败，图片不存在！';

      /// 权限检测
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus != PermissionStatus.granted) {
        storageStatus = await Permission.storage.request();
        if (storageStatus != PermissionStatus.granted) {
          throw '无法存储图片，请先授权！';
        }
      }

      BotToast.showLoading();
      var response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      // { isSuccess: true}
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
      );
      BotToast.closeAllLoading();
      if (result is Map && result['isSuccess'] == true) {
        await ConfirmAlert.done(context, title: '已保存到相册');
      } else {
        var confirm = await ConfirmAlert.show(
          context,
          title: '保存失败',
          text: '请允许应用保存文件至相册',
          doneText: '去设置',
        );
        if (confirm == true) AppSettings.openAppSettings();
      }
    } catch (e) {
      print(e.toString());
      BotToast.closeAllLoading();
      BotToast.showText(text: e.toString());
    }
  }
}
