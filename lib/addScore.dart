import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rummy_king/app_provider/game_data_provider.dart';
import 'package:rummy_king/database_services/db_operations.dart';

class EnterScore extends StatelessWidget {
  const EnterScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Score'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: SingleChildScrollView(child: InputScore()),
    );
  }
}

class InputScore extends StatefulWidget {
  const InputScore({Key? key}) : super(key: key);

  @override
  _InputScoreState createState() => _InputScoreState();
}

class _InputScoreState extends State<InputScore> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final appProvider = Provider.of<RummyKingProvider>(context, listen: false);

    _controllers = List.generate(
      appProvider.totalPlayer,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addScore() {
    final dbProvider = Provider.of<DbOperations>(context, listen: false);
    final appProvider = Provider.of<RummyKingProvider>(context, listen: false);

    final Map<String, dynamic> row = {};

    for (var index = 0; index < _controllers.length; index++) {
      final score = int.tryParse(_controllers[index].text) ?? 0;
      row[appProvider.playerNameInGame[index]] = score;
    }

// insert
    dbProvider.insertRoundscore(row);
// read

    for (var controller in _controllers) {
      controller.clear();
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<RummyKingProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: List.generate(
              appProvider.playerNameInGame.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(appProvider.playerNameInGame[index]),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _controllers[index],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter score',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(thickness: 1.5),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: _addScore,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Add Score'),
          ),
        ],
      ),
    );
  }
}
