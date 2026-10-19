import 'package:material_ui/material_ui.dart';

Widget showButtonProgress([Color? color]) {
  return SizedBox(
    height: 30,
    width: 30,
    child: Center(
        child: CircularProgressIndicator(
      strokeWidth: 2.5,
      color: color,
    )),
  );
}
