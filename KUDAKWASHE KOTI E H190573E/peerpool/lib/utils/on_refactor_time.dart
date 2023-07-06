import 'package:flutter_countdown_timer/current_remaining_time.dart';

refactorTime(CurrentRemainingTime time) {
  //'${time.days}d:${time.hours}h:${time.min}m:${time.sec}s'
  int days = time.days;
  int hrs = time.hours;
  int mins = time.min;
  int secs = time.sec;

  days ??= 0;
  hrs ??= 0;
  mins ??= 0;
  secs ??= 0;

  if (days == 0) {
    return '${hrs}h:${mins}m:${secs}s';
  } else if (days == 0 && mins == 0) {
    return '${mins}m:${secs}s';
  } else {
    return '${days}d:${hrs}h:${mins}m:${secs}s';
  }
}
