import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rummy_king/app_provider/scoreData.dart';

class DialogHelper {
  static void showReEntryDialog(BuildContext context) {
    final rummyKingProvider = Provider.of<RummyKing>(context, listen: false);

    List<bool> checkedStates =
        List.filled(rummyKingProvider.getOutPlayer().length, false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Re-Entry Available At Score ${rummyKingProvider.getEntryPoint()}'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: rummyKingProvider
                    .getOutPlayer()
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  String player = entry.value;
                  return Row(
                    children: [
                      Text(player),
                      Checkbox(
                        value: checkedStates[index],
                        onChanged: (bool? value) {
                          setState(() {
                            checkedStates[index] = value ?? false;
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                rummyKingProvider.removePlayer(
                    checkedStates,
                    rummyKingProvider.getOutPlayer(),
                    rummyKingProvider.getEntryPoint());

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
