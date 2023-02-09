import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../db/project.dart';
import '../db/db_manager.dart';
import '../entity/color_scheme.dart';
import '../widget/picture_grid.dart';

class EditProject extends StatefulWidget {
  final Project? project;

  const EditProject({Key? key, this.project}) : super(key: key);

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  final _formKey = GlobalKey<FormState>();
  var _isNew = false;
  late Project project;

  @override
  void initState() {
    if (widget.project != null) {
      project = widget.project!;
    } else {
      _isNew = true;
      project = Project.add(name: '', notes: '', coverImg: '');
    }
    super.initState();
  }

  Widget _showTitle() {
    return Text(
      _isNew ? '新建项目' : '修改项目',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _showProjectInput() {
    return TextFormField(
      initialValue: project.name,
      onSaved: (val) => {
        if (val != null) {project.name = val}
      },
      validator: (val) =>
          val == null || val.length < 4 ? '项目名过短，请至少包含4个字符' : null,
      decoration: const InputDecoration(
        labelText: '名称',
        icon: Icon(Icons.text_format_rounded),
      ),
    );
  }

  Widget _showRemarkInput() {
    return TextFormField(
      initialValue: project.notes,
      onSaved: (val) => {
        if (val != null) {project.notes = val}
      },
      decoration: const InputDecoration(
        labelText: '备注',
        icon: Icon(Icons.short_text_rounded),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _getImageProvider(),
                      ),
                    ),
                  ),
                  onTap: () async {
                    final List<AssetEntity>? result =
                        await AssetPicker.pickAssets(
                      context,
                      pickerConfig: AssetPickerConfig(
                        maxAssets: 1,
                        requestType: RequestType.image,
                        specialItemPosition: SpecialItemPosition.prepend,
                        specialItemBuilder: (context, path, length) =>
                            const CameraPickerIcon(),
                        textDelegate: const AssetPickerTextDelegate(),
                        pickerTheme: AssetPicker.themeData(
                          primaryColor,
                          light: true,
                        ),
                        pathNameBuilder: path2Name,
                      ),
                    );
                    if (result != null && result.isNotEmpty) {
                      String? path = (await result.first.file)?.path;
                      if (path != null) {
                        setState(() {
                          project.coverImg = path;
                        });
                      }
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _showTitle(),
                      _showProjectInput(),
                      _showRemarkInput(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 12.0,
                  left: 12.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 8.0,
                  child: IconButton(
                    onPressed: () {
                      _submitForm(context);
                    },
                    icon: Icon(
                      Icons.save_rounded,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: primaryColor, blurRadius: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (project.coverImg.isEmpty) {
      return const CachedNetworkImageProvider(
          'https://www.inaturalist.org/assets/homepage-science-aaf702330877209eb4380c3021f9e8176e48fcd9006ac6e317919332901176cd.jpg');
    } else {
      return FileImage(File(project.coverImg));
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    final form = _formKey.currentState;
    if (project.coverImg.isEmpty) {
      Fluttertoast.showToast(
        msg: "请点击封面图设置项目封面。",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }
    if (form != null && form.validate()) {
      form.save();
      final db = DbManager.db;
      project.sync = false;
      if (_isNew) {
        db.projectDao.insertOne(project);
      } else {
        db.projectDao.updateOne(project);
      }
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }
}
