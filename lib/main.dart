import 'package:flutter/material.dart';
import 'package:naturalist/fragments/home_fragment.dart';
import 'package:naturalist/fragments/observation_fragment.dart';
import 'package:naturalist/fragments/map_fragment.dart';
import 'package:naturalist/fragments/mine_fragment.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'open naturalist';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const BottomNav(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
        splashFactory: InkSparkle.splashFactory,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0; //預設值
  final List<Widget> pages = [
    const HomeFragment(),
    const ObservationFragment(),
    MapFragment(),
    const MineFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(25));
    const edgeInsets = EdgeInsets.fromLTRB(25, 5, 25, 5);
    final pageController = PageController();
    void onPageChanged(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('open naturalist'),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: pages,
      ), // 使用 AutomaticKeepAliveClientMixin 需要将页面包装在PageView中
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
            label: '观察',
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
          setState(() {
            pageController.jumpToPage(index);
          });
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
