import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final dateFmt = DateFormat.yMMMd();
final dateTimeFmt = DateFormat.yMMMd().add_jm();
final shortDateFmt = DateFormat.MMMd();
final weekdayFmt = DateFormat.EEEE();
final timeFmt = DateFormat.jm();

String formatMinutes(int total) {
  final hours = total ~/ 60;
  final minutes = total % 60;
  if (hours == 0) return '${minutes}m';
  if (minutes == 0) return '${hours}h';
  return '${hours}h ${minutes}m';
}

String formatClock(int seconds) {
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

String greetingFor(DateTime now) {
  final hour = now.hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

TimeOfDay minutesToTime(int minutes) =>
    TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

int timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

String formatTimeOfDay(BuildContext context, int minutes) =>
    minutesToTime(minutes).format(context);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
