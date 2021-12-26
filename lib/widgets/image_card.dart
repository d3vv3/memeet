// import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:memeet/theme/colors.dart';

class ImageCard extends StatelessWidget {
  final String resourceURL;

  const ImageCard({Key? key, required this.resourceURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 14.0,
            spreadRadius: -13.0,
            color: Colors.black54,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: resourceURL.endsWith('.mp4')
            ? null
            : Image.network(
                resourceURL,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}

List<ImageCard> generateCards(List<String> images) {
  return List.generate(
    images.length,
    (index) {
      return ImageCard(
        resourceURL: images[index],
      );
    },
  );
}
