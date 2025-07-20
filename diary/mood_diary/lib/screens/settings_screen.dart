import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 20, minute: 0);
  bool isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정'), centerTitle: true),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSection(
            title: '알림 설정',
            children: [
              _buildNotificationSwitch(),
              if (isNotificationEnabled) _buildNotificationTime(),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '앱 정보',
            children: [
              _buildInfoRow('버전', '1.0.0'),
              _buildInfoRow('개발자', '기분 일기팀'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.labelLarge),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildNotificationSwitch() {
    return ListTile(
      title: const Text('매일 알림 받기'),
      subtitle: const Text('설정한 시간에 일기 작성 알림을 받아요'),
      trailing: CupertinoSwitch(
        value: isNotificationEnabled,
        onChanged: (value) {
          setState(() {
            isNotificationEnabled = value;
          });
          if (value) {
            _showSnackbar('알림이 켜졌어요');
          } else {
            _showSnackbar('알림이 꺼졌어요');
          }
        },
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildNotificationTime() {
    return ListTile(
      title: const Text('알림 시간'),
      subtitle: Text(
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.access_time, color: AppTheme.primaryColor),
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppTheme.primaryColor,
                  onPrimary: Colors.white,
                  onSurface: AppTheme.textColor,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (picked != null && picked != selectedTime) {
          setState(() {
            selectedTime = picked;
          });
          _showSnackbar('알림 시간이 변경되었어요');
        }
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(
          color: AppTheme.subtitleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
