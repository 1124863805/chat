// 单图的
import 'package:bot_toast/bot_toast.dart';
import 'package:chat/app/widgets/primary_sheet_menu.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'image_util.dart';

class LPhotoView {
  // 单图片
  static void toPhotoViewSimple(
      BuildContext context, ImageProvider imageProvider) {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return PhotoViewSimpleScreen(
        heroTag: 'simple',
        imageProvider: imageProvider,
      );
    }));
  }

// 多图片的
  static void toPhotoViewGallery(BuildContext context, List<String> imgs,
      {int? index}) {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return PhotoViewGalleryScreen(
        images: imgs, //传入图片list
        index: index ?? 0, //传入当前点击的图片的index
        heroTag: "simple", //传入当前点击的图片的hero tag （可选）
      );
    }));
  }
}

class PhotoViewSimpleScreen extends StatelessWidget {
  const PhotoViewSimpleScreen({
    this.imageProvider, //图片
    this.backgroundDecoration, //背景修饰
    this.minScale, //最大缩放倍数
    this.maxScale, //最小缩放倍数
    this.heroTag, //hero动画tagid
  });

  final ImageProvider? imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: PhotoView(
                imageProvider: imageProvider,
                backgroundDecoration: backgroundDecoration,
                minScale: minScale,
                maxScale: maxScale,
                heroAttributes: PhotoViewHeroAttributes(tag: heroTag!),
                enableRotation: true,
              ),
            ),
            Positioned(
              //右上角关闭按钮
              right: 10,
              top: MediaQuery.of(context).padding.top,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 多图的
class PhotoViewGalleryScreen extends StatefulWidget {
  List images = [];
  int? index = 0;
  String? heroTag;
  PageController? controller;

  PhotoViewGalleryScreen(
      {Key? key,
      required this.images,
      this.index,
      this.controller,
      this.heroTag})
      : super(key: key) {
    controller = PageController(initialPage: index!);
  }

  @override
  _PhotoViewGalleryScreenState createState() => _PhotoViewGalleryScreenState();
}

class _PhotoViewGalleryScreenState extends State<PhotoViewGalleryScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.index!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
                child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      ExtendedNetworkImageProvider(widget.images[index]),
                  heroAttributes: widget.heroTag!.isNotEmpty
                      ? PhotoViewHeroAttributes(tag: widget.heroTag!)
                      : null,
                );
              },
              itemCount: widget.images.length,
              backgroundDecoration: null,
              pageController: widget.controller,
              enableRotation: true,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            )),
          ),
          if (widget.images.length > 1)
            Positioned(
              //图片index显示
              top: MediaQuery.of(context).padding.top + 15,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text("${currentIndex + 1}/${widget.images.length}",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          Positioned(
            //右上角关闭按钮
            right: 10,
            top: MediaQuery.of(context).padding.top,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 30,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            right: 30,
            bottom: MediaQuery.of(context).padding.bottom + 20,
            child: IconButton(
              icon: Icon(
                Icons.more_horiz,
                size: 60,
                color: Colors.red,
              ),
              onPressed: () async {
                PrimarySheetMenu.show(
                  context,
                  items: [
                    PrimarySheetMenuItem(
                      title: '保存到相册',
                      onTap: () async {
                        await ImageUtil.saveImage(
                            context, widget.images[currentIndex]);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
