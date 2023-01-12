import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:curnect/src/common_widgets/appBar/dashboardAppbar.dart';
import 'package:curnect/src/pages/dash_board/screens/calendar/calendar.dart';
import 'package:curnect/src/pages/dash_board/screens/chat/screens/chat.dart';
import 'package:curnect/src/pages/dash_board/screens/service/service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../utils/events.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  int _currentIndex = 0;
  final _pageController = PageController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            const Calendar(),
            const Service(),
            const ChatBaseClass(),
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
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
            inactiveColor: Colors.black,
            activeColor: const Color(0xFFE6B325),
            title: const Text(
              'calendar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavyBarItem(
              inactiveColor: Colors.black,
              activeColor: const Color(0xFFE6B325),
              icon: const Icon(
                Icons.card_travel,
                color: Colors.black,
              ),
              title: const Text(
                'services',
                style: TextStyle(color: Colors.black),
              )),
          BottomNavyBarItem(
              activeColor: const Color(0xFFE6B325),
              inactiveColor: Colors.black,
              icon: const Icon(
                Icons.messenger_outline_sharp,
                color: Colors.black,
              ),
              title: const Text(
                'chat',
                style: TextStyle(color: Colors.black),
              )),
          BottomNavyBarItem(
              activeColor: const Color(0xFFE6B325),
              inactiveColor: Colors.black,
              icon: const Icon(
                Icons.calendar_view_day_outlined,
                color: Colors.black,
              ),
              title: const Text(
                'Service',
                style: TextStyle(color: Colors.black),
              )),
          BottomNavyBarItem(
              activeColor: const Color(0xFFE6B325),
              inactiveColor: Colors.black,
              icon: const Icon(
                Icons.bar_chart_rounded,
                color: Colors.black,
              ),
              title: const Text(
                'analytics',
                style: TextStyle(color: Colors.black),
              ))
        ],
        showElevation: false,
      ),
    );
  }
}
