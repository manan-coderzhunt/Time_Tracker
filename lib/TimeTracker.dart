import 'package:flutter/material.dart';


class Timetracker extends StatefulWidget {
  const Timetracker({super.key});

  @override
  State<Timetracker> createState() => _TimetrackerState();
}

class _TimetrackerState extends State<Timetracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Started at',style:
                      TextStyle(
                        fontSize: 35,
                      ),)
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
