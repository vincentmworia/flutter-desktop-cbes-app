import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({Key? key}) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  var checkValue = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        fillColor: checkValue
            ? null
            : MaterialStateColor.resolveWith((_) => Colors.white),
        value: checkValue,
        activeColor: Theme.of(context).colorScheme.primary,
        onChanged: (newVal) {
          setState(() {
            checkValue = newVal!;
          });
        });
  }
}
