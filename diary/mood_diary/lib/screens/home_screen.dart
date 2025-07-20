import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';
import 'mood_write_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Mood? selectedMood;
  
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateFormat = DateFormat('MM월 dd일 EEEE', 'ko_KR');
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                '오늘의 기분은\n어떠신가요?',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                dateFormat.format(today),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.subtitleColor,
                ),
              ),
              const SizedBox(height: 48),
              Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: Mood.values.map((mood) {
                    final isSelected = selectedMood == mood;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = mood;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? _getMoodColor(mood) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          mood.emoji,
                          style: TextStyle(
                            fontSize: isSelected ? 36 : 32,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (selectedMood != null) ...[
                const SizedBox(height: 24),
                Text(
                  selectedMood!.label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _getMoodColor(selectedMood!),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodWriteScreen(
                          preSelectedMood: selectedMood,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: const Text('기분 남기기'),
                ),
              ),
              const SizedBox(height: 32),
            ],
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