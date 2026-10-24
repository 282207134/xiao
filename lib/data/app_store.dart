import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

/// Local demo state. No passwords, card details, or chat text are persisted.
class AppStore extends ChangeNotifier {
  SharedPreferences? _preferences;
  bool dark = false, signedIn = false;
  String name = 'Jack Hawkins', email = 'jack@xiao.io';
  String bio = 'Creative Director at xiao.io', phone = '439-322-3885';
  final Set<String> saved = {}, following = {}, liked = {};
  final List<CartLine> cart = [];
  final Map<String, List<ChatMessage>> chats = {};
  int orderCount = 0;
  String lastOrder = '';
  Future<void> _writes = Future.value();

  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();
    final raw = _preferences!.getString('xiao.state.v1');
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      dark = data['dark'] == true;
      signedIn = data['signedIn'] == true;
      name = data['name'] as String? ?? name;
      email = data['email'] as String? ?? email;
      bio = data['bio'] as String? ?? bio;
      phone = data['phone'] as String? ?? phone;
      saved.addAll(List<String>.from(data['saved'] ?? []));
      following.addAll(List<String>.from(data['following'] ?? []));
      liked.addAll(List<String>.from(data['liked'] ?? []));
      orderCount = data['orderCount'] as int? ?? 0;
      for (final line in data['cart'] as List? ?? []) {
        final item = products.where((p) => p.id == line['product']).firstOrNull;
        final quantity = line['quantity'] as int? ?? 1;
        if (item != null && quantity > 0) {
          cart.add(
            CartLine(
              item,
              line['size'] as String,
              line['color'] as int,
              quantity: quantity.clamp(1, 99),
            ),
          );
        }
      }
    } on FormatException {
      await _preferences!.remove('xiao.state.v1');
    } on TypeError {
      await _preferences!.remove('xiao.state.v1');
    }
  }

  int get bagCount => cart.fold(0, (n, line) => n + line.quantity);
  double get subtotal => cart.fold(0, (n, line) => n + line.total);
  double get shipping => cart.isEmpty || subtotal >= 100 ? 0 : 4.85;
  double get total => subtotal + shipping;
  Future<void> get persisted => _writes;
  void _changed() {
    notifyListeners();
    final snapshot = jsonEncode({
      'dark': dark,
      'signedIn': signedIn,
      'name': name,
      'email': email,
      'bio': bio,
      'phone': phone,
      'saved': saved.toList(),
      'following': following.toList(),
      'liked': liked.toList(),
      'cart': cart.map((line) => line.toJson()).toList(),
      'orderCount': orderCount,
    });
    _writes = _writes.then((_) async {
      await _preferences?.setString('xiao.state.v1', snapshot);
    });
  }

  void signIn(String value) {
    signedIn = true;
    email = value;
    _changed();
  }

  void signOut() {
    signedIn = false;
    _changed();
  }

  void setDark(bool value) {
    dark = value;
    _changed();
  }

  void updateProfile(
    String newName,
    String newEmail,
    String newBio,
    String newPhone,
  ) {
    name = newName;
    email = newEmail;
    bio = newBio;
    phone = newPhone;
    _changed();
  }

  void toggle(Set<String> values, String id) {
    if (!values.remove(id)) values.add(id);
    _changed();
  }

  void addToCart(Product product, String size, int color) {
    final key = '${product.id}:$size:$color';
    final existing = cart.where((line) => line.key == key).firstOrNull;
    if (existing == null) {
      cart.add(CartLine(product, size, color));
    } else if (existing.quantity < 99) {
      existing.quantity++;
    }
    _changed();
  }

  void changeQuantity(CartLine line, int delta) {
    line.quantity += delta;
    if (line.quantity <= 0) cart.remove(line);
    if (line.quantity > 99) line.quantity = 99;
    _changed();
  }

  bool placeOrder() {
    if (cart.isEmpty) return false;
    orderCount++;
    lastOrder = 'XIAO-${orderCount.toString().padLeft(4, '0')}';
    cart.clear();
    _changed();
    return true;
  }

  List<ChatMessage> messages(String contact) => chats.putIfAbsent(
    contact,
    () => [
      const ChatMessage('Guys, let’s go dinner today!'),
      const ChatMessage('Totally agree !!!', mine: true),
      const ChatMessage(
        'Enjoy your holiday and call me back when you get home',
      ),
      const ChatMessage('Call me when you get there', mine: true),
      const ChatMessage('Okay !'),
    ],
  );
  void send(String contact, String text) {
    if (text.trim().isEmpty) return;
    messages(contact).add(ChatMessage(text.trim(), mine: true));
    notifyListeners();
  }
}

class StoreScope extends InheritedNotifier<AppStore> {
  const StoreScope({super.key, required AppStore store, required super.child})
    : super(notifier: store);
  static AppStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoreScope>()!.notifier!;
}
