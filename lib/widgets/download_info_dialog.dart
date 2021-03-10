import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadInfoDialog extends StatelessWidget {
  final List<String> asins;

  DownloadInfoDialog({this.asins});

  @override
  Widget build(BuildContext context) {
    var _urlList;
    var _codeToBeCopied;

    return IconButton(
      icon: Icon(Icons.download_rounded),
      color: Colors.white,
      onPressed: () async => {
        _urlList = asins
            .map((url) =>
                '\"http://z2-ec2.images-amazon.com/images/P/${url.replaceAll('\n', '')}.01.MAIN._SCRM_.jpg\"')
            .join('\n'),
        _codeToBeCopied = '''
declare -a arr=($_urlList)

for i in "\${arr[@]}"
do
   curl -O \$i

done''',
        await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            titlePadding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 12.0),
            contentPadding: EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 9,
                    child: Text('Download High Resolution Book Covers')),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text:
                            'If you want to download all of your book covers with a single command, click the button below to copy the code in the codeblock to your clipboard. After it\'s coppied, you can save it in a new file on your machine. Be sure to use the '),
                    CodeSpan(text: '.sh'),
                    TextSpan(
                        text:
                            ' file extension when saving it, something like '),
                    CodeSpan(text: 'download.sh'),
                    TextSpan(text: '. Then simply open a terminal, '),
                    CodeSpan(text: 'cd'),
                    TextSpan(
                        text:
                            ' to the directory where you saved your file, and run '),
                    CodeSpan(text: 'bash download.sh'),
                    TextSpan(text: '.')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: ElevatedButton(
                  child: Text('Copy to clipboard'),
                  onPressed: () => {
                    Clipboard.setData(new ClipboardData(text: _codeToBeCopied)),
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                      text: CodeSpan(text: _codeToBeCopied),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      },
    );
  }
}

class CodeSpan extends TextSpan {
  final String text;
  CodeSpan({this.text})
      : super(
          text: text,
          style: GoogleFonts.getFont(
            'Source Code Pro',
            backgroundColor: Colors.grey[300],
          ),
        );
}
