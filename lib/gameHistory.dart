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
      body: Padding(padding: EdgeInsets.all(2), child: AllGameHistory()),
    );
  }
}

class AllGameHistory extends StatefulWidget {
  const AllGameHistory({super.key});

  @override
  State<AllGameHistory> createState() => _AllGameHistoryState();
}

class _AllGameHistoryState extends State<AllGameHistory> {
  late DbOperations appProvider;
  late RummyKingProvider dbProvider;
  List<Map<String, dynamic>> games = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<DbOperations>(context, listen: false);
    dbProvider = Provider.of<RummyKingProvider>(context, listen: false);
    _loadGames();
  }

  Future<void> _loadGames() async {
    setState(() {
      isLoading = true;
    });
    final fetchedGames = await appProvider.readAllGame();
    setState(() {
      games = fetchedGames;
      isLoading = false;
    });
  }

  Future<void> _deleteGame(int id) async {
    await appProvider.deleteGame(id);
    _loadGames(); // Reload games after deletion
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (games.isEmpty) {
      return const Center(child: Text('No games'));
    }

    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            decoration: BoxDecoration(
                color: const Color.fromARGB(10, 0, 0, 0),
                border:
                    Border.all(color: const Color.fromARGB(74, 68, 137, 255)),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ListTile(
              key: Key("${game['id']}"),
              isThreeLine: true,
              title: Text(
                  'Game-${game['id']}  Pool: ${game['point_limit']} Player: ${game['player']}'),
              subtitle: Text(
                '${game['created_at']}',
                style: const TextStyle(color: Colors.blueAccent,fontSize: 12),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                dbProvider.continueGame(
                  game['id'].toString(),
                  game['point_limit'],
                  game['player'],
                );
                Navigator.pushNamed(context, RoutesName.startGame);
              },
              onLongPress: () {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Delete Game-${game['id']}'),
                      icon: const Icon(Icons.delete),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteGame(game['id']);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ));
      },
    );
  }
}
