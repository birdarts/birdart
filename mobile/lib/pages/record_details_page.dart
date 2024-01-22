import 'dart:async';

import '../l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared/shared.dart';

import '../entity/user_profile.dart';
import '../db/db_manager.dart';
import '../tool/image_tool.dart';
import '../widget/picture_grid.dart';

class RecordDetail extends StatefulWidget {
  final DbRecord record;
  final String project;

  const RecordDetail({Key? key, required this.record, required this.project})
      : super(key: key);

  @override
  State<RecordDetail> createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail> {
  final _formKey = GlobalKey<FormState>();

  late DbRecord record;
  late final TextEditingController noteController;
  TextEditingController quantityController = TextEditingController();
  List<String> tags = [];
  Map<String, Map<String, int>> birdInfo = {
    '幼鸟': {'雄性': 0, '雌性': 0, '性别不详': 0},
    '未成年': {'雄性': 0, '雌性': 0, '性别不详': 0},
    '成年': {'雄性': 0, '雌性': 0, '性别不详': 0},
    '年龄不详': {'雄性': 0, '雌性': 0, '性别不详': 0},
  };
  String oilBirdStatus = '';
  String breedingCode = '';

  @override
  void initState() {
    record = widget.record;
    noteController = TextEditingController(text: record.notes);

    super.initState();
  }

  @override
  void dispose() {
    // clear controller resources
    noteController.dispose();
    super.dispose();
  }

  Future<void> emptyFuture() async {}

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
        title: const Text('Record details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: '数量*'),
              ),
              SizedBox(height: 16),
              Wrap(
                children: [
                  buildChip('看到'),
                  buildChip('听到'),
                  buildChip('拍照'),
                  buildChip('录音'),
                  buildChip('瞥到'),
                  buildChip('他人看到'),
                  buildChip('他人听到'),
                  buildChip('他人辨识'),
                  buildChip('不计入我的鸟种列表'),
                ],
              ),
              SizedBox(height: 16),
              buildBirdInfoTable(),
              SizedBox(height: 16),
              buildOilBirdStatusRadio(),
              SizedBox(height: 16),
              buildBreedingCodeDropdown(),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: '文字备注'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChip(String label) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FilterChip(
        label: Text(label),
        onSelected: (selected) {
          setState(() {
            if (selected) {
              tags.add(label);
            } else {
              tags.remove(label);
            }
          });
        },
        selected: tags.contains(label),
      ),
    );
  }

  Widget buildBirdInfoTable() {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        buildTableRow(''),
        buildTableRow('幼鸟', birdInfo['幼鸟']),
        buildTableRow('未成年', birdInfo['未成年']),
        buildTableRow('成年', birdInfo['成年']),
        buildTableRow('年龄不详', birdInfo['年龄不详']),
      ],
    );
  }

  TableRow buildTableRow(String header, [Map<String, int>? data]) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(header),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data?['雄性'].toString() ?? ''),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data?['雌性'].toString() ?? ''),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data?['性别不详'].toString() ?? ''),
          ),
        ),
      ],
    );
  }

  Widget buildOilBirdStatusRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('沾油鸟'),
        RadioListTile(
          title: Text('未沾油污'),
          value: '未沾油污',
          groupValue: oilBirdStatus,
          onChanged: (value) {
            setState(() {
              oilBirdStatus = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('沾有油污，但状态没有明显不佳'),
          value: '沾有油污，但状态没有明显不佳',
          groupValue: oilBirdStatus,
          onChanged: (value) {
            setState(() {
              oilBirdStatus = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('沾有油污，状态明显不佳'),
          value: '沾有油污，状态明显不佳',
          groupValue: oilBirdStatus,
          onChanged: (value) {
            setState(() {
              oilBirdStatus = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('不能确定是否沾油'),
          value: '不能确定是否沾油',
          groupValue: oilBirdStatus,
          onChanged: (value) {
            setState(() {
              oilBirdStatus = value.toString();
            });
          },
        ),
      ],
    );
  }

  Widget buildBreedingCodeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('繁殖代码'),
        DropdownButton<String>(
          isExpanded: true,
          value: breedingCode,
          onChanged: (value) {
            setState(() {
              breedingCode = value!;
            });
          },
          items: [
            DropdownMenuItem(
              value: '',
              child: Text(''),
            ),
            DropdownMenuItem(
              value: 'NY',
              child: Text('NY {0}：巢内有幼鸟'),
            ),
            DropdownMenuItem(
              value: 'NE',
              child: Text('NE {0}：巢内有鸟蛋'),
            ),
            // Add more items as needed
          ],
        ),
      ],
    );
  }
}
