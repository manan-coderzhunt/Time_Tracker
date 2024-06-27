import 'dart:async';
import 'package:flutter_screen_capture/flutter_screen_capture.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Screenshot {
  final CapturedScreenArea area;
  final String captureTime;
  final DateTime dateTime;

  Screenshot(this.area, this.captureTime, this.dateTime);
}

class NewStopWatch extends StatefulWidget {
  @override
  _NewStopWatchState createState() => _NewStopWatchState();
}

class _NewStopWatchState extends State<NewStopWatch> {
  final _plugin = ScreenCapture();
  List<Screenshot> _screenshots = [];

  Stopwatch watch = Stopwatch();
  Timer? timer;
  bool startStop = true;
  bool showClearButton = false;

  String elapsedTime = '00:00:00';

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 90.0),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Started at ",style:
                      TextStyle(
                        fontSize: 18,
                        color: Color(0xff5c6baf),
                        fontWeight: FontWeight.w400,
                      ),
                      ),
                      Text("${DateTime.now().toLocal().hour.toString()}:${DateTime.timestamp().minute.toString()}",style:
                      TextStyle(
                        fontSize: 20,
                        color: Color(0xff5c6baf),
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      SizedBox(width: 20),
                      Text("${DateFormat("yyyy-MM-dd").format}"),
                      // Text("${DateTime.now().toLocal().month.toString()} ${DateTime.now().toLocal().day.toString()}, ${DateTime.now().toLocal().year.toString()}",
                      // style: TextStyle(
                      //   fontSize: 18,
                      //   color: Color(0xff5c6baf),
                      //   fontWeight: FontWeight.w400,
                      // ),
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text(elapsedTime,
                  style: TextStyle(fontSize: 55.0,
                      color: Color(0xff33394e),
                  fontWeight: FontWeight.bold)),
              SizedBox(height: 40.0),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 50,
                          child: FloatingActionButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                ),
                            backgroundColor: Color(0xffff723a),
                            onPressed: () => startOrStop(),
                            child: Text(startStop ? 'CLOCK IN' : "CLOCK OUT",
                            textAlign:TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                              ),),
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                          width: 140,
                          height: 40,
                          child: FloatingActionButton(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1,color: Color(0xff5c6baf),),
                                borderRadius: BorderRadius.circular(5.0),
                            ),
                            backgroundColor:Colors.white,
                            elevation: 0,
                            onPressed: () => startOrStop(),
                            child: Text("Take a Break",
                            textAlign:TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff8495e8),
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Break Time Left',
                          style: TextStyle(
                              color: Color(0xff8495e8),
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                          ),),
                            Text("30 Min",
                              style: TextStyle(
                                  color: Color(0xff8495e8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1.0
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Container(
                      color: Colors.black,
                      width: 820,
                      height: 520,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _screenshots.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              CapturedScreenAreaView(area: _screenshots[index].area),
                              SizedBox(height: 20),
                              Text(startStop ? "Current Time ${_screenshots[index].dateTime.hour}:${_screenshots[index].dateTime.minute}:${_screenshots[index].dateTime.second}" : '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white,
                              ),),
                                ],
                              ),
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
              ),
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
    final currentTime = DateTime.now();
    if (area != null) {
      setState(() {
        _screenshots.add(Screenshot(area, elapsedTime, currentTime));
      });
    }
  }
}