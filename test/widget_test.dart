import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibe_rise/main.dart';

void main() {
  group('VibeRise App Tests', () {
    testWidgets('App should render with correct initial state', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const VibeRiseApp());

      // Verify that the initial greeting text is present
      expect(
        find.text('Fellows Do Sleep Early, Rise Early. Now Rise with VibeRise'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Nee innum thoonkinayaa nanbaaa, illenna poyi thooonku chelloom...',
        ),
        findsOneWidget,
      );

      // Verify initial timer state
      expect(find.text('Stopped'), findsOneWidget);

      // Verify that the start button is present
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Tap to start quickly'), findsOneWidget);
    });

    testWidgets('Timer controls should work correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const VibeRiseApp());

      // Find and tap the start button
      await tester.tap(find.text('Start'));
      await tester.pump();

      // Verify that the timer is running
      expect(find.text('Stopped'), findsNothing);
      expect(find.text('Running • 00:00'), findsOneWidget);
      expect(find.text('Stop'), findsOneWidget);
      expect(find.text('Tap to stop Vibration'), findsOneWidget);

      // Tap stop button
      await tester.tap(find.text('Stop'));
      await tester.pump();

      // Verify that timer has stopped
      expect(find.text('Stopped'), findsOneWidget);
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Tap to start Vibration'), findsOneWidget);
    });
  });
}
