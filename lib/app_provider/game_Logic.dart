import 'package:flutter/foundation.dart';

class GameLogic with ChangeNotifier {
  int? _Score;
  final Map<String, int> _playerInGame = {};
  GameLogic(_Score, __playerInGame);
}
