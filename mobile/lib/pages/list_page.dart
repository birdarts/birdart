import 'dart:io';

import 'package:flutter/material.dart';
import '../db/record.dart';

import '../pages/edit_record_page.dart';
import '../pages/record_page.dart';

import '../db/db_manager.dart';
import '../db/bird_list.dart';
import '../entity/color_scheme.dart';
import '../pages/edit_list_page.dart';
import '../tool/coordinator_tool.dart';
import '../widget/app_bars.dart';
import '../widget/empty_box.dart';

class ListPage extends StatefulWidget {
  final BirdList birdList;

  const ListPage({Key? key, required this.birdList}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`
  bool updateParent = false;
  late Future _future;

  @override
  void initState() {
    _future = DbManager.db.recordDao.getByProject(widget.birdList.id.hexString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: anAppBar(
        title: ListTile(
          title: const Text(
            '调查项目',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            widget.birdList.name,
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
                      builder: (context) => EditList(
                        birdList: widget.birdList,
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
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditList(
                        birdList: widget.birdList,
                      ))).then((value) {
                if (value) {
                  updateParent = updateParent || value;
                  setState(() {});
                }
              });
            },
            icon: const Icon(
              Icons.cancel_rounded,
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditRecord(
                    project: widget.birdList.id.hexString,
                  ))).then((value) => setState(() {
            _future =
                DbManager.db.recordDao.getByProject(widget.birdList.id.hexString);
          }));
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, updateParent);
          return updateParent;
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
            future: _future,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<DbRecord>? records = snapshot.data;
                if (records != null) {
                  if (records.isEmpty) {
                    return const EmptyBox();
                  }
                  return ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) =>
                          getPlaceItem(records[index]));
                }
                return const Center(child: Text('数据库错误'));
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget getPlaceItem(DbRecord record) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        child: Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecordPage(
                            place: record,
                          ))).then((value) {
                if (value) {
                  setState(() {
                    _future =
                        DbManager.db.recordDao.getByProject(widget.birdList.id.hexString);
                  });
                }
              });
            },
            child: SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: FutureBuilder(
                      future: DbManager.db.imageDao.getByRecord(record.id.hexString),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final images = snapshot.data;
                          if (images != null) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    image: FileImage(File(images[0].imagePath)),
                                    fit: BoxFit.cover),
                              ),
                            );
                          }
                          return const Center(child: Text('数据库错误'));
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.species,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.place_rounded,
                            color: accentColor,
                          ),
                        ],
                      ),
                      Text(
                        record.observeTime.toString(),
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      );

  //Text(
  //'经度: ${CoordinateTool().degreeToDms(birdList.lat.toString())}     纬度: ${CoordinateTool().degreeToDms(record.lon.toString())}'),
  //Wrap(children: [
  //Text('${record.country} ${record.province} ${record.city} ${record.county} ${record.poi}'),
  //]),
}
