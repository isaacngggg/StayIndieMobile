import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class StoryScreen extends StatefulWidget {
  final String meta;
  final String title;
  final String body;
  final List<String> images;
  static String id = 'storyscreen';
  final List<String> setimages = [
    'assets/image1.png',
    'assets/image2.png',
    'assets/image3.png',
    // Add more image paths as needed
  ];

  StoryScreen({
    required this.meta,
    required this.title,
    required this.body,
    required this.images,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/profile_example.jpeg'),
          ),
        ),
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.close), onPressed: () {}),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Colors.black, width: 2))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text(widget.meta,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                      Text(widget.title,
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w500)),
                      Text(widget.body,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                // Row(
                //   children: [
                //     // TextField(
                //     //   decoration: const InputDecoration(
                //     //     fillColor: Colors.black,
                //     //     border: UnderlineInputBorder(),
                //     //     labelText: 'Comment',
                //     //   ),
                //     // )
                //   ],
                // ),
                //   CarouselSlider(
                //     options: CarouselOptions(height: 300,enableInfiniteScroll: false, viewportFraction: 0.9, enlargeFactor: 2, autoPlay: true,pageSnapping: false),
                //     items: [1,2,3,4,5].map((i) {
                //       return Builder(
                //         builder: (BuildContext context) {
                //           return GestureDetector(
                //             child: Container(
                //               width: MediaQuery.of(context).size.width,
                //               margin: EdgeInsets.symmetric(horizontal: 5.0),
                //               decoration: BoxDecoration(
                //                 color: Colors.grey,
                //                 border: Border.all(color: Colors.black38,width: 0.1),
                //                 borderRadius: BorderRadius.all(Radius.circular(10)),

                //               ),
                //               child: Image(image: AssetImage('assets/image1.png'),
                //               fit: BoxFit.fitHeight,

                //               )
                //                     ),
                //             onTap: () {
                //               print ('$i Tapped');
                //             },
                //           );
                //       },
                //     );
                //   }).toList(),
                // ),
                Positioned.fill(
                  bottom: 80,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.orange,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Container(
                              color: Colors.red,
                            ),
                            onTap: () {
                              print('forward');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ExpandableCarousel(
                  options: CarouselOptions(
                    showIndicator: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 2),
                  ),
                  items: widget.setimages.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image(
                              image: AssetImage(i),
                              fit: BoxFit.fitHeight,
                              height: 300,
                            ));
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 30,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                            labelText: 'Comment',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.favorite_border),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.more_vert),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
