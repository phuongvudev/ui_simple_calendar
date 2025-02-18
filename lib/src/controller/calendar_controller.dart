import 'package:flutter/foundation.dart';

final class UISimpleCalendarController extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

  DateTime? firstDate;

  DateTime? lastDate;

  UISimpleCalendarController();

  void setFirstDate(DateTime? date) {
    firstDate = date != null ? DateTime(date.year, date.month, date.day) : null;
    notifyListeners();
  }

  void setLastDate(DateTime? date) {
    lastDate = date != null ? DateTime(date.year, date.month, date.day) : null;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setCurrentMonth(DateTime month) {
    currentMonth = month;
    notifyListeners();
  }

  void movePreviousMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    notifyListeners();
  }

  void moveNextMonth() {
    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    notifyListeners();
  }
}


