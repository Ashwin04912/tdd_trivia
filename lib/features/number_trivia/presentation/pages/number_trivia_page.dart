import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:tdd_trivia/features/number_trivia/presentation/widgets/animated_background.dart';
import 'package:tdd_trivia/features/number_trivia/presentation/widgets/error_card.dart';
import 'package:tdd_trivia/features/number_trivia/presentation/widgets/hint_card.dart';
import 'package:tdd_trivia/features/number_trivia/presentation/widgets/input_section.dart';
import 'package:tdd_trivia/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:tdd_trivia/features/number_trivia/presentation/widgets/trivia_card.dart';

class NumberTriviaPage extends StatefulWidget {
  const NumberTriviaPage({super.key});

  @override
  State<NumberTriviaPage> createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _triggerEntrance() {
    _slideController.forward(from: 0);
  }

  void _dispatchConcrete() {
    FocusScope.of(context).unfocus();
    context.read<NumberTriviaBloc>().add(
      GetTriviaForConcreteNumber(_controller.text),
    );
  }

  void _dispatchRandom() {
    FocusScope.of(context).unfocus();
    _controller.clear();
    context.read<NumberTriviaBloc>().add(const GetTriviaForRandomNumber());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NumberTriviaBloc, NumberTriviaState>(
      listener: (context, state) {
        if (state is NumberTriviaLoaded || state is NumberTriviaError) {
          _triggerEntrance();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E1A),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text(
            'Number Trivia',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // ── Animated background blobs ──────────────────────────────────
            AnimatedBackground(animation: _pulseAnim),

            // ── Content ───────────────────────────────────────────────────
            SafeArea(
              child: Column(
                children: [
                  // ── Trivia display area ──────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                        builder: (context, state) {
                          if (state is NumberTriviaInitial) {
                            return const HintCard();
                          } else if (state is NumberTriviaLoading) {
                            return const LoadingWidget();
                          } else if (state is NumberTriviaLoaded) {
                            return TriviaCard(
                              trivia: state.trivia,
                              slideAnim: _slideAnim,
                              fadeAnim: _fadeAnim,
                            );
                          } else if (state is NumberTriviaError) {
                            return ErrorCard(
                              message: state.message,
                              slideAnim: _slideAnim,
                              fadeAnim: _fadeAnim,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),

                  // ── Input section ────────────────────────────────────────
                  InputSection(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSearch: _dispatchConcrete,
                    onRandom: _dispatchRandom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
