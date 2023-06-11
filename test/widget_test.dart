import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_app/components/snackbars.dart';

void main() {
  group('snackbars', () {
    testWidgets('messageSnackBar should display the correct message',
        (WidgetTester tester) async {
      const message = 'This is a message';
      const trailing = Icon(Icons.check);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      messageSnackBar(message, trailing),
                    );
                  },
                  child: const Text('Show SnackBar'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text(message), findsNothing);

      await tester.tap(find.text('Show SnackBar'));
      await tester.pumpAndSettle();

      expect(find.text(message), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('errorSnackBar should display the correct error message',
        (WidgetTester tester) async {
      const errorMessage = 'An error occurred';

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(errorSnackBar(errorMessage));
                  },
                  child: const Text('Show SnackBar'),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text(errorMessage), findsNothing);
      expect(find.byIcon(Icons.error_outline), findsNothing);

      await tester.tap(find.text('Show SnackBar'));
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
