import 'package:flutter/material.dart';

import '../entity/color_scheme.dart';

AppBar anAppBar({
  Widget? title,
  List<Widget>? actions,
}) =>
    AppBar(
      title: title ?? const Text('naturalist'),
      centerTitle: true,
      backgroundColor: primaryColor,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
      actions: actions,
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );

Widget aTabBar(BuildContext context, List<Widget> tabs) {
  var theme = Theme.of(context);

  return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          surfaceVariant: Colors.transparent,
        ),
      ),
      child: TabBar(
        tabs: tabs,
        labelColor: Colors.white,
        unselectedLabelColor: lightColor,
      ));
}
