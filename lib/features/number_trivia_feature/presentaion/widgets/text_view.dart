import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/widgets/loading_view.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/widgets/text_msg_display.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/widgets/trivia_display.dart';

class TextView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3,
      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        builder: (BuildContext context, state) {
          if (state is Empty) {
            return TextMessageDisplay(msg: 'NoNumber');
          } else if (state is Loading) {
            return LoadingView();
          } else if (state is Loaded) {
            return TriviaDisplay(numberTrivia: state.trivia);
          } else if (state is Error) {
            return TextMessageDisplay(msg: state.message);
          } else {
            return TextMessageDisplay(msg: 'NoNumber');
          }
        },
      ),
    );
  }
}
