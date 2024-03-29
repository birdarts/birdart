import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../l10n/l10n.dart';
import '../db/db_manager.dart';
import '../dialogs/qr_code.dart';
import '../entity/app_dir.dart';
import '../entity/server.dart';

class ListFragment extends StatefulWidget {
  const ListFragment({super.key});

  @override
  State<ListFragment> createState() => _ListFragmentState();
}

class _ListFragmentState extends State<ListFragment>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`

  late Future _future;

  @override
  void initState() {
    _future = DbManager.db.checklistDao.getAll();
    super.initState();
    _fetchProjects();
  }

  _fetchProjects() async {
    Dio dio = Server.dio;

    try {
      var response = await dio.get('/user/getProjectList');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString()); //3
        if (data['success'] = true) {
          List<dynamic> dataList = data['data']['list'];
          List<ChecklistData> projectList = List.generate(
              dataList.length, (index) => ChecklistData.fromJson(dataList[index]));

          final oldRemoval = projectList.map((e) async {
            final oldProjectList = await DbManager.db.checklistDao.getById(e.id);
            if (oldProjectList != null) {
              projectList.remove(e);
            }
          });
          await Future.wait(oldRemoval);

          await DbManager.db.checklistDao.insertList(projectList);
          setState(() {
            _future = DbManager.db.checklistDao.getAll();
          });
        }
      } else {}
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
    }
  }

  Future<String> downloadAndSaveImage(String url) async {
    Dio dio = Server.dio;

    final response = await dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final appDocDir = AppDir.data;
    final fileName = url.split('/').last.split('\\').last;
    final file = File('${appDocDir.path}/$fileName');
    await file.writeAsBytes(response.data);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: Text(BdL10n.current.recordsTitle)),
      body: RefreshIndicator(
        onRefresh: () => _fetchProjects(),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
            future: _future,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final projects = snapshot.data;
                if (projects != null) {
                  return ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              //Navigator.push(
                              //        context,
                              //        MaterialPageRoute(
                              //            builder: (context) => ListPage(
                              //                birdList: projects[index])))
                              //    .then((value) {
                              //  if (value) {
                              //    setState(() {
                              //      _future = DbManager.db.birdListDao.getAll();
                              //    });
                              //  }
                              //});
                            },
                            child: getProjectItem(projects[index]),
                          ));
                }
                return Center(child: Text(BdL10n.current.databaseError));
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget getProjectItem(ChecklistData project) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        child: Card(
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.createTime.toIso8601String(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        project.notes,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  child: const Icon(
                    Icons.qr_code_rounded,
                    size: 30,
                  ),
                  onTap: () => _showQrCode(project.id.toString()),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      );

  _showQrCode(String projectId) async {
    Dio dio = Server.dio;

    try {
      var response = await dio.get('/project/share', queryParameters: {
        'project': projectId,
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString()); //3
        if (data['success'] = true) {
          String shareId = data['data']['_id'];
          if (mounted) {
            showDialog<String>(
                context: context,
                builder: (BuildContext dContext) =>
                    QrCodeDialog('$shareId@$projectId'));
          }
          return;
        } else {
          _qrCodeGetFailed(data['message'].toString());
        }
        return;
      } else {}
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
    }
    _qrCodeGetFailed(BdL10n.current.networkError);
  }

  _qrCodeGetFailed(String text) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (dContext) {
          return AlertDialog(
            title: const Text('分享或加入项目失败'),
            content: Text(text),
            actions: [
              TextButton(
                child: Text(BdL10n.current.ok),
                onPressed: () {
                  Navigator.pop(dContext);
                },
              ),
            ],
          );
        },
      );
    }
  }

  _joinProject(String shareId, String projectId) async {
    Dio dio = Server.dio;

    try {
      var response = await dio.get('/project/join', queryParameters: {
        'project': projectId,
        'invitation': shareId,
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString()); //3
        if (data['success'] = true) {
          ChecklistData project = ChecklistData.fromJson(data['data']);
          final oldProject =
              await DbManager.db.checklistDao.getById(project.id.toString());
          if (oldProject != null) {
            _qrCodeGetFailed('项目已存在');
            return;
          } else {
            await DbManager.db.checklistDao.insertOne(project);
            setState(() {
              _future = DbManager.db.checklistDao.getAll();
            });
          }
          return;
        } else {
          _qrCodeGetFailed(data['message'].toString());
        }
        return;
      } else {}
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
    }
    _qrCodeGetFailed(BdL10n.current.networkError);
  }
}
