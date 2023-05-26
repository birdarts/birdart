import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SvgPicture.asset(
        'assets/svg/shorebird.svg',
        semanticsLabel: 'Acme Logo'
    );
  }
}
