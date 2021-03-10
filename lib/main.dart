import 'package:flutter/material.dart';

import 'widgets/book_grid.dart';
import 'widgets/download_info_dialog.dart';
import 'widgets/footer.dart';
import 'widgets/asin_entry_form.dart';

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
  List<String> _asins = [];

  void onSubmit(String listOfAsins) async {
    setState(() {
      _asins = listOfAsins.replaceAll(' ', '').split(',');
      if (_asins.last == '') _asins.removeLast();
      if (_asins.length > 0 && _asins.elementAt(0) != '') {
        _isTextFieldVisible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      bottom: true,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          leading: !_isTextFieldVisible
              ? IconButton(
                  icon: Icon(Icons.chevron_left),
                  color: Colors.white,
                  onPressed: () => setState(
                        () =>
                            {_isTextFieldVisible = true, _controller.text = ''},
                      ))
              : SizedBox.shrink(),
          actions: !_isTextFieldVisible
              ? [
                  DownloadInfoDialog(asins: _asins),
                ]
              : [],
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
                  BookGrid(asins: _asins),
                  Footer(),
                ]),
        ),
      ),
    );
  }
}
