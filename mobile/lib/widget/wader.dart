import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WaderSvg extends StatelessWidget {
  const WaderSvg({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/svg/shorebird.svg',
        semanticsLabel: 'Acme Logo');
  }
}
