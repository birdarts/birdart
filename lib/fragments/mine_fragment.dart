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

    return Center(
        child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/icon/icon.png'),
                    fit: BoxFit.fill),
              ),
            ),
            const Text(
              '注册/登陆',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
        const Divider(),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 15.0),
              child: Icon(
                Icons.settings_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Text('设置')
          ],
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 15.0),
              child: Icon(
                Icons.cloud_download_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Text('数据管理')
          ],
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 15.0),
              child: Icon(
                Icons.info_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Text('关于')
          ],
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20.0, 15.0, 10.0, 15.0),
              child: Icon(
                Icons.code_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Text('查看源代码')
          ],
        ),
      ],
    ));
  }
}
