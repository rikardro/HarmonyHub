import 'package:flutter/material.dart';

import 'generic_dialog.dart';


Future<void> showInformationDialog(
  BuildContext context,
  String title,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: title,
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
