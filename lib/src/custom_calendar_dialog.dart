part of custom_calendar;

/// A custom date time picker that uses AwesomeCalendar
class CustomCalendarDialog extends StatefulWidget {
  const CustomCalendarDialog({
    this.initialDate,
    this.selectedDates,
    this.startDate,
    this.endDate,
    this.canToggleRangeSelection = false,
    this.selectionMode = SelectionMode.single,
    this.rangeToggleText = 'Select a date range',
    this.confirmBtnText = 'OK',
    this.cancelBtnText = 'CANCEL',
    this.dayTileBuilder,
    this.weekdayLabels,
    this.title,
    this.customSubmitButton,
    this.onSubmit,
    this.onCancel,
  });

  /// Initial date of the date picker, used to know which month needs to be shown
  final DateTime? initialDate;

  /// The current selected dates
  final List<DateTime>? selectedDates;

  /// First date of the calendar
  final DateTime? startDate;

  /// Last date of the calendar
  final DateTime? endDate;

  /// It will add a toggle to activate/deactivate the range selection mode
  final bool canToggleRangeSelection;

  /// [single, multi, range]
  /// The user can switch between multi and range if you set [canToggleRangeSelection] to true
  final SelectionMode selectionMode;

  /// Text of the range toggle if canToggleRangeSelection is true
  final String rangeToggleText;

  /// Text of the confirm button
  final String confirmBtnText;

  /// Text of the cancel button
  final String cancelBtnText;

  /// The builder to create a day widget
  final DayTileBuilder? dayTileBuilder;

  /// A Widget that will be shown on top of the Dialog as a title
  final Widget? title;

  /// The weekdays widget to show above the calendar
  final Widget? weekdayLabels;

  final Widget? customSubmitButton;

  final Function(dynamic)? onSubmit;

  final Function? onCancel;

  @override
  _CustomCalendarDialogState createState() => _CustomCalendarDialogState(
        currentMonth: initialDate,
        selectedDates: selectedDates,
        selectionMode: selectionMode,
      );
}

class _CustomCalendarDialogState extends State<CustomCalendarDialog> {
  _CustomCalendarDialogState({
    this.currentMonth,
    this.selectedDates,
    this.selectionMode = SelectionMode.single,
  }) {
    currentMonth ??= DateTime.now();
  }

  List<DateTime>? selectedDates;
  DateTime? currentMonth;
  SelectionMode selectionMode;
  GlobalKey<CustomCalendarState> calendarStateKey =
      GlobalKey<CustomCalendarState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.title != null) widget.title!,
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        calendarStateKey.currentState!.setCurrentDate(DateTime(
                            currentMonth!.year, currentMonth!.month - 1));
                      },
                    ),
                    Text(
                      DateFormat('yMMMM').format(currentMonth!),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        calendarStateKey.currentState!.setCurrentDate(DateTime(
                            currentMonth!.year, currentMonth!.month + 1));
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomCalendar(
                  key: calendarStateKey,
                  startDate: widget.startDate ?? DateTime(2018),
                  endDate: widget.endDate ?? DateTime(2100),
                  selectedSingleDate: currentMonth,
                  selectedDates: selectedDates,
                  selectionMode: selectionMode,
                  onPageSelected: (DateTime? start, DateTime? end) {
                    setState(() {
                      currentMonth = start;
                    });
                  },
                  dayTileBuilder: widget.dayTileBuilder,
                  weekdayLabels: widget.weekdayLabels,
                ),
              ),
              if (widget.canToggleRangeSelection &&
                  selectionMode != SelectionMode.single)
                ListTile(
                  title: Text(
                    widget.rangeToggleText,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 16),
                  ),
                  leading: Switch(
                    value: selectionMode == SelectionMode.range,
                    onChanged: (bool value) {
                      setState(() {
                        selectionMode =
                            value ? SelectionMode.range : SelectionMode.multi;
                        selectedDates = <DateTime>[];
                        calendarStateKey.currentState!.selectedDates =
                            selectedDates;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: Text(widget.cancelBtnText),
              onPressed: () {
                if (widget.onCancel != null) {
                  widget.onCancel!();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            const SizedBox(
              width: 50,
            ),
            (widget.customSubmitButton == null)
                ? TextButton(
                    child: Text(widget.confirmBtnText),
                    onPressed: () {
                      final CustomCalendarState? calendar =
                          calendarStateKey.currentState;
                      final selectedValue =
                          widget.selectionMode == SelectionMode.single
                              ? calendar!.selectedSingleDate
                              : calendar!.selectedDates;
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(selectedValue);
                      } else {
                        Navigator.of(context).pop(selectedValue);
                      }
                    },
                  )
                : GestureDetector(
                    onTap: () {
                      final CustomCalendarState? calendar =
                          calendarStateKey.currentState;
                      final selectedValue =
                          widget.selectionMode == SelectionMode.single
                              ? calendar!.selectedSingleDate
                              : calendar!.selectedDates;
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(selectedValue);
                      } else {
                        Navigator.of(context).pop(selectedValue);
                      }
                    },
                    child: widget.customSubmitButton!,
                  )
          ],
        )
      ],
    );
  }
}
