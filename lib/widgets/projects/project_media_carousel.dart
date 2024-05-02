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
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(right: 10),
                decoration: kOutlineBorder.copyWith(color: Colors.white),
                child: Image(
                  image: NetworkImage(_networkImages[index]),
                  fit: BoxFit.fitHeight,
                )
                // Image.network(_networkImages[index]).fit(BoxFit.contain),
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
