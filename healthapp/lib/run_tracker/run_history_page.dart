import 'package:flutter/material.dart';

import '../dashboard/gradientColor.dart';

class RunHistoryPage extends StatefulWidget {
  const RunHistoryPage({Key? key}) : super(key: key);

  @override
  State<RunHistoryPage> createState() => _RunHistoryPageState();
}

class _RunHistoryPageState extends State<RunHistoryPage> {
  Widget newRunBtn(){
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // add gradient color
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: GradientColor.getGradient(Colors.deepOrange.value),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.add, color: Colors.white, size: 50,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.grey[200],
      ),
    );
  }
}
