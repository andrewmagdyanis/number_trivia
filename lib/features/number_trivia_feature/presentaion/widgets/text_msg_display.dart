import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextMessageDisplay extends StatelessWidget {
  final String msg;

  const TextMessageDisplay({
    Key key,
    this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        msg,
        style: TextStyle(fontSize: 20, color: Theme.of(context).accentColor),
      ),
    );
  }
}
