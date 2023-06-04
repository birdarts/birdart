import 'dart:io';

import 'package:flutter/material.dart';
import '../db/record.dart';

import '../pages/edit_record_page.dart';
import '../pages/record_page.dart';

import '../db/db_manager.dart';
import '../db/bird_list.dart';
import '../entity/color_scheme.dart';
import '../pages/edit_project_page.dart';
import '../widget/app_bars.dart';
import '../widget/empty_box.dart';

class ProjectPage extends StatefulWidget {
  final BirdList project;

  const ProjectPage({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`
  bool updateParent = false;
  late Future _future;

  @override
  void initState() {
    _future = DbManager.db.recordDao.getByProject(widget.project.id.hexString);
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
            widget.project.name,
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
                      builder: (context) => EditProject(
                        project: widget.project,
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
                      builder: (context) => EditProject(
                        project: widget.project,
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
                    project: widget.project.id.hexString,
                  ))).then((value) => setState(() {
            _future =
                DbManager.db.recordDao.getByProject(widget.project.id.hexString);
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
                        DbManager.db.recordDao.getByProject(widget.project.id.hexString);
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
                          Expanded(
                            child: Text(
                              record.poi,
                              style:
                                  TextStyle(fontSize: 14, color: accentColor),
                            ),
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
}
