// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedeyety/main.dart' as app;

Future init_stuff()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();



  testWidgets('Test test', (tester) async {
    await init_stuff();

    app.main();
    await tester.pumpAndSettle();

    /* Login Testing */
    final usernameField = find.byKey(Key("Username"));
    final passwordField = find.byKey(Key("Password"));
    final loginButton = find.byKey(Key("Login"));

    await tester.enterText(usernameField, "joe@mail.com");
    await tester.enterText(passwordField, "123456");

    await tester.pump();
    await tester.tap(loginButton);
    await tester.pumpAndSettle(Duration(seconds: 5));

    expect(find.byKey(Key("HomeFuture")), findsOneWidget);


    var fab = find.byKey(Key("CustomFAB"));

    /* Profile Page Testing */

    final profileButton = find.byKey(Key("ProfileNavBarButton"));

    await tester.tap(profileButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(find.text("Youssef"), findsAny);

    /* Create Event Testing */
    await tester.tap(fab);
    await tester.pumpAndSettle();

    final createEvent = find.byKey(Key("CreateEvent"));


    await tester.tap(createEvent);
    await tester.pumpAndSettle();

    final eventNameField = find.byKey(Key("EventNameField"));
    final eventLocationField = find.byKey(Key("EventLocationField"));
    final eventDescriptionField = find.byKey(Key("EventDescriptionField"));
    final datePickerButton = find.byKey(Key("EventDatePickerButton"));
    final createEventButton = find.byKey(Key("CreateEventButton"));



    await tester.enterText(eventNameField, "Birthday");
    await tester.enterText(eventLocationField, "Maadi");
    await tester.enterText(eventDescriptionField, "This is the party of my 23rd birthday, hope to see you all there!");
    await tester.pumpAndSettle();

    await tester.tap(datePickerButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('29'));
    await tester.pump();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();


    await tester.tap(createEventButton);
    await tester.pumpAndSettle(Duration(seconds: 5));

    final myEventsButton = find.byKey(Key("MyEventsPageNavBarButton"));
    await tester.tap(myEventsButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(find.text("Birthday"), findsOneWidget);



    /* Create Gift Testing */
    final createGift = find.byKey(Key("CreateGift"));
    fab = find.byKey(Key("CustomFAB"));

    await tester.tap(fab);
    await tester.pumpAndSettle();

    await tester.tap(createGift);
    await tester.pumpAndSettle();

    final giftNameField = find.byKey(Key("GiftNameField"));
    final giftPriceField = find.byKey(Key("GiftPriceField"));
    final giftDescriptionField = find.byKey(Key("GiftDescriptionField"));
    final giftCategoryDropDownButton = find.byKey(Key("GiftCategoryDropDownButton"));
    final giftEventDropDownButton = find.byKey(Key("GiftEventDropDownButton"));
    final createGiftButton = find.byKey(Key("CreateGiftButton"));

    await tester.enterText(giftNameField, "IPhone 16");
    await tester.enterText(giftPriceField, "100000");
    await tester.enterText(giftDescriptionField, "I want the new IPhone 16. You can find it many stores in Maadi or you can buy it online.");
    await tester.pumpAndSettle();

    await tester.tap(giftCategoryDropDownButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Electronics and Gadgets"));
    await tester.pumpAndSettle();

    await tester.tap(giftEventDropDownButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Birthday").last);
    await tester.pumpAndSettle();

    await tester.tap(createGiftButton);
    await tester.pumpAndSettle(Duration(seconds: 6));

    await tester.tap(find.text("Birthday"));
    await tester.pumpAndSettle();

    expect(find.text("IPhone 16"), findsOneWidget);

  });

}
