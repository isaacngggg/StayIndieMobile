import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaCarousel extends StatefulWidget {
  const MediaCarousel({
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
  State<MediaCarousel> createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  List<bool> _imageLoadingStates = [];
  void initState() {
    super.initState();
    _imageLoadingStates = List.filled(
        widget._networkImages.length, true); // Start with all images loading
  }

  bool _areAllImagesLoaded() {
    return _imageLoadingStates.every((loading) => loading == false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10, left: widget.leftMargin, right: 0),
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        // shrinkWrap: true,
        itemCount: widget._networkImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: kPrimaryColour80,
                borderRadius: BorderRadius.circular(widget.height / 10),
              ),
              child: Container(
                margin: EdgeInsets.all(1),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.height / 10),
                ),
                child: CachedNetworkImage(
                  fadeInCurve: Curves.easeIn,
                  fadeInDuration: Duration(milliseconds: 0),
                  imageUrl: widget._networkImages[index],
                  fit: BoxFit.fitHeight,
                  imageBuilder: (context, imageProvider) {
                    _imageLoadingStates[index] = false; // Mark image as loaded
                    return Image(image: imageProvider);
                  },
                ),
              ),
            ),
            onTap: () {
              showImageViewerPager(
                swipeDismissible: true,
                backgroundColor: kBackgroundColour,
                useSafeArea: true,
                context,
                MultiImageProvider(widget._networkImages
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

class MediaCarouselState with ChangeNotifier {
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  void setLoaded() {
    _isLoaded = true;
    notifyListeners();
  }
}
