import 'dart:io';

import 'package:civil_project/constants/constantdecorations.dart';
import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  final String address;

  const ImageView({Key key, this.address}) : super(key: key);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: urlDetection(widget.address) == true
          ? Center(
              child: InteractiveViewer(
                boundaryMargin:  EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 1.8,
                child: Image.network(
                  widget.address,
                ),
              ),
            )
          : Center(
              child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.1,
                  maxScale: 1.8,
                  child: Image.file(File(widget.address)))),
    );
  }
}
