import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rummy_king/app_provider/game_data_provider.dart';
import 'package:rummy_king/database_services/db_operations.dart';
import 'package:rummy_king/reEntry.dart';
import 'package:rummy_king/utils/routes_name.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<RummyKingProvider>(context, listen: true);
    final dbProvider = Provider.of<DbOperations>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Game-${dbProvider.gameId} Pool: ${appProvider.poolLimit} Player: ${appProvider.totalPlayer}')),
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
    final appProvider = Provider.of<RummyKingProvider>(context, listen: true);
    final dbProvider = Provider.of<DbOperations>(context, listen: true);

    final outPlayers = appProvider.getOutPlayer();

    int entryPoint = appProvider.getEntryPoint();

    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('Round: ${dbProvider.round}')),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: Colors.black12),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(20, 0, 0, 0),
                    border: Border(
                      bottom: BorderSide(color: Colors.black26),
                    ),
                  ),
                  children: appProvider.playerTableName.map((name) {
                    return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Center(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ));
                  }).toList(),
                ),
                // Data Rows
                ...appProvider.data.map<TableRow>((scoreRow) {
                  return TableRow(
                    children: scoreRow.map<Widget>((score) {
                      return Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: (score == null || score == 'null')
                              ? Center(
                                  child: Text(
                                  'Out',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ))
                              : Center(
                                  child: Text(
                                    textDirection: TextDirection.rtl,
                                    score
                                        .toString(), // Convert the score to String
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ));
                    }).toList(),
                  );
                }).toList(),

                appProvider.totalScore.isNotEmpty
                    ? totalScore(context)
                    : TableRow(
                        children: List.generate(
                            appProvider.playerTableName.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              '0', // Convert int to String
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        );
                        ;
                      }))
              ],
            )),
        appProvider.playerNameInGame.length > 1
            ? SizedBox(
                height: 30,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.enterScore);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Score'),
                ),
              )
            : Center(
                child: Text(
                    textAlign: TextAlign.center,
                    'Game Finished! \n🏆 ${appProvider.winner()} Win the Game. '),
              ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },
              shrinkWrap: true,
              itemCount: outPlayers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(outPlayers[index]),
                  trailing: Text(
                    'Out',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }),
        ),
        entryPoint != 0 && outPlayers.isNotEmpty
            ? SizedBox(
                height: 30,
                child: TextButton(
                  onPressed: () {
                    showReEntryDialog(context, outPlayers);
                  },
                  child: const Text('Re-Entry Available'),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }
}

TableRow totalScore(BuildContext context) {
  final appProvider = Provider.of<RummyKingProvider>(context, listen: false);

  return TableRow(
    decoration: BoxDecoration(
      color: const Color.fromARGB(15, 0, 0, 0),
      border: Border(
        bottom: BorderSide(color: Colors.black26),
      ),
    ),
    children: appProvider.totalScore.map((value) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      );
    }).toList(),
  );
}
