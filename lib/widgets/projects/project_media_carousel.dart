import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProjectMediaCarousel extends StatelessWidget {
  const ProjectMediaCarousel({
    super.key,
    required List<String> networkImages,
    this.height = 200,
    this.cornerRadius = 20,
    this.isEdit = false,
    this.leftMargin = 0,
  }) : _networkImages = networkImages;

  final double height;
  final double cornerRadius;
  final List<String> _networkImages;
  final bool isEdit;
  final double leftMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10, left: leftMargin, right: 0),
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        // shrinkWrap: true,
        itemCount: _networkImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: kPrimaryColour80,
                borderRadius: BorderRadius.circular(height / 10),
              ),
              child: Container(
                margin: EdgeInsets.all(1),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height / 10),
                ),
                child: CachedNetworkImage(
                  fadeInCurve: Curves.easeIn,
                  fadeInDuration: Duration(milliseconds: 0),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: kBackgroundColour,
                    highlightColor: kPrimaryColour70,
                    child: Container(
                      width: height * 1.5,
                      height: height,
                      color: kBackgroundColour,
                    ),
                  ),
                  imageUrl: _networkImages[index],
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
