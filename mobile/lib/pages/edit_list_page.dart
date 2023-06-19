import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../db/bird_list.dart';
import '../db/db_manager.dart';
import '../tianditu/geocoder.dart';
import '../tool/coordinator_tool.dart';
import '../tool/location_tool.dart';
import '../widget/picture_grid.dart';

class EditList extends StatefulWidget {
  final BirdList? birdList;

  const EditList({Key? key, this.birdList}) : super(key: key);

  @override
  State<EditList> createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  final _formKey = GlobalKey<FormState>();
  var _isNew = false;
  late BirdList birdList;

  @override
  void initState() {
    if (widget.birdList != null) {
      birdList = widget.birdList!;
    } else {
      _isNew = true;
      birdList = BirdList.add(name: '', notes: '', coverImg: '', lon: 0.0, lat: 0.0, ele: 0.0, country: '', province: '', city: '', county: '', poi: '', );
    }
    super.initState();
    _getCurrentLocation(context);
  }

  Widget _showTitle() {
    return Text(
      _isNew ? '新建项目' : '修改项目',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _getLocationItem() => Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
          '经度: ${CoordinateTool.degreeToDms(birdList.lat.toString())}',
          style: const TextStyle(fontSize: 18)),
      const SizedBox(
        height: 12,
      ),
      Text(
          '纬度: ${CoordinateTool.degreeToDms(birdList.lon.toString())}',
          style: const TextStyle(fontSize: 18)),
      const SizedBox(
        height: 12,
      ),
      Text('海拔: ${birdList.ele.toStringAsFixed(3)}',
          style: const TextStyle(fontSize: 18)),
      const SizedBox(
        height: 12,
      ),
      Text('${birdList.country} ${birdList.province} ${birdList.city} ${birdList.county}',
          style: const TextStyle(fontSize: 18)),
      TextFormField(
        onSaved: (val) => {
          if (val != null) {birdList.poi = val}
        },
        validator: (val) => val == null || val.isEmpty
            ? '本项不能为空'
            : null,
        enabled: true,
        initialValue: birdList.poi,
        decoration:
        const InputDecoration(labelText: '地址'),
      ),
    ],
  );

  Future<void> _getCurrentLocation(BuildContext context) async {
    Position? locationData = await getCurrentLocation(context);

    if (locationData != null) {
      birdList.lat = locationData.latitude;
      birdList.lon = locationData.longitude;
      birdList.ele = locationData.altitude;
      final addresses = await Geocoder.getFromLocation(
          locationData.latitude, locationData.longitude);
      if (addresses.isNotEmpty) {
        birdList.country = addresses[0].nation;
        birdList.province = addresses[0].province;
        birdList.city = addresses[0].city;
        birdList.county = addresses[0].county;
        birdList.poi = addresses[0].address;
      }
      return;
    }
  }

  Widget _showProjectInput() {
    return TextFormField(
      initialValue: birdList.name,
      onSaved: (val) => {
        if (val != null) {birdList.name = val}
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
      initialValue: birdList.notes,
      onSaved: (val) => {
        if (val != null) {birdList.notes = val}
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
                          Theme.of(context).primaryColor,
                          light: true,
                        ),
                        pathNameBuilder: path2Name,
                      ),
                    );
                    if (result != null && result.isNotEmpty) {
                      String? path = (await result.first.file)?.path;
                      if (path != null) {
                        setState(() {
                          birdList.coverImg = path;
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
                        Shadow(color: Theme.of(context).primaryColor, blurRadius: 8),
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
    if (birdList.coverImg.isEmpty) {
      return const CachedNetworkImageProvider(
          'https://www.inaturalist.org/assets/homepage-science-aaf702330877209eb4380c3021f9e8176e48fcd9006ac6e317919332901176cd.jpg');
    } else {
      return FileImage(File(birdList.coverImg));
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    final form = _formKey.currentState;
    if (birdList.coverImg.isEmpty) {
      Fluttertoast.showToast(
        msg: "请点击封面图设置项目封面。",
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }
    if (form != null && form.validate()) {
      form.save();
      final db = DbManager.db;
      birdList.sync = false;
      if (_isNew) {
        db.birdListDao.insertOne(birdList);
      } else {
        db.birdListDao.updateOne(birdList);
      }
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }
}
