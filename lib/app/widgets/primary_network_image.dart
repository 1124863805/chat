import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrimaryNetworkImage extends ExtendedImage {
  PrimaryNetworkImage(
    String? url, {
    Key? key,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    bool enableMemoryCache = true,
    String? defaultURL,
  }) : super.network(
          url != null && url.isNotEmpty ? url : (defaultURL ?? ''),
          fit: fit,
          width: width,
          height: height,
          borderRadius: borderRadius,
          enableMemoryCache: enableMemoryCache,
          shape: BoxShape.rectangle,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return Container(
                  color: Colors.transparent,
                  child: Center(
                    child: const CupertinoActivityIndicator(
                      animating: true,
                      radius: 10.0,
                    ),
                  ),
                );
              case LoadState.failed:
                return Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[300]),
                  ),
                );
              default:
                return null;
            }
          },
        );
}
