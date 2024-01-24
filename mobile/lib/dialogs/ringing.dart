import 'package:flutter/material.dart';

showRingingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const RingingDialog(),
  );
}

class RingingDialog extends Dialog {
  const RingingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
