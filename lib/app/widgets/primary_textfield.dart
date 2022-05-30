import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum PrimaryTextFieldMode {
  never,
  whileEditing,
  hasText,
  always,
}

class PrimaryTextField extends StatefulWidget {
  /// Controller
  final TextEditingController? controller;

  /// 占位文本
  final String? hintText;
  final bool? enabled;
  
  /// 文字样式
  final TextStyle textStyle;  

  /// 占位文字颜色
  final Color hintColor;

  /// 隐藏输入
  final bool obscureText;

  final double? height;
  final double? width;

  /// 内间距
  final EdgeInsets? padding;

  /// 外间距
  final EdgeInsets? margin;

  /// 前缀
  final Widget? prefix;

  /// 后缀
  final Widget? suffix;

  /// 文本框距离 Prefix Suffix 的距离
  final double space;

  /// 最大字符数
  final int? maxLength;

  /// 最大行数
  final int? minLines;
  final int? maxLines;

  /// 键盘类型
  final TextInputType? keyboardType;

  /// 确认按钮类型
  final TextInputAction? textInputAction;

  /// 自动获得焦点
  final bool autofocus;

  /// 焦点控制
  final FocusNode? focusNode;
  final bool? showCursor;

  /// 容器样式
  final BoxDecoration? decoration;
  final BoxDecoration? activeDecoration;

  final TextAlign textAlign;

  final bool readOnly;

  final Color? cursorColor;

  final PrimaryTextFieldMode? clearButtonMode;

  /// 内容改变时
  final ValueChanged<String>? onChanged;
  final void Function()? onTap;

  /// 提交时
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<bool>? onChangeFocus;
  final List<TextInputFormatter>? inputFormatters;

  final ToolbarOptions? toolbarOptions;

  PrimaryTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.textStyle = const TextStyle(
      fontSize: 16,
    ),
    this.hintColor = const Color(0xFF84878D),
    this.padding = const EdgeInsets.symmetric(),
    this.margin,
    this.width,
    this.height,
    this.prefix,
    this.suffix,
    this.space = 0,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.autofocus = false,
    this.focusNode,
    this.decoration,
    this.activeDecoration,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.clearButtonMode = PrimaryTextFieldMode.never,
    this.onTap,
    this.obscureText = false,
    this.showCursor,
    this.cursorColor,
    this.onChangeFocus,
    this.enabled,
    this.toolbarOptions,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PrimaryTextFieldState();
  }
}

class PrimaryTextFieldState extends State<PrimaryTextField> {
  FocusNode? _focusNode;
  bool _hasFocus = false;

  TextEditingController? _controller;

  String? _text;

  @override
  void dispose() {
    removeListener();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    addListener();
  }

  // @override
  // void didUpdateWidget(covariant PrimaryTextField oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   removeListener();
  //   addListener();
  // }

  void addListener() {
    _focusNode = widget.focusNode ?? _focusNode ?? FocusNode();
    _focusNode!.addListener(_textFocusNodeListener);
    _controller = widget.controller ?? _controller ?? TextEditingController();
    _controller!.addListener(_textControllerListener);
    _text = _controller!.text;
  }

  void removeListener() {
    _focusNode?.removeListener(_textFocusNodeListener);
    _controller?.removeListener(_textControllerListener);
  }

  void _textFocusNodeListener() {
    setState(() {
      _hasFocus = _focusNode!.hasFocus;
    });
    if (widget.onChangeFocus != null) widget.onChangeFocus!(_hasFocus);
  }

  void _textControllerListener() {
    setState(() {
      _text = _controller?.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(widget.prefix ?? Container());
    children.add(Expanded(child: _buildInnerTextField(context)));
    children.add(_buildClearButton());
    children.add(widget.suffix ?? Container());

    return Container(
      margin: widget.margin,
      padding: widget.padding?.copyWith(top: 0, bottom: 0),
      decoration: _hasFocus == false ? widget.decoration : (widget.activeDecoration ?? widget.decoration),
      constraints: BoxConstraints(),
      height: widget.height,
      width: widget.width,
      child: Row(
        children: children,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }

  Widget _buildInnerTextField(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(hintColor: widget.hintColor),
      child: TextField(
        toolbarOptions: widget.toolbarOptions,
        enabled: widget.enabled ?? true,
        obscureText: widget.obscureText,
        readOnly: widget.readOnly,
        controller: _controller,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        autofocus: widget.autofocus,
        focusNode: _focusNode,
        style: widget.textStyle,
        textInputAction: widget.textInputAction,
        scrollPadding: EdgeInsets.all(0),
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        inputFormatters: widget.inputFormatters,
        textAlign: widget.textAlign,
        onTap: widget.onTap,
        showCursor: widget.showCursor,
        cursorColor: widget.cursorColor ?? Theme.of(context).textSelectionTheme.cursorColor,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.only(
            left: widget.space,
            right: widget.space,
            top: widget.padding?.top ?? 0,
            bottom: widget.padding?.bottom ?? 0,
          ),
          hintText: widget.hintText,
          border: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: widget.textStyle.copyWith(color: widget.hintColor),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    var clearButton = InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () {
        _controller?.clear();
      },
      child: Icon(Icons.cancel, color: Colors.black12),
    );

    switch (widget.clearButtonMode) {
      case PrimaryTextFieldMode.never:
        return Container();
      case PrimaryTextFieldMode.whileEditing:
        return Offstage(
          offstage: _hasFocus == false || _text?.length == 0,
          child: clearButton,
        );
      case PrimaryTextFieldMode.hasText:
        return Offstage(
          offstage: _text?.length == 0,
          child: clearButton,
        );
      case PrimaryTextFieldMode.always:
        return clearButton;
      default:
        break;
    }
    return Container();
  }
}
