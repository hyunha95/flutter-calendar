class Calendar {
  late DateTime endOfMonth;
  late int startDay;
  late int lastDay;
  List<String> days = []; // GridView에 표시할 데이터
  List<String> weekDays = [];

  Calendar({
    required this.endOfMonth,
    required this.startDay,
    required this.lastDay,
    required this.days
  });
}