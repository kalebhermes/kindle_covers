// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
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
  var _isMobile = (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android);

  @override
  Widget build(BuildContext context) {
    var _renderUrl =
        'https://images-na.ssl-images-amazon.com/images/P/${widget.url}.jpg';
    var _fullSizeUrl =
        'http://z2-ec2.images-amazon.com/images/P/${widget.url}.01.MAIN._SCRM_.jpg';

    var bookStack = BookStack(
      renderUrl: _renderUrl,
      fullSizeUrl: _fullSizeUrl,
      showDownloadButton: _showDownloadButton,
    );
    return _isMobile
        ? MobileHoverWrapper(
            onTap: () =>
                setState(() => _showDownloadButton = !_showDownloadButton),
            child: bookStack,
          )
        : DesktopHoverWrapper(
            onEnter: () => setState(() => _showDownloadButton = true),
            onHover: () => setState(() => _showDownloadButton = true),
            onExit: () => setState(() => _showDownloadButton = false),
            child: bookStack,
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

class BookStack extends StatelessWidget {
  final String renderUrl;
  final String fullSizeUrl;
  final bool showDownloadButton;

  BookStack({this.renderUrl, this.fullSizeUrl, this.showDownloadButton});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 7,
                  blurRadius: 15,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Image.network(
              renderUrl,
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
        ),
        if (showDownloadButton)
          Positioned(
            bottom: 5,
            left: 5,
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: ElevatedButton(
                child: Icon(Icons.download_rounded),
                onPressed: () => _addDownloadLink(fullSizeUrl),
              ),
            ),
          )
      ],
    );
  }
}

class DesktopHoverWrapper extends StatelessWidget {
  final Widget child;
  final Function onEnter;
  final Function onHover;
  final Function onExit;

  DesktopHoverWrapper({this.child, this.onEnter, this.onHover, this.onExit});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.basic,
        onEnter: (PointerEvent details) => onEnter(),
        onHover: (PointerEvent details) => onHover(),
        onExit: (PointerEvent details) => onExit(),
        child: child);
  }
}

class MobileHoverWrapper extends StatelessWidget {
  final Widget child;
  final Function onTap;

  MobileHoverWrapper({this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: child,
    );
  }
}
