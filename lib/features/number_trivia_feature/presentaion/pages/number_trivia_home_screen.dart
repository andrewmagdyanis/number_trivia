import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/widgets/input_view.dart';
import 'package:number_trivia/features/number_trivia_feature/presentaion/widgets/text_view.dart';

import '../../../../dependencies_injection.dart';

class NumberTriviaHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (BuildContext context) {
        return sl<NumberTriviaBloc>();
      },
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextView(),

                SizedBox(
                  height: 10,
                ),
                InputView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
