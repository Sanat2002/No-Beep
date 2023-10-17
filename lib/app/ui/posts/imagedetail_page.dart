import 'package:flutter/material.dart';
import 'package:neep/app/ui/widgets/image_circular_loader.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetail extends StatefulWidget {
  String imageUrl;
  int tag;
  ImageDetail({Key? key, required this.imageUrl, required this.tag})
      : super(key: key);

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          child: Hero(
        tag: widget.tag,
        child: PhotoView(
          loadingBuilder: (context, event) {
            return ImagePlaceHolder();
          },
          imageProvider: NetworkImage(widget.imageUrl),
        ),
      )),
    );
  }
}
