part of custom_calendar;

abstract class DayTileBuilder {
  Widget build(BuildContext context, DateTime date,
      void Function(DateTime dateTime)? onTap);
}
