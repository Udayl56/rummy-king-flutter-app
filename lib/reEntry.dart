import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rummy_king/app_provider/game_data_provider.dart';

showReEntryDialog(BuildContext context, outPlayer) {
  final appProvider = Provider.of<RummyKingProvider>(context, listen: false);
  // Initialize checkedStates based on the outPlayer length
  List<bool> checkedStates = List.filled(outPlayer.length, false);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title:
            Text('Re-Entry Available At Score ${appProvider.getEntryPoint()}'),
        titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
        content: SizedBox(
          height: 160,
          width: double.maxFinite,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return ListView.builder(
                itemCount: outPlayer.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text("$index"),
                    title: Text(
                      '${outPlayer[index]}',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Checkbox(
                      value: checkedStates[index],
                      onChanged: (bool? value) {
                        setState(() {
                          checkedStates[index] = value ?? false;
                        });
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: <Widget>[
          OutlinedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              // Use the locally fetched outPlayer list
              appProvider.removePlayer(
                checkedStates,
                outPlayer,
                appProvider.getEntryPoint(),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
