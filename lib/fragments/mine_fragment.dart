import 'package:flutter/material.dart';

class MineFragment extends StatefulWidget {
  const MineFragment({Key? key}) : super(key: key);

  @override
  State<MineFragment> createState() => _MineFragmentState();
}

class _MineFragmentState extends State<MineFragment>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const Center(
      child: Text("我的"),
    );
  }
}
