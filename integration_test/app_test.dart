import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xiao_app/app.dart';
import 'package:xiao_app/data/app_store.dart';
import 'package:xiao_app/data/models.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'complete shopping flow, messaging, theme and all screen captures',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final store = AppStore();
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        XiaoApp(
          store: store,
          initialRoute: '/walkthrough',
          navigatorKey: navigator,
        ),
      );
      await tester.pumpAndSettle();
      Future<void> capture(String name) async {
        ScaffoldMessenger.of(navigator.currentContext!).removeCurrentSnackBar();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: name);
        await binding.takeScreenshot(name);
      }

      Future<void> open(String route, String name, [Object? args]) async {
        navigator.currentState!.pushNamedAndRemoveUntil(
          route,
          (_) => false,
          arguments: args,
        );
        await capture(name);
      }

      await capture('01_walkthrough');
      await tester.tap(find.text('Get started'));
      await capture('02_welcome');
      await tester.tap(find.text('Sign Up'));
      await capture('03_signup');
      await open('/login', '04_login');
      await tester.ensureVisible(find.text('Explore as guest'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Explore as guest'));
      await capture('05_feeds');
      await tester.tap(find.byTooltip('Open navigation'));
      await capture('06_navigation');
      await tester.tap(find.text('Articles'));
      await capture('07_categories');
      await open('/articles', '08_articles');
      await tester.tap(find.text(stories.first.title));
      await capture('09_article_detail');
      await tester.tap(find.byTooltip('Save article'));
      await tester.pumpAndSettle();
      expect(store.saved.contains(stories.first.title), true);
      await open('/saved', '10_saved_articles');
      await open('/shop', '11_shop');
      await tester.tap(find.byTooltip('Browse products'));
      await capture('12_catalogue');
      await tester.tap(find.text(products.first.name));
      await capture('13_product');
      await tester.tap(find.text('Add to Bag'));
      await capture('14_cart');
      await tester.tap(find.byTooltip('Increase quantity'));
      await tester.pumpAndSettle();
      expect(store.bagCount, 2);
      await tester.tap(find.text('Checkout'));
      await capture('15_shipping');
      await tester.tap(find.text('Next'));
      await capture('16_payment');
      await tester.tap(find.text('Next'));
      await capture('17_order_review');
      await tester.tap(find.text('Place demo order'));
      await capture('18_order_success');
      expect(store.bagCount, 0);
      expect(store.orderCount, 1);
      await open('/chats', '19_chats');
      await tester.tap(find.text(contacts.first));
      await capture('20_conversation');
      await tester.enterText(find.byType(TextField), 'See you at six!');
      await tester.tap(find.byTooltip('Send message'));
      await tester.pumpAndSettle();
      expect(store.messages(contacts.first).last.text, 'See you at six!');
      await open('/music', '21_music');
      await open('/player', '22_player', 1);
      await open('/balance', '23_balance');
      await tester.tap(find.text('Weekly'));
      await tester.pumpAndSettle();
      await open('/profile', '24_profile');
      await tester.tap(find.text('Edit profile'));
      await capture('25_edit_profile');
      await tester.enterText(find.byType(TextFormField).first, 'Xiao Tester');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(store.name, 'Xiao Tester');
      await open('/settings', '26_settings');
      await tester.tap(find.byType(Switch));
      await capture('27_dark_settings');
      expect(store.dark, true);
      await open('/feed', '28_dark_feeds');
      store.setDark(false);
      await tester.pumpAndSettle();
      await open('/feed', '29_final_home');
    },
  );
}
