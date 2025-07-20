import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';
import '../theme/app_theme.dart';

class MoodWriteScreen extends StatefulWidget {
  final Mood? preSelectedMood;
  
  const MoodWriteScreen({super.key, this.preSelectedMood});

  @override
  State<MoodWriteScreen> createState() => _MoodWriteScreenState();
}

class _MoodWriteScreenState extends State<MoodWriteScreen> {
  Mood? selectedMood;
  final TextEditingController memoController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    selectedMood = widget.preSelectedMood;
  }
  
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateFormat = DateFormat('yyyy년 MM월 dd일', 'ko_KR');
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                dateFormat.format(today),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.subtitleColor,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '오늘의 기분',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: Mood.values.map((mood) {
                      final isSelected = selectedMood == mood;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMood = mood;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? _getMoodColor(mood) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedScale(
                                  scale: isSelected ? 1.1 : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutBack,
                                  child: Text(
                                    mood.emoji,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedOpacity(
                                  opacity: isSelected ? 1.0 : 0.6,
                                  duration: const Duration(milliseconds: 200),
                                  child: Text(
                                    mood.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected ? AppTheme.textColor : AppTheme.subtitleColor,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '오늘의 한 줄',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: memoController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '오늘 있었던 일을 간단히 적어보세요',
                filled: true,
                fillColor: Colors.white,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedMood != null ? () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('기분이 저장되었어요!'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedMood != null ? AppTheme.primaryColor : Colors.grey.shade300,
                ),
                child: const Text('저장하기'),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
  
  Color _getMoodColor(Mood mood) {
    switch (mood) {
      case Mood.veryHappy:
        return AppTheme.happyColor.withOpacity(0.3);
      case Mood.happy:
        return AppTheme.joyColor.withOpacity(0.3);
      case Mood.neutral:
        return AppTheme.neutralColor.withOpacity(0.3);
      case Mood.sad:
        return AppTheme.sadColor.withOpacity(0.3);
      case Mood.angry:
        return AppTheme.angryColor.withOpacity(0.3);
    }
  }
  
  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }
}