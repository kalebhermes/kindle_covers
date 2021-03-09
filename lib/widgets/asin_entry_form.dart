import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

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
            maxLines: 15,
            decoration: InputDecoration(
              hintText: "Enter a comma seperated list of ASIN",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
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

MouseRegionTextSpan _buildTextSpan(String text, String url) {
  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  return MouseRegionTextSpan(
    textSpan: TextSpan(
      text: text,
      style: TextStyle(color: Colors.lightBlue),
      recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
    ),
  );
}

class MouseRegionTextSpan extends WidgetSpan {
  MouseRegionTextSpan({
    @required InlineSpan textSpan,
  }) : super(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text.rich(
              textSpan,
            ),
          ),
        );
}
