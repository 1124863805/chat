import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';

import 'package:get/get.dart' as GetX;
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

const kHttpHost = "http://192.168.2.26:8082/";

class HttpUtil {
  factory HttpUtil() => _getInstance();

  static HttpUtil _getInstance() => _instance;
  static HttpUtil _instance = HttpUtil._internal();

  static BaseOptions options = BaseOptions(
    baseUrl: kHttpHost,
    connectTimeout: 25000,
    receiveTimeout: 25000,
  );

  Dio dio = new Dio(BaseOptions(
      baseUrl: kHttpHost, connectTimeout: 15000, receiveTimeout: 15000));

  Duration? _serverTimeDifference;

  HttpUtil._internal() {
    dio = new Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          print("========================请求数据interceptors===================");
          print("url=${options.uri.toString()}");
          print("params=${options.data}");
          handler.next(options);
        },
        onResponse: (Response response, handler) async {
          print("========================请求数据onResponse===================");
          print("code=${response.statusCode}");
          print("response=${convert.jsonEncode(response.data)}");
          handler.next(response);
        },
        onError: (DioError error, handler) {
          print("========================请求错误error===================");
          print("code=${error.response?.statusCode}");
          print("response=${error.response?.data}");
          print("message=${error.message}");

          try {
            switch (error.type) {
              case DioErrorType.connectTimeout:
                BotToast.showText(text: '网络连接超时，请稍后再试');
                break;
              case DioErrorType.sendTimeout:
                BotToast.showText(text: '数据连接超时，请检查网络或稍后再试');
                break;
              case DioErrorType.receiveTimeout:
                BotToast.showText(text: '数据接收超时，请检查网络或稍后再试');
                break;
              case DioErrorType.response:
                var data = error.response?.data;
                if (data is Map) {
                  if (data.containsKey('msg')) {
                    BotToast.showText(text: data['msg']);
                  }
                } else {
                  BotToast.showText(text: "网络错误，请稍后再试");
                }
                break;
              default:
                if (error.message is String)
                  BotToast.showText(text: "${error.message}");
                else
                  BotToast.showText(text: "发生错误，请稍后再试");
                break;
            }
          } catch (e) {}
          BotToast.closeAllLoading();
          handler.next(error);
        },
      ),
    );
  }

  Future get(String path,
      {Map<String, dynamic>? parameters, Options? options}) async {
    String url = '$path';

    Response response =
        await dio.get(url, queryParameters: parameters, options: options);
    return response.data;
  }

  Future post(String path,
      {Map<String, dynamic>? parameters,
      Options? options,
      dynamic data}) async {
    String url = '$path';

    Response response = await dio.post(url,
        queryParameters: parameters, data: data, options: options);
    return response.data;
  }

  DateTime get serverTime {
    if (_serverTimeDifference == null) return DateTime.now();
    return DateTime.now().add(_serverTimeDifference!);
  }
}
