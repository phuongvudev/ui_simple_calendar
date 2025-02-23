import 'package:flutter/material.dart' show BuildContext, Widget;

/// [weekDays] is a list of week days to be built.
/// The length of the list is always 7.
typedef DCalendarWeekdayBuilder = Widget Function(
    BuildContext context, List<String> weekDays);

/// [day] is the day to be built.
/// [isSelected] is true if the day is selected.
/// [isCurrentMonth] is true if the day is in the current month.
/// [isToday] is true if the day is today.
typedef DCalendarDayBuilder = Widget Function(BuildContext context,
    DateTime day, bool isSelected, bool isCurrentMonth, bool isToday);

/// [month] is the month to be built.
/// The month is the first day of the month.
/// The month is used to build the header of the calendar.
/// The month is used to build the days of the calendar.
/// The month is used to build the week days of the calendar.
/// The month is used to build the footer of the calendar.
typedef DCalendarHeaderBuilder = Widget Function(
    BuildContext context, DateTime month);

/// [date] is the date to be validated if it is selectable.
typedef DCalendarOnSelectDatePredictable = bool Function(DateTime date);
