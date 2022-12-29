import 'package:flutter/material.dart';
import 'package:naturalist/fragments/home_fragment.dart';
import 'package:naturalist/fragments/map_fragment.dart';
import 'package:naturalist/fragments/mine_fragment.dart';
import 'package:naturalist/fragments/observation_fragment.dart';

import 'entity/app_dir.dart';
import 'entity/hive_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  while (AppDir.data.path.isEmpty || AppDir.cache.path.isEmpty) {
    await AppDir.setDir();
  }
   await HiveManager.init();

  runApp(const MyApp());
}

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
        splashFactory: NoSplash.splashFactory,
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

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  int _selectedIndex = 0; //預設值
  final List<Widget> pages = [
    const HomeFragment(),
    const ObservationFragment(),
    MapFragment(),
    const MineFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    var pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('open naturalist'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            pageController.jumpToPage(index);
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        elevation: 10,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: '首页',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.article),
            icon: Icon(Icons.article_outlined),
            label: '观察',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.location_on),
            icon: Icon(Icons.location_on_outlined),
            label: '探索',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.face),
            icon: Icon(Icons.face_outlined),
            label: '我的',
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: pages,
      ),
    );
  }
}
