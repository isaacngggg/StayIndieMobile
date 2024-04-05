import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class ProjectMediaCarousel extends StatelessWidget {
  const ProjectMediaCarousel({
    super.key,
    required List<String> networkImages,
  }) : _networkImages = networkImages;

  final List<String> _networkImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: _networkImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.only(right: 10),
              decoration: kOutlineBorder,
              child: Image.network(_networkImages[index]),
            ),
            onTap: () {
              showImageViewerPager(
                context,
                MultiImageProvider(_networkImages
                    .map((image) => NetworkImage(image))
                    .toList()),
              );
            },
          );
        },
      ),
    );
  }
}
