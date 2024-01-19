import 'dart:async';

import 'package:birdart/entity/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../l10n/l10n.dart';
import '../tool/tracker.dart';
import '../tool/list_tool.dart';

class NewListPage extends StatefulWidget {
  const NewListPage({super.key, this.birdList});

  final Checklist? birdList;

  @override
  State<NewListPage> createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  List<DbRecord> records = [];

  List<Bird> birds = [];
  bool loadComplete = false;
  late Checklist birdList;
  late StreamController<bool> _streamController;

  void _onCompleted() {
    _endTrack();
    // TODO: save list
  }


  Future<void> _getExpectedList() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      birds = [
        Bird(id: 'XIQUE', scientific: 'Pica serica', vernacular: '喜鹊', ordo: 'Pass', familia: 'Corv', genus: 'Pica'),
        Bird(id: 'SONYA', scientific: 'Garrulus glandarius', vernacular: '松鸦', ordo: 'Pass', familia: 'Corv', genus: 'Garrulus'),
        Bird(id: 'ZUOYA', scientific: 'Phasianus colchicus', vernacular: '雉鸡', ordo: 'Phasianidae', familia: 'Phasianidae', genus: 'Phasianus'),
        Bird(id: 'KULIA', scientific: 'Columbina minuta', vernacular: '地鸽', ordo: 'Columbiformes', familia: 'Columbidae', genus: 'Columbina'),
        Bird(id: 'ZHFEI', scientific: 'Turdus merula', vernacular: '乌鸫', ordo: 'Passeriformes', familia: 'Turdidae', genus: 'Turdus'),
        Bird(id: 'HONMA', scientific: 'Eudromia elegans', vernacular: '红嘴鸥', ordo: 'Charadriiformes', familia: 'Laridae', genus: 'Eudromia'),
        Bird(id: 'DONFA', scientific: 'Ciconia boyciana', vernacular: '东方白鹳', ordo: 'Ciconiiformes', familia: 'Ciconiidae', genus: 'Ciconia'),
      ]; // test only
      loadComplete = true;
    });
  }

  void _startTrack() {
    if (ListTool.tracker == null) {
      ListTool.tracker = Tracker(context: context);
      ListTool.tracker?.startTrack(
        callback: () {
          _streamController.add(true);
        }
      );
    }
  }

  void _endTrack() {
    if (ListTool.tracker != null) {
      ListTool.tracker?.endTrack();
    }
  }

  @override
  void initState() {
    _streamController = StreamController<bool>();
    _getExpectedList();
    _startTrack();
    birdList = widget.birdList ?? Checklist.empty(UserProfile.id, ListTool.tracker!.track.id);
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
        title: StreamBuilder(
          stream: _streamController.stream,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active) {
              return Row(
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
              );
            } else {
              return Row(
                children: [
                  const Icon(Icons.timeline_rounded),
                  titleSpace,
                  Text(BdL10n.current.newListTrackDisabled),
                  titleSpace,
                  const Icon(Icons.add_location_rounded),
                  titleSpace,
                  Text(BdL10n.current.newListAutoHotspot),
                ],
              );
            }
          },
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
        itemCount: birds.length,
        itemBuilder: (context, index) {
          final bird = birds[index];
          final record = records.where((element) => element.speciesRef == bird.id).firstOrNull;
          return ListTile(
            leading: IconButton(
              icon: record != null
                  ? Text(record.amount.toString())
                  : const Icon(Icons.add_rounded),
              onPressed: () {
                setState(() {
                  if (record == null) {
                    records.add(DbRecord.add(project: birdList.id, species: bird.scientific, speciesRef: bird.id, notes: '', author: UserProfile.id, tags: []));
                  } else {
                    record.amount ++;
                  }
                });
              },
            ),
            title: Text(bird.vernacular),
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
