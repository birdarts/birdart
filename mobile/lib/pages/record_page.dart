import '../l10n/l10n.dart';
import 'package:flutter/material.dart';
import '../pages/edit_record_page.dart';
import 'package:shared/shared.dart';

class RecordPage extends StatefulWidget {
  final DbRecord record;

  const RecordPage({Key? key, required this.record}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool updateParent = false;
  late DbRecord record;

  @override
  void initState() {
    record = widget.record;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
          title: ListTile(
            title: Text(
              BdL10n.current.recordsTitle,
              style: const TextStyle(
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
                              project: record.project.toString(),
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
          ]),
      body: PopScope(
        onPopInvoked: (_) async {
          Navigator.pop(context, updateParent);
          // return updateParent;
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
