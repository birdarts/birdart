import 'dart:io';

import 'package:birdart/pages/checklist_page.dart';
import 'package:birdart/tool/list_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/l10n.dart';
import 'fragments/home_fragment.dart';
import 'fragments/map_fragment.dart';
import 'fragments/mine_fragment.dart';
import 'fragments/list_fragment.dart';
import 'entity/app_dir.dart';
import 'entity/server.dart';
import 'entity/sharedpref.dart';
import 'entity/user_profile.dart';

late Locale _appLocale;

Locale _getLocale() {
  final localeNames = Platform.localeName.split(RegExp(r'[_-]'));
  return Locale(localeNames[0], localeNames.length > 1 ? localeNames[1] : null);
  // 'en'); //
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _appLocale = _getLocale();
  BdL10n.load(_appLocale);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  await mainCheck();
  runApp(const MyApp());
}

Future<void> mainCheck() async {
  while (AppDir.data.path.isEmpty ||
      AppDir.cache.path.isEmpty ||
      !SharedPref.inited ||
      !UserProfile.inited) {
    Future? prefFuture;
    Future? dirFuture;
    if (!SharedPref.inited) {
      prefFuture = SharedPref.init();
    }
    if (AppDir.data.path.isEmpty || AppDir.cache.path.isEmpty) {
      dirFuture = AppDir.setDir();
    }
    if (!UserProfile.inited) {
      if (prefFuture != null) {
        await prefFuture;
      }
      UserProfile.init();
      Server.setupDio();
    }
    if (dirFuture != null) {
      await dirFuture;
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
          color: Colors.pink.shade50,
          surfaceTintColor: Colors.pink.shade50,
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
  GlobalKey<HomeFragmentState> homeKey = GlobalKey<HomeFragmentState>();
  late final List<Widget> pages;

  var pageController = PageController();

  @override
  initState() {
    super.initState();
    pages = [
      HomeFragment(
        key: homeKey,
        update: () {
          setState(() {});
        },
      ),
      const ListFragment(),
      const MapFragment(),
      const MineFragment(),
    ];
  }

  update () {
    homeKey.currentState?.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ListTool.checklist != null)
            Container(
              color: Colors.orangeAccent.shade100,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const ChecklistPage()))
                      .then((value) => update());
                },
                title: const Text('Checklist is ongoing in background ...'),
                trailing: const Icon(Icons.expand_less_rounded),
              ),
            ),
          _navBar(),
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

  NavigationBar _navBar() => NavigationBar(
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
      );
}
