import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/dependencies_injection.dart';
import 'package:number_trivia/features/number_trivia_feature/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/bloc/number_trivia_bloc.dart';

class InputView extends StatefulWidget {
  @override
  _InputViewState createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  String inputStr;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Container(
            height: 100,
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                inputStr = value;
              },
              onSubmitted: (value) {
                _dispatchConcertet();
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Input a number',
              ),
            )),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 70,
          child: Row(children: [
            Expanded(
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  'Search',
                  style: TextStyle(color: Theme.of(context).primaryColorLight),
                ),
                onPressed: () {
                  _dispatchConcertet();
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: RaisedButton(
                child: Text('Random'),
                onPressed: () {
                  _dispatchRandom();
                },
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  _dispatchConcertet() {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetTriviaForConcreteNumber(inputStr));
  }
  _dispatchRandom(){
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetTriviaForRandomNumber());
  }
}
