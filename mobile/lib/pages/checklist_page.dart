import 'dart:async';

import 'package:birdart/db/db_manager.dart';
import 'package:birdart/entity/user_profile.dart';
import 'package:birdart/pages/hotspot_select_page.dart';
import 'package:birdart/pages/record_details_page.dart';
import 'package:birdart/pages/track_map_page.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared/shared.dart';

import '../l10n/l10n.dart';
import '../tool/tracker.dart';
import '../tool/list_tool.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  bool loadComplete = false;
  late StreamController<bool> _streamController;

  String sortingOption = "smart sort";
  bool showRarities = false;

  Future<void> _onCompleted() async {
    _endTrack();

    if (ListTool.checklist != null) {
      await Future.wait([
        DbManager.db.checklistDao.insertOne(ListTool.checklist!),
        DbManager.db.dbRecordDao.insertList(ListTool.records)
      ]);
    }
    ListTool.checklist = null;
    ListTool.records = [];
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _getExpectedList() async {
    if (ListTool.birds.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        ListTool.birds = [
          BirdData(
              id: 'XIQUE',
              scientific: 'Pica serica',
              vernacular: '喜鹊',
              ordo: 'Pass',
              familia: 'Corv',
              genus: 'Pica'),
          BirdData(
              id: 'SONYA',
              scientific: 'Garrulus glandarius',
              vernacular: '松鸦',
              ordo: 'Pass',
              familia: 'Corv',
              genus: 'Garrulus'),
          BirdData(
              id: 'ZUOYA',
              scientific: 'Phasianus colchicus',
              vernacular: '雉鸡',
              ordo: 'Phasianidae',
              familia: 'Phasianidae',
              genus: 'Phasianus'),
          BirdData(
              id: 'KULIA',
              scientific: 'Columbina minuta',
              vernacular: '地鸽',
              ordo: 'Columbiformes',
              familia: 'Columbidae',
              genus: 'Columbina'),
          BirdData(
              id: 'ZHFEI',
              scientific: 'Turdus merula',
              vernacular: '乌鸫',
              ordo: 'Passeriformes',
              familia: 'Turdidae',
              genus: 'Turdus'),
          BirdData(
              id: 'HONMA',
              scientific: 'Eudromia elegans',
              vernacular: '红嘴鸥',
              ordo: 'Charadriiformes',
              familia: 'Laridae',
              genus: 'Eudromia'),
          BirdData(
              id: 'DONFA',
              scientific: 'Ciconia boyciana',
              vernacular: '东方白鹳',
              ordo: 'Ciconiiformes',
              familia: 'Ciconiidae',
              genus: 'Ciconia'),
        ]; // test only
        loadComplete = true;
      });
    }
  }

  void _startTrack() {
    if (ListTool.tracker == null) {
      ListTool.tracker = Tracker(context: context);
      ListTool.tracker?.startTrack();
    }
    ListTool.tracker?.callback = () {
      _streamController.add(true);
    };
  }

  void _endTrack() {
    if (ListTool.tracker != null) {
      ListTool.tracker?.endTrack();
      ListTool.checklist?.track = ListTool.tracker!.track.id;
      ListTool.tracker = null;
    }
  }

  @override
  void dispose() {
    ListTool.tracker?.callback = null;
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    _streamController = StreamController<bool>();
    _getExpectedList();
    _startTrack();
    ListTool.checklist =
        ListTool.checklist ?? Checklist.empty(UserProfile.id, ListTool.tracker!.track.id);
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
            if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              return Row(
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      List<LatLng> latlngList =
                          ListTool.tracker!.geoxml.wpts.map((e) => LatLng(e.lat!, e.lon!)).toList();
                      if (mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrackMapPage(layer: getLayer(latlngList))));
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.timeline_rounded),
                        titleSpace,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ListTool.tracker!.track.getTimeText()),
                            Text('${ListTool.tracker!.track.distance.toStringAsFixed(2)} km'),
                          ],
                        )
                      ],
                    ),
                  ),
                  titleSpace,
                  Expanded(
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HotspotSelectPage(
                                    initLatLng: ListTool.tracker!.geoxml.wpts.last)));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.add_location_rounded),
                          titleSpace,
                          Text(BdL10n.current.newListAutoHotspot),
                        ],
                      ),
                    ),
                  ),
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
              onPressed: _showBottomNotes,
            ),
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: _showBottomSetting,
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
        itemCount: ListTool.birds.length,
        itemBuilder: (context, index) {
          final bird = ListTool.birds[index];
          var record =
              ListTool.records.where((element) => element.speciesRef == bird.id).firstOrNull;
          recordInit() {
            setState(() {
              record = DbRecord.add(
                checklist: ListTool.checklist!.id,
                species: bird.scientific,
                speciesRef: bird.id,
                author: UserProfile.id,
              );
              ListTool.records.add(record!);
            });
          }

          removeRecord() {
            if (record != null) {
              setState(() {
                ListTool.records.remove(record);
                record = null;
              });
            }
          }

          return ListTile(
            onTap: () {
              if (record == null) {
                recordInit.call();
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecordDetail(
                            record: record!,
                            project: ListTool.checklist!.id,
                          ))).then((value) {
                // check if amount is zero, delete data.
                if (record!.amount <= 0) {
                  removeRecord();
                }
              });
            },
            onLongPress: () {
              if (record != null) {
                _showClearDialog(removeRecord);
              }
            },
            leading: IconButton(
              icon:
                  record != null ? Text(record!.amount.toString()) : const Icon(Icons.add_rounded),
              onPressed: () {
                setState(() {
                  if (record == null) {
                    recordInit.call();
                  } else {
                    record!.amount++;
                  }
                });
              },
            ),
            title: InkWell(
              child: Text(bird.vernacular),
            ),
          );
        },
      ),
    );
  }

  void _showBottomSetting() => showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text("Sorting Options:"),
                      ),
                      RadioListTile(
                        title: Text("Smart Sort"),
                        value: "smart sort",
                        groupValue: sortingOption,
                        onChanged: (value) {
                          setState(() {
                            sortingOption = value!;
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text("Taxonomic Sort"),
                        value: "taxonomic sort",
                        groupValue: sortingOption,
                        onChanged: (value) {
                          setState(() {
                            sortingOption = value!;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: Text("Show Rarities"),
                        value: showRarities,
                        onChanged: (value) => setState(() {
                          showRarities = value;
                        }),
                      ),
                      ListTile(
                        title: Text("Observation Type"),
                        subtitle: Text(ListTool.checklist!.type),
                        onTap: () => _showObservationTypeDialog(setState),
                      ),
                    ],
                  ),
                )),
      );

  void _showObservationTypeDialog(Function setState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Observation Type"),
          content: Column(
            children: [
              ListTile(
                title: Text("Observation Type 1"),
                onTap: () {
                  setState(() {
                    ListTool.checklist!.type = "Observation Type 1";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Observation Type 2"),
                onTap: () {
                  setState(() {
                    ListTool.checklist!.type = "Observation Type 2";
                  });
                  Navigator.pop(context);
                },
              ),
              // Add more observation types as needed
            ],
          ),
        );
      },
    );
  }

  void _showBottomNotes() => showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) => StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const ListTile(
                  title: Text('Comments'),
                ),
                TextField(
                  onChanged: (val) => ListTool.checklist?.notes = val,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '详细描述您的问题',
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ),
      );

  void _showClearDialog(void Function() clear) => showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                title: const Text('Clear Data'),
                onTap: () async {
                  clear.call();
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
      );
}

extension on TrackData {
  String getTimeText() {
    Duration difference = endTime.difference(startTime);
    return BdL10n.current.newListTrackDuration(difference.inHours, difference.inMinutes % 60);
  }
}
