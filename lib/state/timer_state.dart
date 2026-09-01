import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum TimerMode { focus, shortBreak, longBreak }

class TimerState extends ChangeNotifier {
  TimerMode mode = TimerMode.focus;
  int focusMinutes = 25;
  int shortBreakMinutes = 5;
  int longBreakMinutes = 15;
  int roundsUntilLong = 4;
  int completedFocusRounds = 0;
  String? subjectId;

  bool running = false;
  DateTime? _startedAt;
  int _elapsedBeforePause = 0;
  int _totalSeconds = 25 * 60;
  Timer? _ticker;
  DateTime? sessionStartedAt;

  int get remainingSeconds {
    final extra = running && _startedAt != null
        ? DateTime.now().difference(_startedAt!).inSeconds
        : 0;
    final left = _totalSeconds - _elapsedBeforePause - extra;
    return left < 0 ? 0 : left;
  }

  int get durationSeconds => _totalSeconds;

  double get progress {
    if (_totalSeconds == 0) return 0;
    return 1 - (remainingSeconds / _totalSeconds);
  }

  int get modeMinutes {
    switch (mode) {
      case TimerMode.focus:
        return focusMinutes;
      case TimerMode.shortBreak:
        return shortBreakMinutes;
      case TimerMode.longBreak:
        return longBreakMinutes;
    }
  }

  void setSubject(String? id) {
    subjectId = id;
    notifyListeners();
  }

  void setDurations({int? focus, int? shortBreak, int? longBreak}) {
    if (running) return;
    if (focus != null) focusMinutes = focus.clamp(1, 180);
    if (shortBreak != null) shortBreakMinutes = shortBreak.clamp(1, 60);
    if (longBreak != null) longBreakMinutes = longBreak.clamp(1, 60);
    _resetClock();
    notifyListeners();
  }

  void switchMode(TimerMode next) {
    if (running) pause();
    mode = next;
    _resetClock();
    notifyListeners();
  }

  void start() {
    if (running) return;
    if (mode == TimerMode.focus && sessionStartedAt == null) {
      sessionStartedAt = DateTime.now();
    }
    running = true;
    _startedAt = DateTime.now();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  void pause() {
    if (!running) return;
    _elapsedBeforePause =
        _totalSeconds - remainingSeconds.clamp(0, _totalSeconds);
    running = false;
    _startedAt = null;
    _ticker?.cancel();
    notifyListeners();
  }

  void reset() {
    running = false;
    _startedAt = null;
    _elapsedBeforePause = 0;
    sessionStartedAt = null;
    _ticker?.cancel();
    _resetClock();
    notifyListeners();
  }

  /// Returns focus minutes to log when a focus session completes.
  int? _tick() {
    if (remainingSeconds > 0) {
      notifyListeners();
      return null;
    }
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
    running = false;
    _ticker?.cancel();
    _startedAt = null;
    _elapsedBeforePause = 0;
    int? logged;
    if (mode == TimerMode.focus) {
      logged = focusMinutes;
      completedFocusRounds++;
      sessionStartedAt = null;
      mode = completedFocusRounds % roundsUntilLong == 0
          ? TimerMode.longBreak
          : TimerMode.shortBreak;
    } else {
      mode = TimerMode.focus;
    }
    lastCompletedFocusMinutes = logged;
    _resetClock();
    notifyListeners();
    return logged;
  }

  int? lastCompletedFocusMinutes;

  int? consumeCompletedFocus() {
    final value = lastCompletedFocusMinutes;
    lastCompletedFocusMinutes = null;
    return value;
  }

  void skip() {
    pause();
    if (mode == TimerMode.focus) {
      completedFocusRounds++;
      mode = completedFocusRounds % roundsUntilLong == 0
          ? TimerMode.longBreak
          : TimerMode.shortBreak;
    } else {
      mode = TimerMode.focus;
    }
    sessionStartedAt = null;
    _resetClock();
    notifyListeners();
  }

  void _resetClock() {
    _totalSeconds = modeMinutes * 60;
    _elapsedBeforePause = 0;
    _startedAt = null;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
