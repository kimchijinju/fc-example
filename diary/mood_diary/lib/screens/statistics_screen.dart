import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moodCounts = _getMoodCounts();
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '지난 7일간 기분 분포',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '일주일 동안의 기분 변화를 한눈에 확인해보세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.subtitleColor,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              height: 350,
              padding: const EdgeInsets.all(20),
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
              child: BarChart(
                BarChartData(
                  maxY: _getMaxValue(moodCounts),
                  minY: 0,
                  barGroups: _getBarGroups(moodCounts),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < Mood.values.length) {
                            final mood = Mood.values[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                mood.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 == 0 && value >= 0) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.subtitleColor,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      getTooltipColor: (group) => AppTheme.primaryColor,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final mood = Mood.values[group.x];
                        return BarTooltipItem(
                          '${mood.label}\n${rod.toY.toInt()}회',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '기분별 횟수',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...Mood.values.map((mood) {
              final count = moodCounts[mood] ?? 0;
              return _MoodCountRow(mood: mood, count: count);
            }),
          ],
        ),
        ),
      ),
    );
  }
  
  Map<Mood, int> _getMoodCounts() {
    return {
      Mood.veryHappy: 3,
      Mood.happy: 2,
      Mood.neutral: 1,
      Mood.sad: 1,
      Mood.angry: 0,
    };
  }
  
  double _getMaxValue(Map<Mood, int> moodCounts) {
    final maxCount = moodCounts.values.fold(0, (max, count) => count > max ? count : max);
    return (maxCount + 1).toDouble(); // 최대값보다 1 큰 값으로 설정
  }
  
  List<BarChartGroupData> _getBarGroups(Map<Mood, int> moodCounts) {
    return Mood.values.map((mood) {
      final count = moodCounts[mood] ?? 0;
      return BarChartGroupData(
        x: mood.moodIndex,
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            color: _getMoodColor(mood),
            width: 40,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ],
      );
    }).toList();
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

class _MoodCountRow extends StatelessWidget {
  final Mood mood;
  final int count;
  
  const _MoodCountRow({required this.mood, required this.count});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            mood.emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Text(
            mood.label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: _getMoodColor(mood).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count회',
              style: TextStyle(
                color: _getMoodColor(mood),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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