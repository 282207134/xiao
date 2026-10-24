import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/app_store.dart';
import 'data/models.dart';
import 'features/auth.dart';
import 'features/content.dart';
import 'features/shop.dart';
import 'features/social_media.dart';
import 'features/profile_dashboard.dart';
import 'ui/components.dart';

class XiaoApp extends StatelessWidget {
  const XiaoApp({
    super.key,
    required this.store,
    this.initialRoute,
    this.navigatorKey,
  });
  final AppStore store;
  final String? initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: 'IBM Plex Sans',
      scaffoldBackgroundColor: dark ? const Color(0xFF17181D) : Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: purple,
        brightness: brightness,
        primary: dark ? const Color(0xFFAF93FF) : purple,
      ),
      textTheme: ThemeData(brightness: brightness).textTheme.apply(
        fontFamily: 'IBM Plex Sans',
        bodyColor: dark ? Colors.white : ink,
        displayColor: dark ? Colors.white : ink,
      ),
      dividerColor: dark ? const Color(0xFF36373D) : const Color(0xFFEFF0F1),
      splashFactory: InkSparkle.splashFactory,
    );
  }

  @override
  Widget build(BuildContext context) => StoreScope(
    store: store,
    child: ListenableBuilder(
      listenable: store,
      builder: (context, _) => MaterialApp(
        title: 'xiao',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        themeMode: store.dark ? ThemeMode.dark : ThemeMode.light,
        initialRoute:
            initialRoute ?? (store.signedIn ? '/feed' : '/walkthrough'),
        onGenerateInitialRoutes: (name) => [_route(RouteSettings(name: name))],
        onGenerateRoute: _route,
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: store.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: child!,
        ),
      ),
    ),
  );
  Route<dynamic> _route(RouteSettings settings) {
    final page = switch (settings.name) {
      '/walkthrough' => const WalkthroughPage(),
      '/welcome' => const WelcomePage(),
      '/login' => const AuthPage(),
      '/signup' => const AuthPage(signup: true),
      '/menu' => const MenuPage(),
      '/feed' => const FeedPage(),
      '/categories' => const CategoriesPage(),
      '/articles' => ArticleListPage(category: settings.arguments as String?),
      '/article' => ArticlePage(
        story: settings.arguments as Story? ?? stories.first,
      ),
      '/saved' => const ArticleListPage(savedOnly: true),
      '/shop' => const ShopPage(),
      '/catalogue' => const CataloguePage(),
      '/product' => ProductPage(
        product: settings.arguments as Product? ?? products.first,
      ),
      '/cart' => const CartPage(),
      '/checkout' => const CheckoutPage(),
      '/success' => const OrderSuccessPage(),
      '/chats' => const ChatsPage(),
      '/conversation' => ConversationPage(
        contact: settings.arguments as String? ?? contacts.first,
      ),
      '/music' => const MusicPage(),
      '/player' => PlayerPage(index: settings.arguments as int? ?? 0),
      '/profile' => const ProfilePage(),
      '/edit-profile' => const EditProfilePage(),
      '/settings' => const SettingsPage(),
      '/balance' => const BalancePage(),
      _ => const FeedPage(),
    };
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
