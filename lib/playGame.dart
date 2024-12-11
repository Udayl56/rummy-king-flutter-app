// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rummy_king/addScore.dart';
// import 'package:rummy_king/provider/scoreData.dart';
// import 'package:rummy_king/reEntry.dart';
// import 'package:rummy_king/scoreBoard.dart';
// import 'package:rummy_king/theam.dart';
// import 'package:rummy_king/utils/routes_name.dart';
// import 'rummyGamelogic.dart';

// class Playgame extends StatelessWidget {
//   const Playgame({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final rummykingProvider = Provider.of<RummyKing>(context, listen: true);
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: AppStyles.iconColor),
//           backgroundColor: AppStyles.background,
//           title: Text(
//             'ScoreBoard',
//             style: AppStyles.headingStyle,
//           ),
//         ),
//         body: SingleChildScrollView(
//           padding: AppStyles.padding,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Flexible(
//                       child: Text(
//                     'Game Name',
//                     style: AppStyles.bodyTextStyle,
//                   )),
//                   Flexible(
//                       child: Text(
//                     'Player: 5',
//                     style: AppStyles.bodyTextStyle,
//                   )),
//                   Flexible(
//                       child: Text(
//                     'Point: 200',
//                     style: AppStyles.bodyTextStyle,
//                   ))
//                 ],
//               ),

//               // Score Board
//               LatestScoreBoard(),

//               rummykingProvider.winner() != null
//                   ? Text('  ${rummykingProvider.winner()} win the Game')
//                   : TextButton.icon(
//                       style: AppStyles.buttonStyle,
//                       onPressed: () {
//                         Navigator.pushNamed(context, RoutesName.enterScore);
//                       },
//                       icon: Icon(Icons.add), // Icon to display
//                       label: Text('Add Score'),
//                     ),
//               rummykingProvider.getEntryPoint() != 0
//                   ? TextButton(
//                       onPressed: () {
//                         DialogHelper.showReEntryDialog(context);
//                       },
//                       child: Text('Entry Availabe'))
//                   : Text('outplayer')
//             ],
//           ),
//         ));
//   }
// }

// class PlayerName extends StatelessWidget {
//   const PlayerName({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final rummykingProvider = Provider.of<RummyKing>(context, listen: true);
//     return Table(
//       border: TableBorder.all(
//           style: BorderStyle.solid,
//           width: 1,
//           color: Color.fromARGB(247, 13, 0, 87)),
//       children: [
//         TableRow(
//             decoration:
//                 BoxDecoration(color: const Color.fromARGB(255, 62, 80, 214)),
//             children: rummykingProvider.playerNameInGame.isEmpty
//                 ? List.generate(3, (index) {
//                     return Text(index.toString());
//                   })
//                 : rummykingProvider.playerNameInGame
//                     .map((name) => Center(
//                           child: Text(
//                             name,
//                             style: TextStyle(
//                                 color:
//                                     const Color.fromARGB(255, 255, 255, 255)),
//                           ),
//                         ))
//                     .toList())
//       ],
//     );
//   }
// }
