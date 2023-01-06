import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event extends StatelessWidget {
  final String name;
  final String title;
  final String time;
  const Event(
      {super.key, required this.name, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

/// Example event class.
// class Event  Widget {
//   final String title;

//   const Event(this.title);

//   @override
//   String toString() => title;
// }

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 4 + 1,
        (index) => Event(
              title: 'Event $item | ${index + 1}',
              name: 'John Doe',
              time: '11:15am - 1:00pm',
            ))
}..addAll({
    kToday: [
      const Event(
        title: 'Today\'s Event 1',
        name: 'Jane Doe',
        time: '8:20am - 10:12am',
      ),
      const Event(
        title: 'Today\'s Event 2',
        name: 'John Doe',
        time: '6:30pm - 11:40pm',
      ),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
