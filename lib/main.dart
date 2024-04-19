import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedItemIndex = 0;

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;
  final duration = const Duration(milliseconds: 800);

  final _colorList = [
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.indigoAccent,
    Colors.redAccent
  ];

  final double iconSize = 28;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: duration);
    _colorAnimation = ColorTween(
            begin: const Color(0xff807F87), end: _colorList[_selectedItemIndex])
        .animate(_animationController);
    _sizeAnimation = Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffA8BCF8),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40)),
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return LayoutBuilder(builder: (context, constraints) {
                final width = constraints.maxWidth;
                final spacing = (width - (iconSize * 4)) / (2 * 4);
                final left =
                    _selectedItemIndex * (iconSize + 2 * spacing) + spacing;
                return Stack(
                  fit: StackFit.loose,
                  children: [
                    BottomNavigationBar(
                        type: BottomNavigationBarType.fixed,
                        iconSize: iconSize,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        unselectedItemColor: const Color(0xff807F87),
                        selectedItemColor: _animationController.isCompleted ? _colorList[_selectedItemIndex] : const Color(0xff807F87),
                        elevation: 0,
                        currentIndex: _selectedItemIndex,
                        onTap: (value) {
                          setState(() {
                            _selectedItemIndex = value;
                            _colorAnimation = ColorTween(
                                    begin: const Color(0xff807F87),
                                    end: _colorList[_selectedItemIndex])
                                .animate(_animationController);
                            _animationController.reset();
                            _animationController.forward();
                          });
                        },
                        items: const [
                          BottomNavigationBarItem(
                            label: '',
                            icon: Icon(Icons.home_outlined),
                            activeIcon: Icon(Icons.home_filled),
                          ),
                          BottomNavigationBarItem(
                            label: '',
                            icon: Icon(CupertinoIcons.square_grid_2x2),
                            activeIcon: Icon(
                                CupertinoIcons.square_grid_2x2_fill),
                          ),
                          BottomNavigationBarItem(
                            label: '',
                            icon: Icon(CupertinoIcons.chart_pie),
                            activeIcon: Icon(CupertinoIcons.chart_pie_fill),
                          ),
                          BottomNavigationBarItem(
                            label: '',
                            icon: Icon(CupertinoIcons.heart),
                            activeIcon: Icon(CupertinoIcons.heart_fill),
                          )
                        ]),
                    AnimatedPositioned(
                        left: left ,
                        bottom: 0,
                        duration: duration,
                        child: Container(
                          height: 6,
                          width:  32 + (_sizeAnimation.value * 12),
                          decoration: BoxDecoration(
                              color: _colorAnimation.value,
                              borderRadius: BorderRadius.circular(8)),
                        ))
                  ],
                );
              });
            }),
      ),
    );
  }
}
