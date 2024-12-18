
import '../dto/calendar.dart';

(List<MapEntry<String, Calendar>>, int)  initializeCalendar() {
  int initialIndex = 0;
  DateTime now = DateTime.now();

  Map<String, Calendar> calendars = {};
  int count = 0;
  for (int i = 1950; i < DateTime.now().year + 50; i++) {
    for (int j = 1; j <= 12; j++) {
      DateTime dateTime = DateTime(i, j, 1);
      if (dateTime.year == now.year && dateTime.month == now.month) {
        initialIndex = count;
      }
      count++;

      DateTime firstDay = DateTime(dateTime.year, dateTime.month, 1);
      int weekDay = firstDay.weekday;

      DateTime endOfMonth = getEndOfMonth(now);
      int lastDay = endOfMonth.day;
      List<String> days = []; // GridView에 표시할 데이터

      var emptyDaysToAdd = weekDay == 7 ? 0 : weekDay;
      days = List.generate(emptyDaysToAdd, (index) => '');
      days.addAll(List.generate(lastDay, (index) => (index + 1).toString()));

      Calendar calendar = Calendar(
          endOfMonth: endOfMonth,
          startDay: firstDay.day,
          lastDay: endOfMonth.day,
          days: days);

      String key = dateTime.year.toString() +
          (dateTime.month < 10
              ? '0${dateTime.month}'
              : dateTime.month.toString());
      calendars.addAll({key: calendar});
    }
  }

  return (calendars.entries.toList(), initialIndex);
}

DateTime getEndOfMonth(DateTime date) {
  // 다음 달의 첫 번째 날
  final nextMonth = DateTime(date.year, date.month + 1, 1);
  // 하루를 빼서 이번 달의 마지막 날 구하기
  final lastDay = nextMonth.subtract(Duration(days: 1));
  return lastDay;
}

String getDayOfTheWeek(String yearMonth, int day) {
  List<String> daysOfTheWeeks = ['월', '화', '수', '목', '금', '토', '일'];

  int year = int.parse(yearMonth.substring(0, 4));
  int month = int.parse(yearMonth.substring(4));
  int weekDay = DateTime(year, month, day).weekday;

  return daysOfTheWeeks[weekDay - 1];
}