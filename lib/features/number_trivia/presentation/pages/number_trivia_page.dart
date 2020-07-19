import 'package:clean_architecture/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/circular_loading.dart';
import '../widgets/message_display.dart';
import '../widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider<NumberTriviaBloc>(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaEmpty) {
                    return MessageDisplay(
                      message: 'Start Searching!',
                    );
                  } else if (state is NumberTriviaError) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else if (state is NumberTriviaLoading) {
                    return CircularLoading();
                  } else if (state is NumberTriviaLoaded) {
                    return TriviaDisplay(
                      numberTrivia: state.numberTrivia,
                    );
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
