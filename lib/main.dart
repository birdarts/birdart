import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Open Naturalist';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const MyStatefulWidget(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();

  Widget _listViewBody() {
    return ListView.separated(
        controller: _homeController,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(
              'Item $index',
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          thickness: 1,
        ),
        itemCount: 50);
  }

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(25));
    const edgeInsets = EdgeInsets.fromLTRB(25, 5, 25, 5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Naturalist'),
      ),
      body: _listViewBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
                padding: edgeInsets,
                child: const Icon(Icons.home_outlined),
            ),
            activeIcon: Container(
                decoration: boxDecoration,
                padding: edgeInsets,
                child: const Icon(Icons.home)
            ),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: edgeInsets,
              child: const Icon(Icons.article_outlined),
            ),
            activeIcon: Container(
                decoration: boxDecoration,
                padding: edgeInsets,
                child: const Icon(Icons.article)
            ),
            label: '记录',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: edgeInsets,
              child: const Icon(Icons.location_on_outlined),
            ),
            activeIcon: Container(
                decoration: boxDecoration,
                padding: edgeInsets,
                child: const Icon(Icons.location_on)
            ),
            label: '地图',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: edgeInsets,
              child: const Icon(Icons.face_outlined),
            ),
            activeIcon: Container(
                decoration: boxDecoration,
                padding: edgeInsets,
                child: const Icon(Icons.face)
            ),
            label: '我的',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        selectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.black54,
        unselectedFontSize: 12,
        onTap: (int index) {
          switch (index) {
            case 0:
            // only scroll to top when current index is selected.
              if (_selectedIndex == index) {
                _homeController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              }
              break;
            case 1:
              break;
          }
          setState(
                () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Example Dialog'),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }
}
