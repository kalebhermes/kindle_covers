// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kindle_covers/sizes.dart';
import 'package:kindle_covers/constants.dart';

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
      debugShowCheckedModeBanner: false,
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
  TextEditingController _controller = TextEditingController();
  bool _isTextFieldVisible = true;
  bool _isInfoCardVisible = false;
  List<String> _asins = [];

  void onSubmit(String listOfAsins) async {
    setState(() {
      _asins = listOfAsins.replaceAll(' ', '').split(',');
      if (_asins.length > 0 && _asins.elementAt(0) != '') {
        _isTextFieldVisible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        leading: !_isTextFieldVisible
            ? IconButton(
                icon: Icon(Icons.chevron_left),
                color: Colors.white,
                onPressed: () => setState(
                      () => {_isTextFieldVisible = true, _controller.text = ''},
                    ))
            : SizedBox.shrink(),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.info_outline_rounded),
        //     color: Colors.white,
        //     onPressed: () => {
        //       showModalBottomSheet(
        //           context: context, builder: (context) => InfoSheet())
        //     },
        //   ),
        // ],
      ),
      body: Center(
        // Having two footers sucks, but because of the nature of the GridView, one needed to be expanded while the other couldn't be
        child: _isTextFieldVisible
            ? Column(
                children: [
                  AsinEntryFrom(controller: _controller, onSubmit: onSubmit),
                  Expanded(child: Footer())
                ],
              )
            : Column(children: [
                BookCovers(asins: _asins),
                Footer(),
              ]),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: SizedBox(
        height: 35,
        child: Container(
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '© Kaleb Hermes ${DateTime.now().year}',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
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
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Scrollbar(
          child: GridView.builder(
            shrinkWrap: true,
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
          ),
        ),
      ),
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
                  child: Icon(Icons.download_outlined),
                  onPressed: () => _addDownloadLink(_fullSizeUrl),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'Start by visiting '),
                _buildTextSpan('read.amazon.com', 'https://read.amazon.com'),
                TextSpan(text: '. After logging in, open your browser\'s '),
                _buildTextSpan('Developer Tools',
                    'https://balsamiq.com/support/faqs/browserconsole/'),
                TextSpan(text: ' and executing the code '),
                _buildTextSpan(
                  'found here',
                  'https://raw.githubusercontent.com/kalebhermes/kindle_covers/main/get_kindle_books.js',
                ),
                TextSpan(
                    text:
                        ' in the console. A list of Amazon Standard Identification Numbers (ASIN) will be copied to your clipbard. Come back and paste that list here. Then click \'Submit\'!'),
              ],
            ),
          ),
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () => onSubmit(controller.text),
            ),
            ElevatedButton(
              child: Text('Demo - Most Popular Kindle Books'),
              onPressed: () => onSubmit(topBooks),
            ),
          ],
        ),
      ],
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

int _getNumberOfGridColumns(BuildContext context) {
  if (isExtraLargeScreen(context)) {
    return 7;
  } else if (isLargeScreen(context)) {
    return 5;
  } else if (isMediumScreen(context)) {
    return 4;
  } else {
    return 3;
  }
}

class InfoSheet extends StatelessWidget {
  var _markdown = r'''
  # Wow
  This is some test line of strings
  `single line code block`
  ``` 
  multi line codeblock
  console.log('something else');
  print('this thing');
  ```

  *Bold*
  _Italic_
  ''';

  MarkdownStyleSheet theme = MarkdownStyleSheet(
      code: TextStyle(
          color: Colors.black, background: Paint()..color = Colors.blue));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        child: Markdown(
          data: _markdown,
          styleSheet: theme,
        ),
      ),
    );
  }
}

TextSpan _buildTextSpan(String text, String url) {
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  return TextSpan(
    text: text,
    style: TextStyle(color: Colors.lightBlue),
    recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
  );
}
