import 'package:flutter/material.dart';

import '../sizes.dart';
import 'book.dart';

class BookGrid extends StatelessWidget {
  final List<String> asins;

  BookGrid({required this.asins});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: asins.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _getNumberOfGridColumns(context),
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 25.0,
            childAspectRatio: .75,
          ),
          itemBuilder: (context, index) {
            return Book(
              url: asins[index],
            );
          },
        ),
      ),
    );
  }
}

int _getNumberOfGridColumns(BuildContext context) {
  if (isExtraLargeScreen(context)) {
    return 9;
  } else if (isLargeScreen(context)) {
    return 7;
  } else if (isMediumScreen(context)) {
    return 5;
  } else {
    return 4;
  }
}
