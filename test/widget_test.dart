import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xiao_app/app.dart';
import 'package:xiao_app/data/app_store.dart';
import 'package:xiao_app/data/models.dart';
import 'package:xiao_app/ui/components.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('IBM Plex Sans');
    for (final weight in ['Regular', 'Medium', 'Bold']) {
      fonts.addFont(rootBundle.load('assets/fonts/IBMPlexSans-$weight.ttf'));
    }
    await fonts.load();
  });
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('empty image slots keep their visible area', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      XiaoApp(
        store: AppStore(),
        initialRoute: '/feed',
        navigatorKey: navigator,
      ),
    );
    await tester.pumpAndSettle();
    final photo = find.byWidgetPredicate(
      (widget) =>
          widget is GreyBox && widget.label == 'Photo by Marian Marshall',
    );
    expect(tester.getSize(photo).width, greaterThan(300));
    expect(tester.getSize(photo).height, 210);
    navigator.currentState!.pushReplacementNamed('/music');
    await tester.pumpAndSettle();
    for (final box in find.byType(GreyBox).evaluate()) {
      final size = (box.renderObject! as RenderBox).size;
      expect(size.width, greaterThan(0));
      expect(size.height, greaterThan(0));
    }
  });
  testWidgets('login validates input and guest entry opens feeds', (
    tester,
  ) async {
    final store = AppStore();
    await tester.pumpWidget(XiaoApp(store: store, initialRoute: '/login'));
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    await tester.ensureVisible(find.text('Explore as guest'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Explore as guest'));
    await tester.pumpAndSettle();
    expect(find.text('Feeds'), findsOneWidget);
    expect(store.signedIn, true);
  });
  for (final size in [
    const Size(375, 812),
    const Size(320, 568),
    const Size(844, 390),
  ]) {
    testWidgets('screens render without overflow at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final store = AppStore()..addToCart(products.first, 'M', 0);
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        XiaoApp(store: store, initialRoute: '/feed', navigatorKey: navigator),
      );
      await tester.pumpAndSettle();
      for (final route in [
        '/walkthrough',
        '/welcome',
        '/login',
        '/signup',
        '/menu',
        '/feed',
        '/categories',
        '/articles',
        '/article',
        '/saved',
        '/shop',
        '/catalogue',
        '/product',
        '/cart',
        '/checkout',
        '/success',
        '/chats',
        '/conversation',
        '/music',
        '/player',
        '/profile',
        '/edit-profile',
        '/settings',
        '/balance',
      ]) {
        navigator.currentState!.pushReplacementNamed(route);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$route at $size');
      }
      store.setDark(true);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
