import 'package:Our_Calendar/utils/map_utils.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import '../dto/calendar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  late DateTime now = DateTime.now();
  late String title = '';
  var calendarMapEntries = [];
  late int initialIndex; // 오늘 날짜에 해당하는 초기 인덱스

  @override
  void initState() {
    super.initState();

    title = '${now.year}년 ${now.month}월';
    var (entries, index) = initializeCalendar();
    calendarMapEntries = entries;
    initialIndex = index;
  }

  void createNavigatorHandler() {
    Navigator.pushNamed(context, '/create');
  }

  // 모달 보여주기
  void showModalHandler(String yearMonth, String day) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final String dayOfTheWeek = getDayOfTheWeek(yearMonth, int.parse(day));
        return SizedBox(
          height: screenHeight * 0.82, // 화면 높이의 90%
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${int.parse(yearMonth.substring(4, 6))}월 ${day}일 ($dayOfTheWeek)',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    IconButton(
                        onPressed: () => createNavigatorHandler(),
                        icon: const Icon(
                          Icons.add,
                          size: 30.0,
                        ))
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Flexible(
                    child: ListView.separated(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.indigo[100]),
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                            child: Icon(
                              Icons.cake,
                              color: Colors.indigo[900],
                            ),
                          ),
                          Text(
                            '현하 생일',
                            style: TextStyle(
                                color: Colors.indigo[900],
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 10.0,
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            centerTitle: false,
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.calendar_month_rounded), label: ''),
              NavigationDestination(
                  icon: Icon(Icons.calendar_month_rounded), label: ''),
              NavigationDestination(
                  icon: Icon(Icons.calendar_month_rounded), label: ''),
            ]),
        body: <Widget>[
          // Calendar
          Card(
            margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox.expand(
                child: Column(
                  children: [
                    // 요일 헤더
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                      child: Row(
                        children:
                            ['일', '월', '화', '수', '목', '금', '토'].map((day) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: day == '일' || day == '토'
                                      ? Colors.red[300]
                                      : Colors.black38,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // 달력
                    Expanded(
                      child: Swiper(
                          loop: false,
                          itemCount: calendarMapEntries.length,
                          viewportFraction: 1,
                          scale: 1,
                          index: initialIndex,
                          onIndexChanged: (int index) {
                            // Swiper가 끝났을 때 상태 업데이트
                            final calendarMapEntry = calendarMapEntries[index];
                            String key = calendarMapEntry.key;

                            setState(() {
                              title =
                                  '${key.substring(0, 4)}년 ${key.substring(4, 6)}월';
                              initialIndex = index;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final calendarMapEntry = calendarMapEntries[index];
                            String yearMonth = calendarMapEntry.key;
                            Calendar calendar = calendarMapEntry.value;
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                // 화면의 높이와 폭을 기반으로 비율 계산
                                final double itemHeight =
                                    constraints.maxHeight / 5; // 5줄로 분배
                                final double itemWidth =
                                    constraints.maxWidth / 7; // 7열로 분배
                                final double aspectRatio =
                                    itemWidth / itemHeight;

                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7, // 7열
                                    childAspectRatio:
                                        aspectRatio, // 동적으로 계산된 비율
                                  ),
                                  itemCount: calendar.days.length,
                                  itemBuilder: (context, index) {
                                    String day = calendar.days[index];
                                    return SizedBox.expand(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () => showModalHandler(
                                                  yearMonth, day),
                                              child: Text(
                                                day,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox.expand(child: Text('Hello World2')),
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox.expand(child: Text('Hello World3')),
            ),
          ),
        ][currentPageIndex]);
  }
}
