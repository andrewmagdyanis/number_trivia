import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    Key key,
    this.numberTrivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          numberTrivia.number.toString(),
          style: TextStyle(fontSize: 50),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
          numberTrivia.text,
          style: TextStyle(fontSize: 40),
        ),
          ),
        ),
      ],
    );
  }
}
