import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class ProjectMediaCarousel extends StatelessWidget {
  const ProjectMediaCarousel({
    super.key,
    required List<String> networkImages,
    this.height = 200,
  }) : _networkImages = networkImages;

  final double height;
  final List<String> _networkImages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: _networkImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: kPrimaryColour80,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                margin: EdgeInsets.all(1),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image(
                  image: NetworkImage(_networkImages[index]),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            onTap: () {
              showImageViewerPager(
                swipeDismissible: true,
                backgroundColor: kBackgroundColour,
                useSafeArea: true,
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
