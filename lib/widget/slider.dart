import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// Modified based on following url, originally distributed under MIT license,
// original authors listed in repository commit history.
// https://github.com/serenader2014/flutter_carousel_slider

// 构建轮播条部分
class CustomSlider extends StatefulWidget {
  CustomSlider({
    super.key,
    required this.titleImageList,
  }) {
    imageSliders = List.generate(
      titleImageList.length,
      (index) => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 6.0,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(titleImageList[index].image),
                      fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container( //gradient
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Text(
                    titleImageList[index].title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<SliderItem> titleImageList;
  late final List<Widget> imageSliders;

  @override
  State<StatefulWidget> createState() {
    return _CustomSliderState();
  }
}

class _CustomSliderState extends State<CustomSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: widget.imageSliders,
        carouselController: _controller,
        options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: false,
            aspectRatio: 2.5,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.titleImageList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 6.0,
              height: 6.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}

class SliderItem {
  String title, image;
  SliderItem(this.title, this.image);
}
