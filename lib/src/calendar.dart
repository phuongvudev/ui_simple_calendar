import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui_simple_calendar/src/builders/calendar_builder.dart';
import 'package:ui_simple_calendar/src/controller/calendar_controller.dart';

class UISimpleCalendar extends StatefulWidget {
  /// The initial date to be selected. Default is [DateTime.now()].
  final DateTime? initialDate;

  /// Callback when a date is selected.
  final ValueChanged<DateTime>? onDateSelected;

  /// Builder for the week days.
  final DCalendarWeekdayBuilder? weekdayBuilder;

  /// Builder for the days.
  final DCalendarDayBuilder? dayBuilder;

  /// Builder for the header.
  final DCalendarHeaderBuilder? headerBuilder;

  /// The first date to be selected. Default is null.
  final DateTime? firstDate;

  /// The last date to be selected. Default is null.
  final DateTime? lastDate;

  /// Callback to validate if a date is selectable.
  final DCalendarOnSelectDatePredictable? onSelectDatePredictable;

  /// The controller for the calendar.
  final UISimpleCalendarController controller;

  const UISimpleCalendar({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.weekdayBuilder,
    this.dayBuilder,
    this.headerBuilder,
    this.firstDate,
    this.lastDate,
    this.onSelectDatePredictable,
    required this.controller,
  });

  @override
  State<UISimpleCalendar> createState() => _UISimpleCalendarState();
}

class _UISimpleCalendarState extends State<UISimpleCalendar> {
  final List<String> weekDays =
      DateFormat("EEEE").dateSymbols.STANDALONENARROWWEEKDAYS.toList();

