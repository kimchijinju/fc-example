import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const FortuneApp());
}

class FortuneApp extends StatelessWidget {
  const FortuneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '운세 앱',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.notoSansTextTheme(),
      ),
      home: const FortuneHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FortuneHomePage extends StatefulWidget {
  const FortuneHomePage({super.key});

  @override
  State<FortuneHomePage> createState() => _FortuneHomePageState();
}

class _FortuneHomePageState extends State<FortuneHomePage> 
    with TickerProviderStateMixin {
  final List<String> _fortunes = [
    '오늘은 새로운 기회가 찾아올 것입니다.',
    '좋은 소식이 곧 들려올 예정입니다.',
    '인내심을 가지고 기다리면 좋은 결과가 있을 것입니다.',
    '오늘은 사랑하는 사람과 특별한 시간을 보내게 될 것입니다.',
    '새로운 도전을 시작하기에 좋은 날입니다.',
    '주변 사람들의 도움을 받게 될 것입니다.',
    '작은 행운이 연속으로 찾아올 것입니다.',
    '건강에 더욱 신경 쓰는 것이 좋겠습니다.',
    '오늘은 창의적인 아이디어가 떠오를 것입니다.',
    '금전적인 면에서 좋은 소식이 있을 것입니다.',
    '여행을 계획해보는 것이 좋겠습니다.',
    '새로운 인연을 만나게 될 것입니다.',
    '오늘은 평소보다 더 많이 웃게 될 것입니다.',
    '중요한 결정을 내리기에 좋은 날입니다.',
    '가족과의 시간을 더 많이 보내는 것이 좋겠습니다.',
    '오늘은 당신의 매력이 특히 빛날 것입니다.',
    '새로운 취미를 시작해보는 것이 어떨까요?',
    '오늘은 감사할 일들을 많이 발견하게 될 것입니다.',
    '직감을 믿고 행동해보세요.',
    '오늘은 당신에게 특별한 날이 될 것입니다.',
  ];

  String? _currentFortune;
  bool _isVisible = true;
  final Random _random = Random();
  late AnimationController _buttonController;
  late AnimationController _cardController;
  late Animation<double> _buttonScale;
  late Animation<double> _cardRotation;
  
  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    _cardRotation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
  }
  
  @override
  void dispose() {
    _buttonController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _showFortune() {
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });
    
    setState(() {
      _isVisible = false;
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _currentFortune = _fortunes[_random.nextInt(_fortunes.length)];
        _isVisible = true;
      });
      _cardController.forward().then((_) {
        _cardController.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF9A56), // 따뜻한 오렌지
              Color(0xFFFD79A8), // 부드러운 핑크
              Color(0xFFFF6B9D), // 로즈 골드
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.2,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.transparent,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '오늘의 운세',
                  style: GoogleFonts.notoSans(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: _currentFortune != null
                      ? AnimatedBuilder(
                          animation: _cardRotation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _cardRotation.value,
                              child: Card(
                                key: ValueKey(_currentFortune),
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                elevation: 0,
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFFFBF5), // 따뜻한 아이보리
                                        Color(0xFFFFF8E1), // 부드러운 크림
                                        Color(0xFFFFF3E0), // 연한 복숭아
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.15),
                                        blurRadius: 30,
                                        offset: const Offset(0, 15),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Colors.pink.withOpacity(0.08),
                                        blurRadius: 40,
                                        offset: const Offset(0, 25),
                                        spreadRadius: -5,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFF9A56),
                                              Color(0xFFFD79A8),
                                            ],
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.wb_sunny,
                                          size: 28,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _currentFortune!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.notoSans(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF8B4513),
                                          height: 1.7,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox(
                          key: ValueKey('empty'),
                          height: 200,
                        ),
                ),
                
                const SizedBox(height: 60),
                
                AnimatedBuilder(
                  animation: _buttonScale,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _buttonScale.value,
                      child: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: _showFortune,
                          onTapDown: (_) => _buttonController.forward(),
                          onTapUp: (_) => _buttonController.reverse(),
                          onTapCancel: () => _buttonController.reverse(),
                          borderRadius: BorderRadius.circular(30),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFF9A56), // 따뜻한 오렌지
                                  Color(0xFFFF6B9D), // 로즈 골드
                                  Color(0xFFFD79A8), // 부드러운 핑크
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_fix_high,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '운세 보기',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}