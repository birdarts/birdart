import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../dialogs/ringing.dart';
import '../l10n/l10n.dart';

class RecordDetail extends StatefulWidget {
  final DbRecord record;
  final String project;

  const RecordDetail({Key? key, required this.record, required this.project}) : super(key: key);

  @override
  State<RecordDetail> createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail> {
  late final DbRecord record;
  late final TextEditingController noteController;
  late final TextEditingController amountController;

  @override
  void initState() {
    record = widget.record;
    noteController = TextEditingController(text: record.notes);
    amountController = TextEditingController(text: record.amount.toString());

    super.initState();
  }

  @override
  void dispose() {
    // clear controller resources
    noteController.dispose();
    amountController.dispose();
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
              CupertinoTextField(
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final number = int.tryParse(val);
                  if (number != null) {
                    record.amount = number;
                  }
                },
                controller: amountController,
                prefix: Text('数量'),
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
              _getNoteItem(),
              showRingingInfo(),
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
              record.tags.add(label);
            } else {
              record.tags.remove(label);
            }
          });
        },
        selected: record.tags.contains(label),
      ),
    );
  }

  Widget buildBirdInfoTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          const TableCell(child: Center(child: Text(''))),
          TableCell(child: Center(child: Text(BdL10n.current.male))),
          TableCell(child: Center(child: Text(BdL10n.current.female))),
          TableCell(child: Center(child: Text(BdL10n.current.sexUnknown))),
        ]),
        buildTableRow(BdL10n.current.nestling, RecordKeys.nestling),
        buildTableRow(BdL10n.current.juvenile, RecordKeys.juvenile),
        buildTableRow(BdL10n.current.adult, RecordKeys.adult),
        buildTableRow(BdL10n.current.ageUnknown, RecordKeys.undefined),
      ],
    );
  }

  TableRow buildTableRow(String header, String key) {
    var data = record.ageSex[key];
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
            child: CupertinoTextField(
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final number = int.tryParse(val);
                if (number != null) {
                  data?[RecordKeys.male] = number;
                }
              },
              controller: TextEditingController(text: data?[RecordKeys.male].toString() ?? '0'),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoTextField(
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final number = int.tryParse(val);
                if (number != null) {
                  data?[RecordKeys.female] = number;
                }
              },
              controller: TextEditingController(text: data?[RecordKeys.female].toString() ?? '0'),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoTextField(
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final number = int.tryParse(val);
                if (number != null) {
                  data?[RecordKeys.undefined] = number;
                }
              },
              controller: TextEditingController(text: data?[RecordKeys.undefined].toString() ?? '0'),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOilBirdStatusRadio() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('沾油鸟：'),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: record.oil,
            onChanged: (value) {
              setState(() {
                record.oil = value!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: '',
                child: Text(''),
              ),
              DropdownMenuItem(
                value: 'Free',
                child: Text('未沾油污'),
              ),
              DropdownMenuItem(
                value: 'Good',
                child: Text('沾有油污，但状态没有明显不佳'),
              ),
              DropdownMenuItem(
                value: 'Bad',
                child: Text('沾有油污，状态明显不佳'),
              ),
              DropdownMenuItem(
                value: 'unknown',
                child: Text('不能确定是否沾油'), // Add more items as needed
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBreedingCodeDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('繁殖代码：'),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: record.behaviour,
            onChanged: (value) {
              setState(() {
                record.behaviour = value!;
              });
            },
            items: const [
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
        ),
      ],
    );
  }

  ElevatedButton showRingingInfo() => ElevatedButton(
        onPressed: () => showRingingDialog(context),
        child: const Text('编辑环志信息'),
      );
}
