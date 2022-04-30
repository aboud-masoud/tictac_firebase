import 'package:flutter/material.dart';
import 'package:game_x_and_o/mainScreen/main_screen.dart';
import 'package:game_x_and_o/setGameName/set_game_name_bloc.dart';
import 'package:game_x_and_o/utils/singilton.dart';

class SetGameName extends StatelessWidget {
  var bloc = SetGameNameBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("set Game Name"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(child: Container()),
              TextField(
                controller: bloc.controller,
                decoration: const InputDecoration(hintText: "Game Name"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (bloc.controller.text.isNotEmpty) {
                    Singleton.singleton.setCollectionName(bloc.controller.text);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                      return MainScreen();
                    }), (route) => false);
                  } else {
                    //SHOW TOAST MEssage to fill this field
                  }
                },
                child: Text("Start"),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
