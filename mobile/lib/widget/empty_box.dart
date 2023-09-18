import 'package:flutter/material.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.question_mark_rounded,
            size: 50,
          ),
          Text('暂无内容'),
        ],
      ),
    );
  }
}

class PleaseSelectSpecies extends StatelessWidget {
  const PleaseSelectSpecies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 50,
          ),
          Text('暂未搜索'),
        ],
      ),
    );
  }
}
