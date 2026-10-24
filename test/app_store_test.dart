import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xiao_app/data/app_store.dart';
import 'package:xiao_app/data/models.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test(
    'cart merges identical variants, preserves different sizes, calculates shipping',
    () {
      final store = AppStore();
      store.addToCart(products.first, 'M', 0);
      store.addToCart(products.first, 'M', 0);
      expect(store.cart.length, 1);
      expect(store.bagCount, 2);
      expect(store.subtotal, closeTo(69.98, .001));
      expect(store.total, closeTo(74.83, .001));
      store.addToCart(products.first, 'S', 0);
      expect(store.cart.length, 2);
      expect(store.shipping, 0);
      store.changeQuantity(store.cart.first, -2);
      expect(store.bagCount, 1);
      store.changeQuantity(store.cart.first, 100);
      expect(store.bagCount, 99);
    },
  );
  test('placing an order clears the bag and prevents duplicate submission', () {
    final store = AppStore();
    expect(store.placeOrder(), false);
    store.addToCart(products.first, 'M', 1);
    expect(store.placeOrder(), true);
    expect(store.lastOrder, 'XIAO-0001');
    expect(store.bagCount, 0);
    expect(store.placeOrder(), false);
    expect(store.orderCount, 1);
  });
  test(
    'local state survives reloading and contains no password or messages',
    () async {
      final store = AppStore();
      await store.load();
      store.signIn('demo@xiao.io');
      store.setDark(true);
      store.toggle(store.saved, stories.first.title);
      store.toggle(store.following, 'Marian Marshall');
      store.addToCart(products.first, 'L', 2);
      store.updateProfile('Xiao Tester', 'test@xiao.io', 'Designer', '123');
      store.send(contacts.first, 'Private session message');
      await store.persisted;
      final restored = AppStore();
      await restored.load();
      expect(restored.signedIn, true);
      expect(restored.dark, true);
      expect(restored.name, 'Xiao Tester');
      expect(restored.cart.first.size, 'L');
      expect(restored.saved.contains(stories.first.title), true);
      expect(restored.following.contains('Marian Marshall'), true);
      expect(restored.chats, isEmpty);
      final raw = (await SharedPreferences.getInstance()).getString(
        'xiao.state.v1',
      )!;
      expect(raw, isNot(contains('Private session message')));
      expect(raw, isNot(contains('password')));
    },
  );
  test('bad local JSON does not block startup', () async {
    SharedPreferences.setMockInitialValues({'xiao.state.v1': '{broken'});
    final store = AppStore();
    await store.load();
    expect(store.signedIn, false);
    expect(store.cart, isEmpty);
  });
  test('chat rejects blanks and isolates conversations', () {
    final store = AppStore();
    store.send(contacts.first, '  ');
    expect(store.chats, isEmpty);
    store.send(contacts.first, '  Hello  ');
    expect(store.messages(contacts.first).last.text, 'Hello');
    expect(store.messages(contacts.last).last.text, 'Okay !');
  });
}
