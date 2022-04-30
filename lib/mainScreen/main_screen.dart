import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_x_and_o/mainScreen/main_bloc.dart';
import 'package:game_x_and_o/utils.dart';
import 'package:game_x_and_o/utils/players.dart';
import 'package:game_x_and_o/utils/singilton.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var bloc = MainBloc();

  @override
  void initState() {
    setEmptyFeilds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Center(
              child: Text(
            "TicTac Game",
            style: TextStyle(color: Colors.purple, fontSize: 30),
          )),
        ),
        body: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/moon.jpg",
                  fit: BoxFit.fill,
                )),
            StreamBuilder(
                stream: Singleton.singleton.mainCollection.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: Utils.modelBuilder(bloc.matrix, (x, value) => buildRow(x)),
                    );
                  } else {
                    return loading();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  bool isEnd() => bloc.matrix.every((values) => values.every((value) => value != Player.none));

  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final Player = bloc.matrix[x][y];
    final counter = bloc.countMatrix;
    for (int i = 0; i < counter; i++) {
      if (bloc.matrix[x][i] == Player) col++;
      if (bloc.matrix[i][y] == Player) row++;
      if (bloc.matrix[i][i] == Player) diag++;
      if (bloc.matrix[i][counter - i - 1] == Player) rdiag++;
    }
    return row == counter || col == counter || diag == counter || rdiag == counter;
  }

  Widget buildRow(int x) {
    final values = bloc.matrix[x];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(values, (y, value) => buildFeild(x, y)),
    );
  }

  Widget buildFeild(int x, int y) {
    final value = bloc.matrix[x][y];
    final color = getFeildColor(value);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(style: ElevatedButton.styleFrom(primary: color, minimumSize: Size(bloc.size, bloc.size)), onPressed: () async => selectFeild(value, x, y), child: Text(value, style: const TextStyle(fontSize: 32))),
    );
  }

  Color getFeildColor(String value) {
    switch (value) {
      case Player.O:
        return Colors.pink;
      case Player.X:
        return Colors.purple;
      default:
        return Colors.white;
    }
  }

  Future<void> selectFeild(String value, int x, int y) async {
    print(value);
    print("x  => $x");
    print("y  => $y");

    if ((x == 0 && y == 0 && value == Player.none)) {
      await Singleton.singleton.mainCollection.doc("41Co2wkqLH8QLOqC3yqd").update({
        "Field0": bloc.lastMove == Player.X ? "o" : "x",
      });
    }

    if ((x == 0 && y == 1 && value == Player.none)) {
      await Singleton.singleton.mainCollection.doc("41Co2wkqLH8QLOqC3yqd").update({
        "Field1": bloc.lastMove == Player.X ? "o" : "x",
      });
    }

    if ((x == 0 && y == 2 && value == Player.none)) {
      await Singleton.singleton.mainCollection.doc("41Co2wkqLH8QLOqC3yqd").update({
        "Field2": bloc.lastMove == Player.X ? "o" : "x",
      });
    }

    if ((x == 1 && y == 0 && value == Player.none)) {
      await Singleton.singleton.mainCollection.doc("41Co2wkqLH8QLOqC3yqd").update({
        "Field3": bloc.lastMove == Player.X ? "o" : "x",
      });
    }

    if ((x == 1 && y == 1 && value == Player.none)) {
      await Singleton.singleton.mainCollection.doc("41Co2wkqLH8QLOqC3yqd").update({
        "Field4": bloc.lastMove == Player.X ? "o" : "x",
      });
    }

    if ((x == 1 && y == 2 && value == Player.none)) {
      await Singleton.singleton.mainCollection.doc("41Co2wkqLH8QLOqC3yqd").update({
        "Field5": bloc.lastMove == Player.X ? "o" : "x",
      });
    }

    if ((x == 2 && y == 0 && value == Player.none)) {
      await Singleton.singleton.mainCollection.doc("41Co2wkqLH8QLOqC3yqd").update({
        "Field6": bloc.lastMove == Player.X ? "o" : "x",
      });
    }

    if ((x == 2 && y == 1 && value == Player.none)) {
      await Singleton.singleton.mainCollection.doc("41Co2wkqLH8QLOqC3yqd").update({
        "Field7": bloc.lastMove == Player.X ? "o" : "x",
      });
    }

    if ((x == 2 && y == 2 && value == Player.none)) {
      await Singleton.singleton.mainCollection.doc("41Co2wkqLH8QLOqC3yqd").update({
        "Field8": bloc.lastMove == Player.X ? "o" : "x",
      });
    }

    if (value == Player.none) {
      final newValue = bloc.lastMove == Player.X ? Player.O : Player.X;
      setState(() {
        bloc.lastMove = newValue;
        bloc.matrix[x][y] = newValue;
      });
      if (isWinner(x, y)) {
        showEndDialog('Player $newValue Won');
      } else if (isEnd()) {
        showEndDialog('Undecided Game');
      }
    }
  }

  void setEmptyFeilds() {
    setState(() {
      bloc.matrix = List.generate(bloc.countMatrix, (_) {
        return List.generate(
          bloc.countMatrix,
          (_) => Player.none,
        );
      });
    });
  }

  Future showEndDialog(String title) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: const Text("Press to restart the game"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setEmptyFeilds();
                    Navigator.pop(context);
                  },
                  child: const Text("restart"))
            ],
          ));
}
