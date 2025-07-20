import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final ScrollController _scrollController = ScrollController();
  late final List<MoodEntry> _entries;
  
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _entries = _generateDummyData();
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
        children: [
          // 고정된 달력 영역
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TableCalendar<MoodEntry>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                return _getEventsForDay(day);
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              rowHeight: 52,
              daysOfWeekHeight: 32,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                cellMargin: const EdgeInsets.all(4),
                selectedDecoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(fontSize: 13, color: AppTheme.textColor),
                weekendTextStyle: const TextStyle(fontSize: 13, color: AppTheme.textColor),
                selectedTextStyle: const TextStyle(fontSize: 13, color: AppTheme.textColor),
                todayTextStyle: const TextStyle(fontSize: 13, color: Colors.white),
                markersMaxCount: 0,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: Theme.of(context).textTheme.titleLarge!,
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: AppTheme.textColor,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: AppTheme.textColor,
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: AppTheme.textColor),
                weekendStyle: TextStyle(color: AppTheme.textColor),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final events = _getEventsForDay(day);
                  if (events.isEmpty) return null;
                  
                  final mood = events.first;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.day.toString(),
                        style: const TextStyle(fontSize: 13, color: AppTheme.textColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        mood.mood.emoji,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  final events = _getEventsForDay(day);
                  
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.day.toString(),
                          style: const TextStyle(fontSize: 13, color: AppTheme.textColor),
                        ),
                        if (events.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            events.first.mood.emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  final events = _getEventsForDay(day);
                  
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.day.toString(),
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        if (events.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            events.first.mood.emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _scrollToDate(selectedDay);
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              ),
            ),
          ),
          // 스크롤 가능한 일기 리스트
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return _MoodEntryCard(
                  key: ValueKey(entry.id),
                  entry: entry,
                  isSelected: _selectedDay != null && isSameDay(entry.date, _selectedDay!),
                );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
  
  List<MoodEntry> _getEventsForDay(DateTime day) {
    return _entries.where((entry) => isSameDay(entry.date, day)).toList();
  }
  
  void _scrollToDate(DateTime date) {
    final index = _entries.indexWhere((entry) => isSameDay(entry.date, date));
    if (index != -1) {
      _scrollController.animateTo(
        index * 120.0, // 대략적인 카드 높이
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  List<MoodEntry> _generateDummyData() {
    final now = DateTime.now();
    return [
      MoodEntry(
        id: '1',
        date: now,
        mood: Mood.veryHappy,
        memo: '오늘은 정말 좋은 하루였어요! 친구들과 맛있는 점심도 먹고 날씨도 좋았어요.',
      ),
      MoodEntry(
        id: '2',
        date: now.subtract(const Duration(days: 1)),
        mood: Mood.happy,
        memo: '프로젝트를 성공적으로 마무리했어요.',
      ),
      MoodEntry(
        id: '3',
        date: now.subtract(const Duration(days: 2)),
        mood: Mood.neutral,
        memo: '평범한 하루였어요.',
      ),
      MoodEntry(
        id: '4',
        date: now.subtract(const Duration(days: 3)),
        mood: Mood.sad,
        memo: '비가 와서 우울한 하루...',
      ),
      MoodEntry(
        id: '5',
        date: now.subtract(const Duration(days: 4)),
        mood: Mood.veryHappy,
        memo: '생일 파티가 정말 즐거웠어요!',
      ),
      MoodEntry(
        id: '6',
        date: now.subtract(const Duration(days: 5)),
        mood: Mood.happy,
        memo: '새로운 카페를 발견했어요. 분위기가 너무 좋았어요.',
      ),
      MoodEntry(
        id: '7',
        date: now.subtract(const Duration(days: 6)),
        mood: Mood.angry,
        memo: '지하철에서 불쾌한 일이 있었어요.',
      ),
    ];
  }
}

class _MoodEntryCard extends StatelessWidget {
  final MoodEntry entry;
  final bool isSelected;
  
  const _MoodEntryCard({
    super.key,
    required this.entry,
    this.isSelected = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM월 dd일 EEEE', 'ko_KR');
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: AppTheme.primaryColor, width: 2)
            : null,
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getMoodColor(entry.mood).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      entry.mood.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateFormat.format(entry.date),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.mood.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _getMoodColor(entry.mood),
                        ),
                      ),
                      if (entry.memo != null && entry.memo!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          entry.memo!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getMoodColor(Mood mood) {
    switch (mood) {
      case Mood.veryHappy:
        return AppTheme.happyColor;
      case Mood.happy:
        return AppTheme.joyColor;
      case Mood.neutral:
        return AppTheme.neutralColor;
      case Mood.sad:
        return AppTheme.sadColor;
      case Mood.angry:
        return AppTheme.angryColor;
    }
  }
}