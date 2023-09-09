import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

const String image = 'assets/elg0hary.jpg';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        backgroundColor: Color(0xff1c1c20),
        body: Center(
          child: MagicWandHover(
            height: 250,
            width: 250,
          ),
        ),
      ),
    );
  }
}

class MagicWandHover extends StatefulWidget {
  const MagicWandHover({
    super.key,
    required this.height,
    required this.width,
    this.imageCardColor = const Color(0xff353237),
    this.cardRadius = 32,
  });
  final double height;
  final double width;
  final Color imageCardColor;
  final double cardRadius;
  @override
  State<MagicWandHover> createState() => _MagicWandHoverState();
}

class _MagicWandHoverState extends State<MagicWandHover> {
  double mouseX = 0.0;
  double mouseY = 0.0;
  double magicWandRotation = -15;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * 2,
      width: widget.width * 4,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(widget.cardRadius),
        ),
      ),
      child: MouseRegion(
        onHover: (event) => setState(() {
          mouseX = event.position.dx;
          mouseY = event.position.dy;
          updateMagicWandRotation(mouseX);
        }),
        child: Card(
          elevation: 10,
          surfaceTintColor: Colors.transparent,
          color: const Color(0xff1d1b21),
          child: SizedBox(
            height: widget.height * 1.1,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              children: [
                const Positioned(
                  left: 480,
                  child: MagicImageCard(
                    angel: 8,
                    image:
                        'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                  ),
                ),
                const Positioned(
                  left: 270,
                  child: MagicImageCard(
                    angel: -3,
                    image:
                        'https://images.unsplash.com/photo-1461301214746-1e109215d6d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                  ),
                ),
                const Positioned(
                  left: 50,
                  top: 100,
                  child: MagicImageCard(
                    angel: 3,
                    image:
                        'https://images.unsplash.com/photo-1416339442236-8ceb164046f8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2003&q=80',
                  ),
                ),
                MagicWandWidget(
                  mouseX: mouseX,
                  mouseY: mouseY,
                  magicWandRotation: magicWandRotation,
                ),
                // const Text(
                //   'Generate Magic Photos',
                //   style: TextStyle(color: Colors.white, fontSize: 32),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateMagicWandRotation(double xPosition) {
    setState(() {
      magicWandRotation = ((xPosition / 1000) * 15 - 10).clamp(-15, 15);
    });
  }
}

class MagicImageCard extends StatefulWidget {
  const MagicImageCard({
    super.key,
    required this.angel,
    this.height = 250,
    this.width = 250,
    this.imageCardColor = const Color(0xff353237),
    required this.image,
  });

  final double angel;
  final double height;
  final double width;
  final Color imageCardColor;
  final String image;

  @override
  State<MagicImageCard> createState() => _MagicImageCardState();
}

class _MagicImageCardState extends State<MagicImageCard> {
  double blurValue = 10.0;
  double opacity = 0;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final hoverPositionX = event.localPosition.dx;
        final widgetWidth = context.size!.width;
        double percentage = (hoverPositionX / widgetWidth).clamp(0.0, 1.0);
        double newBlurValue = 10.0 - (10.0 * percentage);
        setState(() {
          blurValue = newBlurValue;
          if (blurValue > 6) {
            opacity = 0;
          } else {
            opacity = percentage;
          }
        });
      },
      child: Transform.rotate(
        angle: widget.angel * (pi / 180),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(32),
          ),
          child: Card(
            elevation: 5,
            surfaceTintColor: const Color(0xff353237),
            color: widget.imageCardColor,
            child: SizedBox(
                height: widget.height,
                width: widget.width,
                child: Stack(
                  children: [
                    //* Image
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: opacity,
                      child: Image.network(
                        widget.image,
                        height: widget.height,
                        width: widget.width,
                        fit: BoxFit.fill,
                      ),
                    ),
                    //* Blur
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: blurValue,
                        sigmaY: blurValue,
                      ),
                      child: const SizedBox.shrink(),
                    ),
                    //* Opacity
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 50),
                      opacity: blurValue / 100,
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class MagicWandWidget extends StatelessWidget {
  const MagicWandWidget({
    super.key,
    required this.mouseX,
    required this.mouseY,
    this.magicWandRotation = -15,
  });
  final double mouseX;
  final double mouseY;
  final double magicWandRotation;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: mouseX - MediaQuery.of(context).size.width / 4,
      top: mouseY * .45,
      duration: const Duration(milliseconds: 100),
      child: Transform.rotate(
        angle: magicWandRotation * (pi / 180),
        child: SizedBox(
          height: 400 + mouseX,
          width: 50,
          child: Column(
            children: [
              Container(
                height: 100,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                ),
              ),
              Container(
                height: 300 + mouseX,
                width: 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff1f1c21),
                      Color(0xff2f2d2f),
                      Color.fromARGB(255, 33, 31, 33),
                      Colors.black,
                      Colors.black,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
