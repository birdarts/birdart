import 'package:flutter/material.dart';
import '../pages/edit_record_page.dart';

import '../db/record.dart';
import '../tool/coordinator_tool.dart';
import '../widget/app_bars.dart';

class RecordPage extends StatefulWidget {
  final DbRecord place;

  const RecordPage({Key? key, required this.place}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`
  bool updateParent = false;
  late DbRecord record;

  @override
  void initState() {
    record = widget.place;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: anAppBar(
        title: ListTile(
          title: const Text(
            '观察记录',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            record.species,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditRecord(
                        record: record,
                        project: record.project.hexString,
                      ))).then((value) {
                if (value) {
                  updateParent = updateParent || value;
                  setState(() {});
                }
              });
            },
            icon: const Icon(
              Icons.edit_rounded,
            ),
          ),
        ]
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, updateParent);
          return updateParent;
        },
        child: Column(
          children: [
            _getTop(),
          ],
        ),
      ),
    );
  }

  Widget _getTop() => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(record.observeTime.toString()),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      );
}
