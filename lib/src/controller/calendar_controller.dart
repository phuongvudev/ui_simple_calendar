import 'package:flutter/foundation.dart';

/// Controller for the calendar.
final class UISimpleCalendarController extends ChangeNotifier {
  /// The selected date. Default is [DateTime.now()].
  DateTime selectedDate = DateTime.now();

  /// The current month. Default is [DateTime.now()]. The day is always 1.
  DateTime currentMonth = DateTime.now();

  /// The first date to be selected. Default is null.
  DateTime? firstDate;

  /// The last date to be selected. Default is null.
  DateTime? lastDate;

  UISimpleCalendarController();

  /// Sets the first date that is minimum to be selected.
  void setFirstDate(DateTime? date) {
    firstDate = date != null ? DateTime(date.year, date.month, date.day) : null;
    notifyListeners();
  }

  /// Sets the last date that is maximum to be selected.
  void setLastDate(DateTime? date) {
    lastDate = date != null ? DateTime(date.year, date.month, date.day) : null;
    notifyListeners();
  }

  /// Sets the selected date.
  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  /// Sets the current month.
  void setCurrentMonth(DateTime month) {
    currentMonth = month;
    notifyListeners();
  }

  /// Moves to the previous month.
  void movePreviousMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    notifyListeners();
  }

  /// Moves to the next month.
  void moveNextMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    notifyListeners();
  }
}
