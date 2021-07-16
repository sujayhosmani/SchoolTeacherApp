import 'package:flutter/material.dart';
import 'package:guardian_teacher/Providers/global_provider.dart';
import 'package:provider/provider.dart';

class MainWidget extends StatelessWidget {
  final Widget currentPage;

  const MainWidget({Key key, this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        currentPage,
        Consumer<GlobalProvider>(builder: (context, global, child){
          return global.isBusy ? LinearProgressIndicator() : global.error != null ? Dismissible(
              key: Key("global?.error"),
              direction: DismissDirection.vertical,
              onDismissed: (direction){
                Provider.of<GlobalProvider>(context, listen: false).reset();
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red.shade300,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                padding: const EdgeInsets.all(14),

                child: Text(global.error, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),),
              )
          ): SizedBox.shrink();
        }),



      ],
    );
  }
}
// LoadingScreen(isBusy: global.isBusy,error: global?.error,)