import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../login/login.dart';


class CosmicLandingPage extends StatefulWidget {
  const CosmicLandingPage({super.key});

  @override
  State<CosmicLandingPage> createState() => _CosmicLandingPageState();
}

class _CosmicLandingPageState extends State<CosmicLandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        const Color(0xFF1a0033),
                        const Color(0xFF330066),
                        math.sin(_controller.value * 2 * math.pi) * 0.5 + 0.5,
                      )!,
                      Color.lerp(
                        const Color(0xFF0d001a),
                        const Color(0xFF1a0033),
                        math.cos(_controller.value * 2 * math.pi) * 0.5 + 0.5,
                      )!,
                      const Color(0xFF000000),
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating Particles
          ...List.generate(30, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = (_controller.value + index / 30) % 1.0;
                return Positioned(
                  left: (index * 37) % MediaQuery.of(context).size.width,
                  top: offset * MediaQuery.of(context).size.height,
                  child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // Main Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Title with Glow Effect
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                Color.lerp(
                                  Colors.cyan,
                                  Colors.purple,
                                  math.sin(_controller.value * 2 * math.pi) *
                                          0.5 +
                                      0.5,
                                )!,
                                Color.lerp(
                                  Colors.pink,
                                  Colors.orange,
                                  math.cos(_controller.value * 2 * math.pi) *
                                          0.5 +
                                      0.5,
                                )!,
                              ],
                            ).createShader(bounds);
                          },
                          child: const Text(
                            '✨ COSMIC JOURNEY ✨',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 60),

                    // Glowing Container with Message
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.withOpacity(0.3),
                                Colors.blue.withOpacity(0.3),
                                Colors.pink.withOpacity(0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Color.lerp(
                                Colors.cyan,
                                Colors.pink,
                                math.sin(_controller.value * 2 * math.pi) *
                                        0.5 +
                                    0.5,
                              )!,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.lerp(
                                  Colors.cyan,
                                  Colors.pink,
                                  math.sin(_controller.value * 2 * math.pi) *
                                          0.5 +
                                      0.5,
                                )!
                                    .withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Welcome to the Future',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Where imagination meets reality\nand dreams come alive',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 50),

                    // Animated Image with Glow
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: math.sin(_controller.value * 2 * math.pi) * 0.05,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyan.withOpacity(0.6),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                'https://picsum.photos/350/250',
                                width: 350,
                                height: 250,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 350,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.purple.withOpacity(0.3),
                                          Colors.blue.withOpacity(0.3),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.cyan,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 50),

                    // Interactive Hover Button
                    MouseRegion(
                      onEnter: (_) => setState(() => _isHovering = true),
                      onExit: (_) => setState(() => _isHovering = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.identity()
                          ..scale(_isHovering ? 1.1 : 1.0),
                        child: GestureDetector(
                          onTap: () {
                            print('Button Clicked!');
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    const FunkyLoginScreen(),
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF8E53),
                                  Color(0xFFFECA57),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.6),
                                  blurRadius: _isHovering ? 30 : 20,
                                  spreadRadius: _isHovering ? 5 : 0,
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'BEGIN YOUR JOURNEY',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                               
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}