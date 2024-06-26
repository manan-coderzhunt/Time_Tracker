import 'dart:async';
import 'package:flutter_screen_capture/flutter_screen_capture.dart';
import 'package:flutter/material.dart';

class NewStopWatch extends StatefulWidget {
  @override
  _NewStopWatchState createState() => _NewStopWatchState();
}

class _NewStopWatchState extends State<NewStopWatch> {
  final _plugin = ScreenCapture();
  List<CapturedScreenArea> _screenshots = [];

  Stopwatch watch = Stopwatch();
  Timer? timer;
  bool startStop = true;
  bool showClearButton = false;

  String elapsedTime = '';

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  ScreenTimerUpdate(Timer timer) {
    _captureFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text(elapsedTime,
                  style: TextStyle(fontSize: 25.0, color: Colors.white)),
              SizedBox(height: 20.0),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      backgroundColor: Colors.red,
                      onPressed: () => startOrStop(),
                      child: Text(startStop ? 'Clock In' : "Clock Out"),
                    ),
                    SizedBox(height: 50),
                    Container(
                      width: 520,
                      height: 420,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _screenshots.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: CapturedScreenAreaView(area: _screenshots[index]),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 50),
                    if (showClearButton)
                      ElevatedButton(
                        onPressed: clearScreenshots,
                        child: Text("Clear Screenshots"),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  startOrStop() {
    if (startStop) {
      startWatch();
      NewScreenTimer();
    } else {
      stopWatch();
    }
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(seconds: 0), updateTime);
    });
  }

  NewScreenTimer() {
    timer = Timer.periodic(Duration(seconds: 5), ScreenTimerUpdate);
    _captureFullScreen();
  }

  stopWatch() {
    setState(() {
      startStop = true;
      showClearButton = true;
      watch.reset();
      watch.stop();
      timer?.cancel();
      setTime();
    });
  }

  clearScreenshots() {
    setState(() {
      _screenshots.clear();
      showClearButton = false;
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  Future<void> _captureFullScreen() async {
    final area = await _plugin.captureEntireScreen();
    if (area != null) {
      setState(() {
        _screenshots.add(area);
      });
    }
  }
}