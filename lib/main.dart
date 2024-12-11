import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rummy_king/app_provider/game_data_provider.dart';
import 'package:rummy_king/database_services/db_operations.dart';
import 'package:rummy_king/gameHistory.dart';

import 'package:rummy_king/theam.dart';
import 'package:rummy_king/utils/routes.dart';
import 'package:rummy_king/utils/routes_name.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => RummyKingProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => DbOperations(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RoutesName.home,
      onGenerateRoute: Routes.generateRoute,
      debugShowCheckedModeBanner: false,
      title: 'Rummy King',
      theme: theam,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('RummyKing'),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 300,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        border: Border.all(
                            color: const Color.fromARGB(60, 0, 0, 0))),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Select Player'),
                          SelectPlayer(),
                          Text('Select Pool'),
                          SelectPool(),
                          StartGame(),
                        ])),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [Text('Recent Games'), ViewAllGame()],
                  ),
                ),
                Divider(),
                Flexible(child: AllGameHistory())
              ],
            )));
  }
}

// select palyer

class SelectPlayer extends StatelessWidget {
  const SelectPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<RummyKingProvider>(context, listen: true);

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          int player = index + 2;
          return GestureDetector(
            onTap: () => appProvider.setPlayer(player),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: appProvider.totalPlayer == player
                      ? const Color.fromARGB(86, 68, 137, 255)
                      : null,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color.fromARGB(42, 0, 0, 0))),
              child: Text('${index+2}'),
            ),
          );
        }));
  }
}

// select pool

class SelectPool extends StatelessWidget {
  const SelectPool({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<RummyKingProvider>(context, listen: true);

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          int poolValue = (index + 1) * 100;
          return GestureDetector(
            onTap: () => appProvider.setPool(poolValue),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: appProvider.poolLimit == poolValue
                      ? const Color.fromARGB(86, 68, 137, 255)
                      : Colors.white10,
                  border: Border.all(color: const Color.fromARGB(30, 0, 0, 0))),
              child: Text('$poolValue'),
            ),
          );
        }));
  }
}

// start game Button

class StartGame extends StatelessWidget {
  const StartGame({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<RummyKingProvider>(context, listen: true);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          appProvider.startNewGame();
          Navigator.pushNamed(context, RoutesName.startGame);
        },
        child: const Text('Start Game'),
      ),
    );
  }
}

class ViewAllGame extends StatelessWidget {
  const ViewAllGame({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('See all'),
      onPressed: () {
        Navigator.pushNamed(context, RoutesName.history);
      },
    );
  }
}
