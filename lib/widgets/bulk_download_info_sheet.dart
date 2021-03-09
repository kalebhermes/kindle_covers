import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class BulkDownloadInfoSheet extends StatelessWidget {
  final List<String> urls;

  BulkDownloadInfoSheet({this.urls});

  final MarkdownStyleSheet theme = MarkdownStyleSheet(
    code: TextStyle(
      color: Colors.black,
      background: Paint()..color = Colors.grey[300],
    ),
  );

  @override
  Widget build(BuildContext context) {
    String urlList = urls
        .map((url) =>
            '\"http://z2-ec2.images-amazon.com/images/P/${url.replaceAll('\n', '')}.01.MAIN._SCRM_.jpg\"')
        .join('\n');

    final _markdownMessage = '''
  # Download High Resolution Book Covers
If you want to download all of your book covers quikcly and easily, click the button below to copy the code in the codeblock to your clipboard. After it's coppied, you can save it in a new file on your machine. Be sure to use the `.sh` file extension when saving it, something like `download.sh`. Then simply open a terminal, `cd` to the directory where you saved your file, and run `bash download.sh`.
  ''';
    final _codeToBeCopied = '''
declare -a arr=($urlList)

for i in "\${arr[@]}"
do
   curl -O \$i

done
''';
    final _markdownCodeBlock = '''
```
$_codeToBeCopied
```
''';
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Markdown(
              shrinkWrap: true,
              data: _markdownMessage,
              styleSheet: theme,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: ElevatedButton(
                child: Text('Copy to clipboard'),
                onPressed: () => {
                  Clipboard.setData(new ClipboardData(text: _codeToBeCopied)),
                },
              ),
            ),
            Markdown(
              shrinkWrap: true,
              data: _markdownCodeBlock,
              styleSheet: theme,
            ),
          ],
        ),
      ),
    );
  }
}
