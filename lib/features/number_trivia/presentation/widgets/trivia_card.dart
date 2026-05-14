import 'package:flutter/material.dart';
import 'package:tdd_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaCard extends StatelessWidget {
  const TriviaCard({
    super.key,
    required this.trivia,
    required this.slideAnim,
    required this.fadeAnim,
  });

  final NumberTrivia trivia;
  final Animation<Offset> slideAnim;
  final Animation<double> fadeAnim;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: fadeAnim,
        child: SlideTransition(
          position: slideAnim,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1C1F35), Color(0xFF16192B)],
              ),
              border: Border.all(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF00D2FF)],
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '${trivia.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  trivia.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.65,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
