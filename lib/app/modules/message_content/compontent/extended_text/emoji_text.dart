import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../wx_expression.dart';

class EmojiText extends SpecialText {
  EmojiText(TextStyle? textStyle, {this.start})
      : super(EmojiText.flag, ']', textStyle);
  static const String flag = '[';
  final int? start;

  @override
  InlineSpan finishText() {
    final String key = toString();
    if (EmojiUitl.instance.emojiMap.containsKey(key) && !kIsWeb) {
      const double size = 20.0;
      return ImageSpan(
          AssetImage(
            EmojiUitl.instance.emojiMap[key]!,
          ),
          actualText: key,
          imageWidth: size,
          imageHeight: size,
          start: start!,
          fit: BoxFit.fill,
          margin: const EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0));
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class EmojiUitl {
  EmojiUitl._() {
    for (int i = 0; i < ExpressionData.EXPRESSION_SIZE; i++) {
      _emojiMap['[${ExpressionData.expressionPath[i].name}]'] =
          '${ExpressionData.basePath}${ExpressionData.expressionPath[i].path}';
    }
  }

  final Map<String, String> _emojiMap = <String, String>{};

  Map<String, String> get emojiMap => _emojiMap;

  static EmojiUitl? _instance;

  static EmojiUitl get instance => _instance ??= EmojiUitl._();
}
