import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseView extends StatelessWidget {
  const BaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const <Widget>[],
    );
  }
}
