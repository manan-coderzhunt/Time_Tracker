import 'dart:async';
import 'package:flutter_screen_capture/flutter_screen_capture.dart';
import 'package:get/get.dart';

class Screenshot {
  final CapturedScreenArea area;
  final String captureTime;
  final DateTime dateTime;

  Screenshot(this.area, this.captureTime, this.dateTime);
}

class NewStopWatchController extends GetxController {
  final _plugin = ScreenCapture();
  var screenshots = <Screenshot>[].obs;
  Stopwatch watch = Stopwatch();
  Timer? timer;
  var startStop = true.obs;
  var showClearButton = false.obs;

  var elapsedTime = '00:00:00'.obs;

  updateTime(Timer timer) {
    if (watch.isRunning) {
      elapsedTime.value = transformMilliSeconds(watch.elapsedMilliseconds);
    }
  }

  ScreenTimerUpdate(Timer timer) {
    _captureFullScreen();
  }

  startOrStop() {
    if (startStop.value) {
      startWatch();
      NewScreenTimer();
    } else {
      stopWatch();
    }
  }

  startWatch() {
    startStop.value = false;
    watch.start();
    watch.reset();
    timer = Timer.periodic(const Duration(seconds: 1), updateTime);
  }

  NewScreenTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), ScreenTimerUpdate);
    _captureFullScreen();
  }

  stopWatch() {
    startStop.value = true;
    showClearButton.value = true;
    watch.reset();
    watch.stop();
    timer?.cancel();
    setTime();
  }

  clearScreenshots() {
    screenshots.clear();
    showClearButton.value = false;
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    elapsedTime.value = transformMilliSeconds(timeSoFar);
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
      screenshots.add(Screenshot(area, elapsedTime.value, currentTime));
    }
  }
}
