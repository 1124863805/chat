import 'package:flutter/material.dart';

///表情组件
class WeChatExpression extends StatelessWidget {
  ///一行表情数量
  final int crossAxisCount;

  //纵轴间距
  final double mainAxisSpacing;

  //横轴间距
  final double crossAxisSpacing;

  ///子Widget宽高比例
  final double childAspectRatio;

  ///大小比例,值的大小与表情的大小成反比
  final double bigSizeRatio;

  final CallClick _callClick;

  WeChatExpression(this._callClick,
      {this.crossAxisCount = 8,
        this.mainAxisSpacing = 2.0,
        this.crossAxisSpacing = 2.0,
        this.childAspectRatio = 1.0,
        this.bigSizeRatio = 8.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.custom(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: this.crossAxisCount,
          mainAxisSpacing: this.mainAxisSpacing,
          crossAxisSpacing: this.crossAxisSpacing,
        ),
        childrenDelegate: SliverChildBuilderDelegate((context, position) {
          return _getExpressionItemContainer(position);
        }, childCount: ExpressionData.EXPRESSION_SIZE),
      ),
    );
  }

  ///获取表情列表
  _getExpressionItemContainer(int index) {
    var expressionPath = ExpressionData.expressionPath[index];
    return AExpression(expressionPath, this.bigSizeRatio, this._callClick);
  }
}

///单个表情
class AExpression extends StatelessWidget {
  Expression expression;

  ///大小比例,值的大小与表情的大小成反比
  final double bigSizeRatio;

  final CallClick _callClick;

  AExpression(this.expression, this.bigSizeRatio, this._callClick);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.all(bigSizeRatio),
        onPressed: () {
          _callClick(expression);
        },
        child: Image.asset(
          ExpressionData.basePath + expression.path,
        ),
      ),
    );
  }
}

///点击之后
typedef void CallClick(Expression expression);

///表情对象
class Expression {
  final String name;
  final String path;

  ///标识是否是emoji表情,true是,默认false
  final bool isEmoji;

  Expression(this.name, this.path, {this.isEmoji = false});
}

///数据类
class ExpressionData {
  ///基础路径
  static String basePath = "assets/chat_content/expression/";

  ///表情路径
  static final List<Expression> expressionPath = [
    Expression('微笑', 'hehe.png'),
    Expression('撇嘴', 'piezui.png'),
    Expression('色', 'se.png'),
    Expression('发呆', 'fadai.png'),
    Expression('得意', 'deyi.png'),
    Expression('流泪', 'liulei.png'),
    Expression('害羞', 'haixiu.png'),
    Expression('闭嘴', 'bizui.png'),
    Expression('睡', 'shui.png'),
    Expression('大哭', 'daku.png'),
    Expression('尴尬', 'ganga.png'),
    Expression('发怒', 'fanu.png'),
    Expression('调皮', 'tiaopi.png'),
    Expression('呲牙', 'ciya.png'),
    Expression('惊讶', 'jingya.png'),
    Expression('难过', 'nanguo.png'),
    Expression('囧', 'jiong.png'),
    Expression('抓狂', 'zhuakuang.png'),
    Expression('吐', 'tu.png'),
    Expression('偷笑', 'touxiao.png'),
    Expression('愉快', 'yukuai.png'),
    Expression('白眼', 'baiyan.png'),
    Expression('傲慢', 'aoman.png'),
    Expression('困', 'kun.png'),
    Expression('惊恐', 'jingkong.png'),
    Expression('流汗', 'liuhan.png'),
    Expression('憨笑', 'hanxiao.png'),
    Expression('悠闲', 'youxian.png'),
    Expression('奋斗', 'fendou.png'),
    Expression('咒骂', 'zhouma.png'),
    Expression('疑问', 'yiwen.png'),
    Expression('嘘', 'xu.png'),
    Expression('晕', 'yun.png'),
    Expression('衰', 'sui.png'),
    Expression('骷髅', 'kulou.png'),
    Expression('敲打', 'qiaoda.png'),
    Expression('再见', 'zaininmadejian.png'),
    Expression('擦汗', 'cahan.png'),
    Expression('抠鼻', 'koubi.png'),
    Expression('鼓掌', 'guzhang.png'),
    Expression('坏笑', 'huaixiao.png'),
    Expression('左哼哼', 'zuohengheng.png'),
    Expression('右哼哼', 'youhengheng.png'),
    Expression('哈欠', 'haqian.png'),
    Expression('鄙视', 'bishi.png'),
    Expression('委屈', 'weiqu.png'),
    Expression('快哭了', 'kuaikule.png'),
    Expression('阴险', 'yinxian.png'),
    Expression('亲亲', 'qinqin.png'),
    Expression('可怜', 'kelian.png'),
    Expression('菜刀', 'caidao.png'),
    Expression('西瓜', 'xigua.png'),
    Expression('啤酒', 'pijiu.png'),
    Expression('咖啡', 'kafei.png'),
    Expression('猪头', 'zhutou.png'),
    Expression('玫瑰', 'meigui.png'),
    Expression('凋谢', 'diaoxie.png'),
    Expression('嘴唇', 'zuichun.png'),
    Expression('爱心', 'aixin.png'),
    Expression('心碎', 'xinsui.png'),
    Expression('蛋糕', 'dangao.png'),
    Expression('炸弹', 'zhadan.png'),
    Expression('便便', 'bianbian.png'),
    Expression('月亮', 'yueliang.png'),
    Expression('太阳', 'taiyang.png'),
    Expression('拥抱', 'yongbao.png'),
    Expression('强', 'qiang.png'),
    Expression('弱', 'ruo.png'),
    Expression('握手', 'woshou.png'),
    Expression('胜利', 'shengli.png'),
    Expression('抱拳', 'baoquan.png'),
    Expression('勾引', 'gouyin.png'),
    Expression('拳头', 'quantou.png'),
    Expression('OK', 'ok.png'),
    Expression('跳跳', 'tiaotiao.png'),
    Expression('发抖', 'fadou.png'),
    Expression('怄火', 'ohuo.png'),
    Expression('转圈', 'zhuanquan.png'),
    Expression('嘿哈', 'heiha.png'),
    Expression('捂脸', 'wulian.png'),
    Expression('奸笑', 'jianxiao.png'),
    Expression('机智', 'jizhi.png'),
    Expression('皱眉', 'zhoumei.png'),
    Expression('耶', 'ye.png'),
    Expression('蜡烛', 'lazhu.png'),
    Expression('红包', 'hongbao.png'),
    Expression('吃瓜', 'chigua.png'),
    Expression('加油', 'jiayou.png'),
    Expression('汗', 'han.png'),
    Expression('天啊', 'tiana.png'),
    Expression('Emm', 'emm.png'),
    Expression('社会社会', 'shehuishehui.png'),
    Expression('旺柴', 'wangchai.png'),
    Expression('好的', 'haode.png'),
    Expression('打脸', 'dalian.png'),
    Expression('加油加油', 'jiayoujiayou.png'),
    Expression('哇', 'wa.png'),
    Expression('發', 'fa.png'),
    Expression('福', 'fu.png'),
    Expression('鸡', 'ji.png'),
  ];


  ///格式化消息
  // static String format(String msg) {}

  ///表情总长度
  // ignore: non_constant_identifier_names
  static final int EXPRESSION_SIZE = expressionPath.length;
}
