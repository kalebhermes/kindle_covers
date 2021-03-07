// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:kindle_covers/sizes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kindle Book Covers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Kindle Book Covers'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  bool isTextFieldVisible = true;
  List<String> asins = [];

  void onSubmit(String listOfAsins) async {
    setState(() {
      asins = listOfAsins.replaceAll(' ', '').split(',');
      if (asins.length > 0 && asins.elementAt(0) != '') {
        isTextFieldVisible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10.0),
        child: Center(
          child: isTextFieldVisible
              ? AsinEntryFrom(controller: controller, onSubmit: onSubmit)
              : BookCovers(asins: asins),
        ),
      ),
    );
  }
}

class BookCovers extends StatelessWidget {
  final List<String> asins;

  BookCovers({this.asins});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: asins.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getNumberOfGridColumns(context),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 4.0,
        childAspectRatio: .75,
      ),
      itemBuilder: (context, index) {
        return Book(
          url: asins[index],
        );
      },
    );
  }
}

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
        'http://z2-ec2.images-amazon.com/images/P/${widget.url}.jpg';
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
          Image.network(_renderUrl,
              // scale: 0.5,
              loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
          if (_showDownloadButton)
            Positioned(
              bottom: 0,
              left: 5,
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: Expanded(
                  child: ElevatedButton(
                    child: Icon(Icons.download_outlined),
                    onPressed: () => downloadFile(_fullSizeUrl),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class AsinEntryFrom extends StatelessWidget {
  final TextEditingController controller;
  final Function onSubmit;

  AsinEntryFrom({this.controller, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(12),
          child: TextField(
            controller: controller,
            maxLines: 25,
            decoration: InputDecoration(
              hintText: "Enter a comma seperated list of ASIN",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
        ),
        ElevatedButton(
          child: Text('Submit'),
          onPressed: () => onSubmit(controller.text),
        ),
      ],
    );
  }
}

void downloadFile(String url) {
  html.AnchorElement anchorElement = new html.AnchorElement(href: url);
  anchorElement.download;
  anchorElement.target = '_blank';
  anchorElement.click();
  html.document.body.children.remove(anchorElement);
}

int _getNumberOfGridColumns(BuildContext context) {
  if (isLargeScreen(context)) {
    return 5;
  } else if (isMediumScreen(context)) {
    return 4;
  } else {
    return 3;
  }
}
