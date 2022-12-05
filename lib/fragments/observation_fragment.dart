import 'package:flutter/material.dart';
import 'package:naturalist/entity/app_dir.dart';

class ObservationFragment extends StatefulWidget {
  const ObservationFragment({Key? key}) : super(key: key);

  @override
  State<ObservationFragment> createState() => _ObservationFragmentState();
}

class _ObservationFragmentState extends State<ObservationFragment>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('AppDir: ${AppDir.data}');

    return const Center(
      child: Text("观察"),
    );
  }
}
