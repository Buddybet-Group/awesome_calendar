part of custom_calendar;

class DefaultDayTileBuilder extends DayTileBuilder {
  DefaultDayTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date,
      void Function(DateTime dateTime)? onTap) {
    return DefaultDayTile(
      date: date,
      onTap: onTap,
    );
  }
}
