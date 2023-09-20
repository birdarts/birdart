import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/l10n.dart';
import 'fragments/home_fragment.dart';
import 'fragments/map_fragment.dart';
import 'fragments/mine_fragment.dart';
import 'fragments/list_fragment.dart';
import 'db/db_manager.dart';
import 'entity/app_dir.dart';
import 'entity/server.dart';
import 'entity/sharedpref.dart';
import 'entity/user_profile.dart';

late Locale _appLocale;

Locale _getLocale() {
  final localeNames = Platform.localeName.split(RegExp(r'[_-]'));
  return Locale('en');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _appLocale = _getLocale();
  BdL10n.load(_appLocale);
  await mainCheck();
  runApp(const MyApp());
}

Future<void> mainCheck() async {
  while (AppDir.data.path.isEmpty ||
      AppDir.cache.path.isEmpty ||
      DbManager.database == null ||
      !Shared.inited ||
      !UserProfile.inited) {
    Future? sharedFuture;
    Future? dirFuture;
    Future? dbFuture;
    if (!Shared.inited) {
      sharedFuture = Shared.init();
    }
    if (AppDir.data.path.isEmpty || AppDir.cache.path.isEmpty) {
      dirFuture = AppDir.setDir();
    }
    if (DbManager.database == null) {
      dbFuture = DbManager.setDb();
    }
    if (!UserProfile.inited) {
      if (sharedFuture != null) {
        await sharedFuture;
      }
      UserProfile.init();
      Server.setupDio();
    }
    if (dirFuture != null) {
      await dirFuture;
    }
    if (dbFuture != null) {
      await dbFuture;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BdL10n.current.appName,
      home: const BottomNav(),
      locale: _appLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('zh'), // Chinese
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          primary: Colors.pinkAccent,
          secondary: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.pinkAccent[5],
          surfaceTintColor: Colors.pinkAccent[5],
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.pinkAccent,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        useMaterial3: true,
        splashFactory: InkRipple.splashFactory,
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.pinkAccent,
          backgroundColor: Colors.pinkAccent[5],
        ),
      ),
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
    const ListFragment(),
    const MapFragment(),
    const MineFragment(),
  ];

  @override
  Widget build(BuildContext context) {
    var pageController = PageController();

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            pageController.jumpToPage(index);
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        elevation: 10,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            icon: const Icon(Icons.home_outlined),
            label: BdL10n.current.bottomHome,
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.article,
              color: Colors.white,
            ),
            icon: const Icon(Icons.article_outlined),
            label: BdL10n.current.bottomRecords,
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            icon: const Icon(Icons.location_on_outlined),
            label: BdL10n.current.bottomExplore,
          ),
          NavigationDestination(
            selectedIcon: const Icon(
              Icons.face,
              color: Colors.white,
            ),
            icon: const Icon(Icons.face_outlined),
            label: BdL10n.current.bottomMyBirdart,
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
