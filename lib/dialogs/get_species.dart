import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../entity/color_scheme.dart';
import '../entity/server.dart';

class SearchDialog extends StatefulWidget {
  final Function(Map) onSelect;
  final Widget? bottomView;
  final Function(String)? onTap;

  const SearchDialog({
    Key? key,
    required this.onSelect,
    this.bottomView,
    this.onTap,
  }) : super(key: key);

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _controller = TextEditingController();
  final List<Map> queryList = [];

  @override
  Widget build(BuildContext context) {
    return _getSearchDialog(context);
  }

  Dialog _getSearchDialog(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400.0,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '物种搜索',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 15),
            _buildFloatingSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingSearchBar() {
    return Expanded(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: EditableText(
                  controller: _controller,
                  focusNode: FocusNode(),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  cursorColor: primaryColor,
                  backgroundCursorColor: accentColor,
                ),
              ),
              InkWell(
                child: const Icon(Icons.search_rounded),
                onTap: () {
                  _getSpeciesList(_controller.text);
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(6),
            itemCount: queryList.length + 1,
            itemBuilder: (listContext, index) {
              if (index < queryList.length) {
                return InkWell(
                  onTap: () {
                    widget.onSelect.call(queryList[index]);
                  }, // Handle your callback
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      queryList[index]['name'],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              } else {
                return widget.bottomView ?? _getBottom();
              }
            },
          ),
        ),
      ],
    ));
  }

  _getSpeciesList(String query) async {
    Dio dio = Server.dio;

    try {
      var response = await dio.get('/species/search',
          queryParameters: {'keyword': query});
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString()); //3
        if (data['success'] = true) {
          List<dynamic> dataList = data['data']['list'];
          setState(() {
            queryList.clear();
            for (var element in dataList) {
              queryList.add(element);
            }
          });
        }
      } else {}
    } catch (exception) {
      if (kDebugMode) {
        print(exception);
      }
    }
  }

  Widget _getBottom() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: TextButton(
          onPressed: () {
            final text = _controller.text;
            if (text.isNotEmpty) {
              widget.onTap?.call(text);
            }
          },
          child: const Text(
            '自定义物种名\r\n将搜索框内容设为物种名称',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
