import 'package:game_x_and_o/utils/players.dart';

class MainBloc {
  final countMatrix = 3;
  final double size = 92;
  String lastMove = Player.none;
  late List<List<String>> matrix;
}
