// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Book extends StatefulWidget {
  Book({this.url});

  final String url;

  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  var _showDownloadButton = false;

  @override
  Widget build(BuildContext context) {
    var _renderUrl =
        'https://images-na.ssl-images-amazon.com/images/P/${widget.url}.jpg';
    var _fullSizeUrl =
        'http://z2-ec2.images-amazon.com/images/P/${widget.url}.01.MAIN._SCRM_.jpg';
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (PointerEvent details) =>
          setState(() => _showDownloadButton = true),
      onHover: (PointerEvent details) =>
          setState(() => _showDownloadButton = true),
      onExit: (PointerEvent details) =>
          setState(() => _showDownloadButton = false),
      child: Stack(
        children: [
          Center(
            child: Image.network(
              _renderUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              // This endpoint doesn't return 404, it just returns an empty image. Which is annoying.
              errorBuilder: (context, child, stacktrace) {
                return Center(
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                  ),
                );
              },
            ),
          ),
          if (_showDownloadButton)
            Positioned(
              bottom: 0,
              left: 5,
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: ElevatedButton(
                  child: Icon(Icons.download_rounded),
                  onPressed: () => _addDownloadLink(_fullSizeUrl),
                ),
              ),
            )
        ],
      ),
    );
  }
}

void _addDownloadLink(String url) {
  html.AnchorElement anchorElement = new html.AnchorElement(href: url);
  anchorElement.download;
  anchorElement.target = '_blank';
  anchorElement.click();
  html.document.body.children.remove(anchorElement);
}
