import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:laravelflutter/constant.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);
int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('images/boosterdelivery.png')),
      const Text(
        'Set your delivery Locations',
        style: kPageViewTextStyle,
      )
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/orderonline.png')),
      const Text(
        'Order your favority services',
        style: kPageViewTextStyle,
      )
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/boosterdelivery.png')),
      const Text(
        'Quick delivery at your Doorstep',
        style: kPageViewTextStyle,
      )
    ],
  ),
];

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        const SizedBox(height: 50.0),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: const DotsDecorator(
            color: Colors.black87, // Inactive color
            activeColor: Colors.redAccent,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
      ]),
    );
  }
}
