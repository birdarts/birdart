import 'dart:async';

import '../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xid/xid.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared/shared.dart';

import '../entity/user_profile.dart';
import '../db/db_manager.dart';
import '../tool/image_tool.dart';
import '../widget/picture_grid.dart';

class EditRecord extends StatefulWidget {
  final DbRecord? record;
  final String project;

  const EditRecord({Key? key, this.record, required this.project})
      : super(key: key);

  @override
  State<EditRecord> createState() => _EditRecordState();
}

class _EditRecordState extends State<EditRecord> {
  final _formKey = GlobalKey<FormState>();
  final _pictureKey = GlobalKey<PictureGridState>();

  List<AssetEntity> initialImages = [];
  List<DbImage> oldImages = [];

  late final Widget pictureGrid;
  var _isNew = false;
  late DbRecord record;
  late Future<void>? _imageFuture;
  late final TextEditingController noteController;

  @override
  void initState() {
    pictureGrid = PictureGrid(
      key: _pictureKey,
      initialImages: initialImages,
    );

    if (widget.record != null) {
      record = widget.record!;
      _imageFuture = imageGridFuture();
    } else {
      _isNew = true;
      record = DbRecord.add(
          project: Xid.fromString(widget.project),
          species: '',
          speciesRef: '',
          notes: '',
          tags: [],
          author: UserProfile.id);

      _imageFuture = emptyFuture();
    }
    noteController = TextEditingController(text: record.notes);

    super.initState();
  }

  @override
  void dispose() {
    // clear controller resources
    noteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      FocusManager.instance.primaryFocus?.unfocus();

      final pictureGrid = _pictureKey.currentState;
      if (pictureGrid == null) {
        Fluttertoast.showToast(
          msg: BdL10n.current.loginAppError,
          toastLength: Toast.LENGTH_SHORT,
        );
        return;
      }

      if (_isNew) {
        DbManager.db.recordDao.insertOne(record);
      } else {
        DbManager.db.recordDao.updateOne(record);
      }

      final result =
          await imageMapForEach('place', pictureGrid, oldImages, record.id);

      if (result == 1) {
        Fluttertoast.showToast(
          msg: "保存成功",
          toastLength: Toast.LENGTH_SHORT,
        );
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      } else {
        Fluttertoast.showToast(
          msg: "保存失败",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    }
  }

  Future<void> imageGridFuture() async {
    oldImages = await DbManager.db.imageDao.getByRecord(record.id.toString());
    for (DbImage image in oldImages) {
      final assetEntity = await AssetEntity.fromId(image.imageId);
      if (assetEntity != null) {
        initialImages.add(assetEntity);
      }
    }

    pictureGrid = PictureGrid(
      key: _pictureKey,
      initialImages: initialImages,
    );
  }

  Widget _getSpeciesSelector() => TextFormField(
        onSaved: (val) => {
          if (val != null) {record.species = val}
        },
        validator: (val) => val == null || val.isEmpty ? '本项不能为空' : null,
        enabled: true,
        initialValue: record.species,
        decoration: const InputDecoration(labelText: '物种'),
      );

  Future<void> emptyFuture() async {}

  Widget _showTitle() {
    return Text(
      _isNew ? '添加记录' : '修改记录',
    );
  }

  Widget _getImageGrid() => StatefulBuilder(
      builder: (context, setState) => FutureBuilder(
          future: _imageFuture,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return pictureGrid;
            } else {
              return const LinearProgressIndicator();
            }
          }));

  Widget _getTimeItem() => Row(
        children: [
          const Icon(
            Icons.access_time_filled_rounded,
            color: Colors.green,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(record.observeTime.toString(),
              style: const TextStyle(fontSize: 18)),
        ],
      );

  Widget _getNoteItem() => StatefulBuilder(builder: (context, setState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: TextFormField(
              controller: noteController,
              onSaved: (val) => {
                if (val != null) {record.notes = val}
              },
              decoration: const InputDecoration(
                labelText: '备注',
              ),
            )),
            const SizedBox(
              width: 12,
            ),
          ],
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showTitle(),
        actions: [
          IconButton(
            onPressed: () {
              _submitForm(context);
            },
            icon: const Icon(
              Icons.save_rounded,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: false,
            children: [
              _getSpeciesSelector(),
              const SizedBox(
                height: 12,
              ),
              _getImageGrid(),
              _getTimeItem(),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 12,
              ),
              const SizedBox(
                height: 12,
              ),
              _getNoteItem(),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
