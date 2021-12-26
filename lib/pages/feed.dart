import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tcard/tcard.dart';

import 'package:memeet/theme/colors.dart';
import 'package:memeet/data/icons.dart';
import 'package:memeet/widgets/image_card.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:video_player/video_player.dart';

Future<List<String>> _getMemes() async {
  String imgurAPI = dotenv.env['IMGUR_API'] ?? '';
  String imgurClientID = dotenv.env['IMGUR_CLIENT_ID'] ?? '';
  var url = Uri.https(imgurAPI, '/3/g/memes/top/week');
  var response = await http.get(url,
      headers: {HttpHeaders.authorizationHeader: 'Client-ID $imgurClientID'});
  var responseData = jsonDecode(response.body)['data'];
  List memes = [];
  for (var item in responseData) {
    if (item['is_album'] == true) {
      for (var image in item['images']) {
        memes.add(image);
      }
    } else {
      continue;
    }
  }
  if (kDebugMode) {
    print(memes);
  }

  List validMemes =
      memes.where((meme) => !meme['link'].endsWith('.mp4')).toList();
  List<String> memeLinks =
      validMemes.map<String>((meme) => meme['link']).toList();
  return memeLinks;
}

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: const Body(),
      bottomSheet: getFooter(),
    );
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 100,
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(itemIcons.length, (index) {
            return Container(
              height: 50,
              width: 50,
              // color: Theme.of(context).backgroundColor,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: SvgPicture.asset(
                    itemIcons[index]["icon"],
                    width: itemIcons[index]["icon_size"],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TCardController _controller = TCardController();
  late Future<List<String>> images;
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    images = _getMemes();
  }

  //TODO: Create Cards widget as stateless

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<List<String>>(
      future: images,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: SizedBox(
              height: size.height,
              child: Center(
                child: TCard(
                  size: Size(size.width, size.height),
                  cards: generateCards(snapshot.data!),
                  controller: _controller,
                  delaySlideFor: 100,
                  onForward: (index, info) {
                    if (info.direction == SwipDirection.Right) {
                      if (kDebugMode) {
                        print('$index swipped right front');
                      }
                    } else {
                      if (kDebugMode) {
                        print('$index swipped left front');
                      }
                    }
                  },
                  onBack: (index, info) {
                    if (kDebugMode) {
                      print('$index swipped back');
                    }
                  },
                  onEnd: () async {
                    if (kDebugMode) {
                      print('end');
                    }
                    setState(() {
                      images = _getMemes();
                    });
                    _controller.reset(cards: generateCards(snapshot.data!));
                  },
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: SizedBox(
            height: size.height,
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
