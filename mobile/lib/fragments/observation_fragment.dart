import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../db/db_manager.dart';
import '../db/project.dart';
import '../dialogs/qr_code.dart';
import '../entity/app_dir.dart';
import '../entity/color_scheme.dart';
import '../entity/server.dart';
import '../pages/edit_project_page.dart';
import '../pages/project_page.dart';
import '../widget/expandable_fab.dart';

class ObservationFragment extends StatefulWidget {
  const ObservationFragment({Key? key}) : super(key: key);

  @override
  State<ObservationFragment> createState() => _ObservationFragmentState();
}

class _ObservationFragmentState extends State<ObservationFragment>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`

  late Future _future;

  @override
  void initState() {
    _future = DbManager.db.projectDao.getAll();
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
          List<Project> projectList = List.generate(
              dataList.length, (index) => Project.fromJson(dataList[index]));
          for (var item in projectList) {
            final oldProject = await DbManager.db.projectDao.getById(item.id.hexString);
            if (oldProject.isNotEmpty) {
              projectList.remove(item);
            } else {
              item.coverImg = await downloadAndSaveImage(item.coverImg);
            }
          }
          await DbManager.db.projectDao.insertList(projectList);
          setState(() {
            _future = DbManager.db.projectDao.getAll();
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
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProject()))
                  .then((value) => setState(() {
                _future = DbManager.db.projectDao.getAll();
              }));
              },
            icon: const Icon(Icons.add_rounded),
          ),
          ActionButton(
            onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext dContext) => QrScanDialog(
                    onScan: (result) {
                      final codes = result.split('@');
                      final shareId = codes[0];
                      final projectId = codes[1];
                      _joinProject(shareId, projectId);
                    },
                    validator: (result) {
                      final codes = result.split('@');
                      if (codes.length != 2) {
                        Fluttertoast.showToast(msg: '二维码格式错误');
                        return false;
                      }
                      return true;
                    },
                  ));
              },
            icon: const Icon(Icons.qr_code_scanner_rounded),
          ),
        ],
      ),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectPage(
                                      project: projects[index])))
                              .then((value) {
                            if (value) {
                              setState(() {
                                _future = DbManager.db.projectDao.getAll();
                              });
                            }
                          });
                        },
                        child: getProjectItem(projects[index]),
                      ));
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

  Widget getProjectItem(Project project) => ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
    child: Card(
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: FileImage(File(project.coverImg)),
                      fit: BoxFit.cover),
                ),
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
                    project.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    project.notes,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 14, color: primaryColor),
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
              onTap: () => _showQrCode(project.id.hexString),
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
    if (projectId.isEmpty) {
      _qrCodeGetFailed('本地项目无法分享，请先进入上传页面同步项目。');
    }

    Dio dio = Server.dio;

    try {
      var response = await dio.get('/project/share', queryParameters: {
        'project': projectId,
      });
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString()); //3
        if (data['success'] = true) {
          String shareId = data['data']['_id'];
          if (context.mounted) {
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
    _qrCodeGetFailed('请检查网络');
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
                child: const Text('确认'),
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
          Project project = Project.fromJson(data['data']);
          final oldProject = await DbManager.db.projectDao.getById(project.id.hexString);
          if (oldProject.isNotEmpty) {
            _qrCodeGetFailed('项目已存在');
            return;
          } else {
            project.coverImg = await downloadAndSaveImage(project.coverImg);
            await DbManager.db.projectDao.insertOne(project);
            setState(() {
              _future = DbManager.db.projectDao.getAll();
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
    _qrCodeGetFailed('请检查网络');
  }
}
