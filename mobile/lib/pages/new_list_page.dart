import 'package:flutter/material.dart';

class NewListPage extends StatefulWidget {
  const NewListPage({super.key});

  @override
  State<NewListPage> createState() => _NewListPageState();
}

class _NewListPageState extends State<NewListPage> {
  Map<String, int> records = {};

  void _onCompleted() {
    // TODO: 处理完成按钮点击事件
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14.0,
          fontStyle: FontStyle.normal,
        ),
        title: Row(
          children: [
            Icon(Icons.my_location_rounded),
            SizedBox(width: 8),
            Text('10 min'),
            SizedBox(width: 8),
            Text('10.0 km'),
            SizedBox(width: 8),
            Icon(Icons.add_location),
            SizedBox(width: 8),
            Text('观鸟点名称'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Theme.of(context).appBarTheme.toolbarHeight ?? 65),
          child: Container(
            color: Colors.pink.shade50, // todo use theme color scheme
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
              title: TextField(
                decoration: InputDecoration(
                  hintText: '输入关键字搜索',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.comment), onPressed: () {}),
            IconButton(icon: Icon(Icons.settings), onPressed: () {}),
            IconButton(icon: Icon(Icons.check), onPressed: _onCompleted),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Create',
        child: const Icon(Icons.save_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          final name = '鸟 $index';
          return ListTile(
            leading: IconButton(
              icon: records.containsKey(name)
                  ? Text(records[name].toString())
                  : Icon(Icons.add),
              onPressed: () {
                setState(() {
                  if (records.containsKey(name)) {
                    records[name] = records[name]! + 1;
                  } else {
                    records[name] = 1;
                  }
                });
              },
            ),
            title: Text(name),
          );
        },
      ),
    );
  }
}
