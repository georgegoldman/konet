import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:curnect/src/common_widgets/appBar/dashboardAppbar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> with ApplicationBar {
  int _currentIndex = 0;
  final _pageController = PageController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dashboardAppbar(),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            SizedBox(
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: ((selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                }),
                onFormatChanged: ((format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                }),
                onPageChanged: ((focusedDay) {
                  _focusedDay = focusedDay;
                }),
              ),
            ),
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.blue,
            ),
            Container(
              color: Colors.yellow,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.black,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            inactiveColor: Colors.white70,
            activeColor: const Color(0xFFE6B325),
            title: const Text(
              'calendar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          BottomNavyBarItem(
              inactiveColor: Colors.white70,
              activeColor: const Color(0xFFE6B325),
              icon: const Icon(Icons.card_travel),
              title: const Text('work')),
          BottomNavyBarItem(
              activeColor: const Color(0xFFE6B325),
              inactiveColor: Colors.white70,
              icon: const Icon(Icons.messenger_outline_sharp),
              title: const Text('chat')),
          BottomNavyBarItem(
              activeColor: const Color(0xFFE6B325),
              inactiveColor: Colors.white70,
              icon: const Icon(Icons.calendar_view_day_outlined),
              title: const Text('Service')),
          BottomNavyBarItem(
              activeColor: const Color(0xFFE6B325),
              inactiveColor: Colors.white70,
              icon: const Icon(Icons.bar_chart_rounded),
              title: const Text('analytics'))
        ],
        showElevation: false,
      ),
    );
  }
}
