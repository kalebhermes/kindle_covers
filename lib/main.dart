import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
          crossAxisCount: 5,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 4.0,
          childAspectRatio: .75,
        ),
        itemBuilder: (context, index) {
          return Image.network(
              'http://z2-ec2.images-amazon.com/images/P/${asins[index]}.01.MAIN._SCRM_.jpg',
              // scale: 0.5,
              loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
        }
        // children: [...bookUrls.map((url) => Image.network(url, height: 150.0))],
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
        RaisedButton(
          child: Text('Submit'),
          onPressed: () => onSubmit(controller.text),
        ),
      ],
    );
  }
}

Future<void> downloadFile() async {
  Dio dio = Dio();
  await dio.download(
      'http://s3.cn-north-1.amazonaws.com.cn/sitbweb-cn/content/B07WYSGHC7/images/cover.jpg',
      '/test.jpeg');
}
