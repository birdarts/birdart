import 'package:birdart/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared/model/track.dart';

import '../tool/list_tool.dart';

class NewListPage extends StatefulWidget {
  const NewListPage({super.key});

  @override
  State<NewListPage> createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  Map<String, int> records = {};

  List<String> birds = List.generate(20, (index) => '鸟 $index');

  void _onCompleted() {
    // TODO: save list
  }

  void _getExpectedList() {
    // TODO: generate possible birds list
  }

  void _startTrack() {

  }

  @override
  void initState() {
    _getExpectedList();
    super.initState();
  }

  final titleSpace = const SizedBox(width: 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.normal,
        ),
        title: ListTool.tracker != null
            ? Row(
                children: [
                  const Icon(Icons.timeline_rounded),
                  titleSpace,
                  Text(ListTool.tracker!.track.getTimeText()),
                  titleSpace,
                  Text('${ListTool.tracker!.track.distance} km'),
                  titleSpace,
                  const Icon(Icons.add_location_rounded),
                  titleSpace,
                  Text(BdL10n.current.newListAutoHotspot),
                ],
              )
            : Row(
                children: [
                  const Icon(Icons.timeline_rounded),
                  titleSpace,
                  Text(BdL10n.current.newListTrackDisabled),
                  titleSpace,
                  const Icon(Icons.add_location_rounded),
                  titleSpace,
                  Text(BdL10n.current.newListAutoHotspot),
                ],
              ),
        bottom: AppBar(
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          leading: null,
          leadingWidth: 0,
          centerTitle: false,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: ListTile(
            leading: IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () {},
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: BdL10n.current.newListSearch,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.comment_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.check_circle_rounded),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCompleted,
        tooltip: BdL10n.current.save,
        child: const Icon(Icons.save_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          final name = birds[index];
          return ListTile(
            leading: IconButton(
              icon: records.containsKey(name)
                  ? Text(records[name].toString())
                  : const Icon(Icons.add_rounded),
              onPressed: () {
                setState(() {
                  if (records.containsKey(name)) {
                    records[name] = records[name]! + 1;
                  } else {
                    records[name] = 1;
                  }
                });
              },
            ),
            title: Text(name),
          );
        },
      ),
    );
  }
}

extension on Track {
  String getTimeText() {
    Duration difference = endTime.difference(startTime);
    return BdL10n.current.newListTrackDuration(difference.inHours, difference.inMinutes % 60);
  }
}
