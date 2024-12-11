import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rummy_king/addScore.dart';
import 'package:rummy_king/app_provider/game_data_provider.dart';
import 'package:rummy_king/database_services/db_operations.dart';
import 'package:rummy_king/utils/routes_name.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<RummyKingProvider>(context, listen: true);
    final dbProvider = Provider.of<DbOperations>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
              text: '',
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                    style: TextStyle(color: const Color.fromARGB(164, 0, 0, 0)),
                    text:
                        ' Pool: ${appProvider.poolLimit} Player: ${appProvider.totalPlayer}')
              ]),
        ),
      ),
      body: SingleChildScrollView(
        child: ScoreTable(),
      ),
    );
  }
}

class ScoreTable extends StatelessWidget {
  const ScoreTable({super.key});

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DbOperations>(context, listen: true);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: StreamBuilder<List<dynamic>>(
            stream: dbProvider.readCurrGameScore(),
            builder: (context, snapshot) {
              // Handle loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Handle error state
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // Handle empty or null data
              final scores = snapshot.data;
              if (scores == null || scores.isEmpty) {
                return Center(child: Text('No scores available.'));
              }

              // Build the Table widget
              return Table(
                border: TableBorder.all(),
                children: [
                  // Header Row
                  // TableRow(
                  //   children: dbProvider.playerName.map((name) {
                  //     return Center(
                  //       child: Text(
                  //         name,
                  //         style: TextStyle(
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  // Data Rows
                  ...scores.map<TableRow>((scoreRow) {
                    return TableRow(
                      children: scoreRow.map<Widget>((score) {
                        return Center(
                          child: Text(
                            score.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.enterScore);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Score'),
              ),
            ),
            SizedBox(
              height: 30,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Re Join in Game'),
                        content: const ReGoinGame(),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Re-Entry Available'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// totalScore(context) {
//   return TableRow(
//       decoration: BoxDecoration(
//           color: Colors.black12,
//           border: Border(bottom: BorderSide(color: Colors.black26))),
//       children: List.generate(6, (index) {
//         return Padding(
//             padding: const EdgeInsets.all(8.0), // Set padding here
//             child: Center(
//               child: Text('200'),
//             ));
//       }));
// }

class ReGoinGame extends StatefulWidget {
  const ReGoinGame({super.key});

  @override
  State<ReGoinGame> createState() => _ReGoinGameState();
}

class _ReGoinGameState extends State<ReGoinGame> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text("$index"),
            title: Text('name'),
            trailing: Checkbox(
                value: true,
                onChanged: (value) {
                  // value = value;
                }),
          );
        });
  }
}
