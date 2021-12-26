import 'package:flutter/material.dart';

import 'package:memeet/theme/colors.dart';
import 'package:memeet/pages/feed.dart';

import 'package:flutter_svg/flutter_svg.dart';

class Root extends StatefulWidget {
  const Root({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      backgroundColor: white,
      body: getBody(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: const [Feed(), Feed(), Feed(), Feed()],
    );
  }

  PreferredSizeWidget? getAppBar() {
    var items = [
      pageIndex == 0
          ? "assets/images/explore_active_icon.svg"
          : "assets/images/explore_icon.svg",
      pageIndex == 1
          ? "assets/images/likes_active_icon.svg"
          : "assets/images/likes_icon.svg",
      pageIndex == 2
          ? "assets/images/chat_active_icon.svg"
          : "assets/images/chat_icon.svg",
      pageIndex == 3
          ? "assets/images/account_active_icon.svg"
          : "assets/images/account_icon.svg",
    ];
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          return IconButton(
            onPressed: () {
              setState(() {
                pageIndex = index;
              });
            },
            icon: SvgPicture.asset(items[index]),
          );
        }),
      ),
    );
  }
}
