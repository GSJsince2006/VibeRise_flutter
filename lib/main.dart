import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VibeRiseApp());
}

class VibeRiseApp extends StatelessWidget {
  const VibeRiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeRise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF05B2FF)),
        textTheme: const TextTheme(
          displaySmall: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      home: const GreetingScreen(),
    );
  }
}

class GreetingScreen extends StatefulWidget {
  const GreetingScreen({super.key});

  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  bool _running = false;
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  void _start() {
    HapticFeedback.lightImpact();
    setState(() => _running = true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  void _stop() {
    HapticFeedback.mediumImpact();
    setState(() => _running = false);
    _timer?.cancel();
    _elapsed = Duration.zero;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A2740), Color(0xFF0E3A5A), Color(0xFF0C4A6E)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Greeting
                  Text(
                    'Fellows Do Sleep Early, Rise Early. Now Rise with VibeRise',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nee innum thoonkinayaa nanbaaa, illenna poyi thooonku chelloom...',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 28),

                  // Timer chip
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: _running
                          ? Color.fromRGBO(255, 255, 255, 0.12)
                          : Color.fromRGBO(255, 255, 255, 0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.18),
                      ),
                    ),
                    child: Text(
                      _running ? 'Running • ${_fmt(_elapsed)}' : 'Stopped',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Big pill button (Start / Stop)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _running ? _stop : _start,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 24,
                        ),
                        shape: const StadiumBorder(),
                        elevation: 8,
                        shadowColor: Colors.black54,
                        backgroundColor: _running
                            ? scheme.error
                            : scheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        _running ? 'Stop' : 'Start',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Secondary subtle hint button row (optional)
                  Opacity(
                    opacity: 0.85,
                    child: TextButton(
                      onPressed: () =>
                          _running ? _stop() : _start(), // mirrors main action
                      child: Text(
                        _running
                            ? 'Tap to stop Vibration'
                            : 'Tap to start Vibration',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
