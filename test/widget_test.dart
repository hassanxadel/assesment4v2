import 'package:flutter_test/flutter_test.dart';
import 'package:location_app/main.dart';

void main() {
  testWidgets('Check if latitude and longitude are displayed',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the hardcoded latitude and longitude are displayed.
    expect(find.text('Latitude: 30.1420767'), findsOneWidget);
    expect(find.text('Longitude: 31.3252117'), findsOneWidget);
  });

  testWidgets('Check if the "Save Location" button is present',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the "Save Location" button is present.
    expect(find.text('Save Location'), findsOneWidget);
  });

  testWidgets('Navigate to saved locations screen',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Tap the "View Saved Locations" button.
    await tester.tap(find.text('View Saved Locations'));
    await tester.pumpAndSettle();

    // Verify that the saved locations screen is displayed.
    expect(find.text('Saved Locations'), findsOneWidget);
  });
}
