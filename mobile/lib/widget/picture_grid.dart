import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PictureGrid extends StatefulWidget {
  const PictureGrid({super.key, this.initialImages});

  final List<AssetEntity>? initialImages;

  @override
  State<PictureGrid> createState() => PictureGridState();
}

class PictureGridState extends State<PictureGrid> {
  List<AssetEntity> imageData = []; //用来存储图片数据

  @override
  void initState() {
    if (widget.initialImages != null && widget.initialImages!.isNotEmpty) {
      imageData = widget.initialImages!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index == imageData.length) {
          return InkWell(
            child: const Icon(
              Icons.image_rounded,
              size: 40,
            ),
            onTap: () async {
              final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: AssetPickerConfig(
                  maxAssets: 9,
                  requestType: RequestType.image,
                  selectedAssets: imageData,
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
                for (var resultItem in result) {
                  if (!imageData
                      .any((dataItem) => dataItem.id == resultItem.id)) {
                    setState(() {
                      imageData.add(resultItem);
                    });
                  }
                }
                for (var dataItem in imageData) {
                  if (!result
                      .any((resultItem) => dataItem.id == resultItem.id)) {
                    setState(() {
                      imageData.remove(dataItem);
                    });
                  }
                }
              }
            },
          );
        } else if (index < imageData.length) {
          return GestureDetector(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Hero(
                tag: 'chatImage$index',
                child: FutureBuilder(
                  future: imageData[index].file,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final file = snapshot.data;
                      if (file != null) {
                        return Image.file(
                          file,
                          fit: BoxFit.cover,
                        );
                      }
                      return const Center(child: Text('数据库错误'));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context0) => AlertDialog(
                  content: const Text('移除该图片？'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          imageData.removeAt(index);
                        });
                      },
                      child: const Text('确认'),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return null;
      },
      itemCount: imageData.length + 1,
    );
  }

  List<AssetEntity> getImageData() => imageData;
}

class CameraPickerIcon extends StatelessWidget {
  const CameraPickerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera_alt_rounded),
      iconSize: 36,
      onPressed: () async {
        final AssetEntity? result = await CameraPicker.pickFromCamera(context);
        if (result == null) {
          return;
        }
        if (context.mounted) {
          final AssetPicker<AssetEntity, AssetPathEntity> picker =
              context.findAncestorWidgetOfExactType()!;
          final DefaultAssetPickerBuilderDelegate builder =
              picker.builder as DefaultAssetPickerBuilderDelegate;
          final DefaultAssetPickerProvider p = builder.provider;
          await p.switchPath(
            PathWrapper<AssetPathEntity>(
              path: await p.currentPath!.path.obtainForNewProperties(),
            ),
          );
          p.selectAsset(result);
        }
      },
    );
  }
}

String path2Name(AssetPathEntity path) {
  Map<String, String> map = {
    'Bluetooth': '蓝牙',
    'Camera': '相机',
    'DCIM': '相机',
    'Documents': '文档',
    'Download': '下载',
    'Pictures': '图像',
    'Recent': '最近',
    'Screenshots': '截图',
    'Wechat': '微信',
    'weiboIntl_image': '微博国际版',
    'WeiXin': '微信',
  };

  if (map.containsKey(path.name)) {
    final name = map[path.name];
    if (name != null) {
      return name;
    }
  }

  return path.name;
}
