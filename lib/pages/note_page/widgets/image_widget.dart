import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final bool? isImageFromLocalStorage;
  final String? imagePathOrUrl;

  const ImageWidget(
      {Key? key,
      required this.isImageFromLocalStorage,
      required this.imagePathOrUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePathOrUrl == null) {
      /// user not selected any image while creating note
      return Icon(Icons.image,size: 120);
    }

    bool isLocalStorageImage = isImageFromLocalStorage == true;

    if (isLocalStorageImage) {
      /// shows image from local storage
      return Image.file(File(imagePathOrUrl!), fit: BoxFit.contain);
    }

    /// shows image from  firebase cloud storage url
    return CachedNetworkImage(
      fit: BoxFit.contain,
      imageUrl: imagePathOrUrl!,
      placeholder: (context, url) => Container(
          width: 100, height: 100, child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
