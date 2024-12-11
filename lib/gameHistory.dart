import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rummy_king/database_services/db_operations.dart';
import 'package:rummy_king/app_provider/game_data_provider.dart';
import 'package:rummy_king/utils/routes_name.dart';

class GameHistory extends StatelessWidget {
  const GameHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Flexible(child: AllGameHistory())),
    );
  }
}

class AllGameHistory extends StatelessWidget {
  const AllGameHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<DbOperations>(context, listen: true);
    final dbProvider = Provider.of<RummyKingProvider>(context, listen: true);

    return FutureBuilder(
      future: appProvider.readAllGame(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No games '),
          );
        } else {
          final games = snapshot.data!;
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 10,
              );
            },
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return ListTile(
                isThreeLine: true,
                title: RichText(
                  text: TextSpan(
                      text: 'Game-${game['id']}',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            style: TextStyle(
                                color: const Color.fromARGB(164, 0, 0, 0)),
                            text:
                                ' Pool: ${game['point_limit']} Player: ${game['player']}')
                      ]),
                ), // Replace with your actual game property
                subtitle: Text(
                  '${game['created_at']}',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                // Adjust fields as needed
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    dbProvider.continueGame(game['id'].toString(),
                        game['point_limit'], game['player']);
                    Navigator.pushNamed(context, RoutesName.startGame);
                  },
                ),

                onLongPress: () {},
              );
            },
          );
        }
      },
    );
  }
}