  late UISimpleCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    initInitialDate();
  }

  void initInitialDate() {
    DateTime now = DateTime.now();
    _controller.setFirstDate(widget.firstDate);
    _controller.setLastDate(widget.lastDate);

    _controller.selectedDate =
        widget.initialDate ?? DateTime(now.year, now.month, now.day);

    _controller.lastDate = widget.lastDate != null
        ? DateTime(
            widget.lastDate!.year, widget.lastDate!.month, widget.lastDate!.day)
        : null;

    // Ensure the initial date is within the min/max date range
    if (_controller.firstDate != null &&
        _controller.selectedDate.isBefore(_controller.firstDate!)) {
      _controller.setSelectedDate(_controller.firstDate!);
    }

    if (_controller.lastDate != null &&
        _controller.selectedDate.isAfter(_controller.lastDate!)) {
      _controller.setSelectedDate(_controller.lastDate!);
    }

    _controller.setCurrentMonth(DateTime(
        _controller.selectedDate.year, _controller.selectedDate.month));
  }

  @override
  void didUpdateWidget(covariant UISimpleCalendar oldWidget) {
    if (oldWidget.initialDate != widget.initialDate ||
        widget.firstDate != oldWidget.firstDate ||
        widget.lastDate != oldWidget.lastDate) {
      initInitialDate();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildWeekDays(),
              const SizedBox(height: 4),
              _buildDays(),
            ],
          );
        });
  }

  Widget _buildHeader() {
    return widget.headerBuilder?.call(context, _controller.currentMonth) ??
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    DateFormat.MMMM().format(_controller.currentMonth),
                    style: Theme.of(context).textTheme.headlineMedium?.apply(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(width: 11),
                  Text(
                    DateFormat.y().format(_controller.currentMonth),
                    style: Theme.of(context).textTheme.displayMedium?.apply(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _canNavigateToPreviousMonth(),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: IconButton(
                onPressed: _moveToPreviousMonth,
                icon: Icon(Icons.chevron_left,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
            IconButton(
                onPressed: _canNavigateToNextMonth() ? _moveToNextMonth : null,
                icon: Icon(Icons.chevron_right,
                    color: Theme.of(context).colorScheme.primary)),
          ],
        );
  }

  Widget _buildWeekDays() {
    return widget.weekdayBuilder?.call(context, weekDays) ??
        GridView.count(
            crossAxisCount: 7,
            mainAxisSpacing: 0,
            crossAxisSpacing: 14,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: weekDays
                .map((day) => Center(
                      child: Text(
                        day,
                        style: Theme.of(context).textTheme.titleMedium?.apply(),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList());
  }

  Widget _buildDays() {
    // Get the total number of days in the current month
    int daysInMonth = DateTime(_controller.currentMonth.year,
            _controller.currentMonth.month + 1, 0)
        .day;

    // Get the first day of the month and its weekday
    DateTime firstDayOfMonth = DateTime(
        _controller.currentMonth.year, _controller.currentMonth.month, 1);
    int firstWeekDay = firstDayOfMonth.weekday % 7; // Adjust to make Sunday = 0

    // Calculate days from the previous month to show
    DateTime lastDayPreviousMonth = DateTime(
        _controller.currentMonth.year, _controller.currentMonth.month, 0);
    int daysInPreviousMonth = lastDayPreviousMonth.day;

    List<Widget> dayWidgets = [];

    // Add previous month's days
    for (int i = 0; i < firstWeekDay; i++) {
      int day = daysInPreviousMonth - firstWeekDay + i + 1;
      dayWidgets.add(
        _buildDayCell(
          DateTime(_controller.currentMonth.year,
              _controller.currentMonth.month - 1, day),
          isCurrentMonth: false,
        ),
      );
    }

    // Add current month's days
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(
        _buildDayCell(
          DateTime(_controller.currentMonth.year,
              _controller.currentMonth.month, day),
          isCurrentMonth: true,
        ),
      );
    }

    // Calculate remaining cells to complete the grid (next month's days)
    int remainingCells =
        42 - dayWidgets.length; // 5 rows x 7 columns = 35 cells
    for (int i = 1; i <= remainingCells; i++) {
      dayWidgets.add(
        _buildDayCell(
          DateTime(_controller.currentMonth.year,
              _controller.currentMonth.month + 1, i),
          isCurrentMonth: false,
        ),
      );
    }
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisCount: 7,
      childAspectRatio: 1.0,
      crossAxisSpacing: 14,
      mainAxisSpacing: 16,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(DateTime date, {required bool isCurrentMonth}) {
    var status = WidgetState.focused;

    if (!_isSelectableDate(date) || !isCurrentMonth) {
      status = WidgetState.disabled;
    } else if (isCurrentMonth && _isSameDay(date, _controller.selectedDate)) {
      status = WidgetState.selected;
    }

    final isToday = _isSameDay(date, DateTime.now());

    var textColor = Theme.of(context).colorScheme.onSurface;
    var backgroundColor = Colors.transparent;

    if (status == WidgetState.disabled) {
      textColor =
          Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3);
    } else if (status == WidgetState.selected) {
      textColor = Theme.of(context).colorScheme.onPrimary;
    }

    return GestureDetector(
      onTap: status == WidgetState.disabled ? null : () => _onSelectDate(date),
      child: widget.dayBuilder?.call(context, date,
              status == WidgetState.selected, isCurrentMonth, isToday) ??
          Container(
            decoration: BoxDecoration(
              color: status == WidgetState.selected
                  ? Theme.of(context).colorScheme.primary
                  : backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              "${date.day}".padLeft(2, '0'),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.apply(color: textColor),
            ),
          ),
    );
  }

  void _moveToPreviousMonth() {
    _controller.movePreviousMonth();
  }

  void _moveToNextMonth() {
    _controller.moveNextMonth();
  }

  void _onSelectDate(DateTime date) {
    _controller.setSelectedDate(date);
    widget.onDateSelected?.call(date);
  }

  bool _canNavigateToPreviousMonth() {
    DateTime firstDateOfPreviousMonth = DateTime(
        _controller.currentMonth.year, _controller.currentMonth.month - 1, 1);
    DateTime lastDateOfPreviousMonth = DateTime(
        _controller.currentMonth.year, _controller.currentMonth.month, 0);

    if (_controller.firstDate != null &&
        lastDateOfPreviousMonth.isBefore(_controller.firstDate!)) {
      return false;
    }

    return _hasSelectableDatesInMonth(
      firstDateOfPreviousMonth,
      lastDateOfPreviousMonth,
    );
  }

  bool _canNavigateToNextMonth() {
    DateTime firstDateOfNextMonth = DateTime(
        _controller.currentMonth.year, _controller.currentMonth.month + 1, 1);
    DateTime lastDateOfNextMonth = DateTime(
        _controller.currentMonth.year, _controller.currentMonth.month + 2, 0);

    if (_controller.lastDate != null &&
        firstDateOfNextMonth.isAfter(_controller.lastDate!)) {
      return false;
    }

    return _hasSelectableDatesInMonth(
        firstDateOfNextMonth, lastDateOfNextMonth);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isSelectableDate(DateTime date) {
    if (_controller.firstDate != null &&
        (date.isBefore(_controller.firstDate!))) {
      return false;
    }
    if (_controller.lastDate != null && date.isAfter(_controller.lastDate!)) {
      return false;
    }
    if (widget.onSelectDatePredictable != null &&
        !widget.onSelectDatePredictable!(date)) {
      return false;
    }
    return true;
  }

  bool _hasSelectableDatesInMonth(DateTime start, DateTime end) {
    for (DateTime date = start;
        date.isBefore(end) || date.isAtSameMomentAs(end);
        date = date.add(const Duration(days: 1))) {
      if (widget.onSelectDatePredictable == null ||
          widget.onSelectDatePredictable!(date)) {
        return true;
      }
    }
    return false;
  }
}
