import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rummy_king/addScore.dart';
import 'package:rummy_king/app_provider/game_data_provider.dart';
import 'package:rummy_king/gameHistory.dart';
import 'package:rummy_king/main.dart';
import 'package:rummy_king/playGame.dart';
import 'package:rummy_king/scoreBoard.dart';
import 'package:rummy_king/utils/routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        );

      case RoutesName.startGame:
        return MaterialPageRoute(
          builder: (BuildContext context) => ScoreScreen(), // Example screen
        );

      case RoutesName.history:
        return MaterialPageRoute(
          builder: (BuildContext context) => GameHistory(),
        );

      case RoutesName.enterScore:
        return MaterialPageRoute(
          builder: (BuildContext context) => EnterScore(), // Example screen
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            );
          },
        );
    }
  }
}
