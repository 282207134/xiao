import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../data/models.dart';
import '../ui/components.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8E10E8), purple],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 28,
                ),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            'x',
                            style: TextStyle(
                              fontSize: 38,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Close navigation',
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  for (final (label, route, icon) in [
                    ('Home', '/feed', Icons.home_outlined),
                    ('Dashboard', '/balance', Icons.insights_outlined),
                    ('Profile', '/profile', Icons.person_outline),
                    ('Articles', '/categories', Icons.article_outlined),
                    ('Shop', '/shop', Icons.shopping_bag_outlined),
                    ('Chat', '/chats', Icons.chat_bubble_outline),
                    ('Music', '/music', Icons.music_note_outlined),
                    ('Saved articles', '/saved', Icons.bookmark_border),
                    ('Settings', '/settings', Icons.settings_outlined),
                  ])
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(icon, color: Colors.white70, size: 22),
                      title: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () =>
                          Navigator.of(context).pushReplacementNamed(route),
                    ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: () {
                      store.signOut();
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/welcome', (_) => false);
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Sign out'),
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  void photos(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Photos', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(
                  12,
                  (i) => GreyBox(label: 'Photo ${i + 1}'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return PageFrame(
      title: 'Profile',
      actions: [
        IconButton(
          tooltip: 'Settings',
          onPressed: () => go(context, '/settings'),
          icon: const Icon(Icons.settings_outlined, color: muted),
        ),
      ],
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                const Avatar(size: 100),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name, style: const TextStyle(fontSize: 22)),
                      Text(
                        store.bio,
                        style: const TextStyle(fontSize: 13, color: muted),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => go(context, '/edit-profile'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(80, 30),
                          visualDensity: VisualDensity.compact,
                          side: const BorderSide(color: purple),
                        ),
                        child: const Text(
                          'Edit profile',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 32, top: 8),
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final (number, label) in [
                  ('594', 'photos'),
                  ('108', 'articles'),
                  ('22k', 'followers'),
                ])
                  Column(
                    children: [
                      Text(
                        number,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA68AF2),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SectionHeading(
                    'Friends',
                    onViewAll: () => go(context, '/chats'),
                  ),
                ),
                SizedBox(
                  height: 98,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (context, index) => Column(
                      children: [
                        Avatar(
                          size: 60,
                          onTap: () =>
                              go(context, '/conversation', contacts[index]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          [
                            'Nancy',
                            'Daniel',
                            'Olive',
                            'Deans',
                            'Natasha',
                            'Mack',
                          ][index],
                          style: const TextStyle(color: muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SectionHeading(
                    'Photos',
                    onViewAll: () => photos(context),
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, index) => GreyBox(
                      width: 90,
                      label: 'Photo ${index + 1}',
                      onTap: () => photos(context),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SectionHeading(
                    'Articles',
                    onViewAll: () => go(context, '/articles'),
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: stories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, index) => GreyBox(
                      width: 295,
                      onTap: () => go(context, '/article', stories[index]),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            stories[index].title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      bio = TextEditingController(),
      phone = TextEditingController();
  bool loaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!loaded) {
      final store = StoreScope.of(context);
      name.text = store.name;
      email.text = store.email;
      bio.text = store.bio;
      phone.text = store.phone;
      loaded = true;
    }
  }

  @override
  void dispose() {
    for (final c in [name, email, bio, phone]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Edit Profile',
    actions: [
      TextButton(
        onPressed: () {
          if (!form.currentState!.validate()) return;
          StoreScope.of(context).updateProfile(
            name.text.trim(),
            email.text.trim(),
            bio.text.trim(),
            phone.text.trim(),
          );
          Navigator.pop(context);
          toast(context, 'Profile saved');
        },
        child: const Text('Save'),
      ),
    ],
    child: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Align(alignment: Alignment.centerLeft, child: Avatar(size: 64)),
          const SizedBox(height: 20),
          LabeledField('Name', controller: name, validator: requiredValue),
          LabeledField('About me', controller: bio, maxLines: 2),
          LabeledField(
            'E-mail',
            controller: email,
            validator: validEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          LabeledField(
            'Phone number',
            controller: phone,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    ),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return PageFrame(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Make it yours', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 32),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Dark appearance'),
            subtitle: const Text('Inspired by the Pixso dark variants'),
            value: store.dark,
            onChanged: store.setDark,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.person_outline),
            title: const Text('Edit profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => go(context, '/edit-profile'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Saved articles'),
            trailing: Text(
              '${stories.where((s) => store.saved.contains(s.title)).length}',
            ),
            onTap: () => go(context, '/saved'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Shopping bag'),
            trailing: Text('${store.bagCount}'),
            onTap: () => go(context, '/cart'),
          ),
          const SizedBox(height: 24),
          const Text(
            'ABOUT XIAO',
            style: TextStyle(color: muted, fontSize: 11, letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          const Text(
            'A little space for your everyday.\nDesigned from the xiao Pixso UI kit.\nVersion 1.0.0',
            style: TextStyle(height: 1.7),
          ),
          const SizedBox(height: 24),
          const Text(
            'This app uses local demo data. Chat messages stay in the current session. Shopping uses a demo payment method. Music controls preview playback without an audio source.',
            style: TextStyle(color: muted, height: 1.6, fontSize: 13),
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
            onPressed: () {
              store.signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/welcome', (_) => false);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});
  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  int period = 0;
  bool today = true;
  static const transactions = [
    ('Ebay Shopping', '25721', -798),
    ('Amazon Refund', '92765', 164),
    ('Apple Macbook Pro', '82154', -2261),
    ('Salary Paid Out', '27626', 5390),
    ('Coffee & Studio', '27631', -24),
  ];
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Account Balance',
    menu: true,
    child: ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final (index, label) in [
              'Daily',
              'Weekly',
              'Monthly',
              'Yearly',
            ].indexed)
              TextButton(
                onPressed: () => setState(() => period = index),
                child: Text(
                  label,
                  style: TextStyle(
                    color: index == period
                        ? Theme.of(context).colorScheme.onSurface
                        : muted,
                    fontWeight: index == period
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 260,
          child: Semantics(
            label: 'Balance ${money([2395, 7280, 18950, 94820][period])}',
            child: CustomPaint(
              painter: _BalancePainter(
                period,
                Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Transactions',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              DropdownButton<bool>(
                value: today,
                underline: const SizedBox(),
                style: const TextStyle(color: muted, fontSize: 13),
                items: const [
                  DropdownMenuItem(value: true, child: Text('Today')),
                  DropdownMenuItem(value: false, child: Text('All')),
                ],
                onChanged: (value) => setState(() => today = value ?? true),
              ),
            ],
          ),
        ),
        for (final (title, id, amount) in transactions.take(today ? 4 : 5))
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .07),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(
                amount < 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: amount < 0
                    ? const Color(0xFFFF2456)
                    : const Color(0xFF7BD510),
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'ID #$id',
                style: const TextStyle(color: muted, fontSize: 13),
              ),
              trailing: Text(
                '${amount < 0 ? '−' : '+'} ${money(amount.abs())}',
                style: TextStyle(
                  fontSize: 13,
                  color: amount < 0
                      ? const Color(0xFFFF2456)
                      : const Color(0xFF7BD510),
                ),
              ),
            ),
          ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Demo account · sample transactions',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}

class _BalancePainter extends CustomPainter {
  _BalancePainter(this.period, this.textColor);
  final int period;
  final Color textColor;
  void label(
    Canvas canvas,
    String text,
    Offset offset, {
    Color color = muted,
    double size = 11,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'IBM Plex Sans',
          fontSize: size,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset - Offset(painter.width / 2, 0));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final points = [
      for (var i = 0; i < 7; i++)
        Offset(
          w * i / 6,
          h * ([.43, .40, .56, .22, .42, .35, .61][(i + period) % 7]),
        ),
    ];
    final line = Paint()
      ..color = purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final grid = Paint()
      ..color = placeholder
      ..strokeWidth = 1;
    for (var i = 0; i < points.length; i++) {
      final x = points[i].dx;
      for (double y = points[i].dy + 12; y < h - 32; y += 12) {
        canvas.drawLine(Offset(x, y), Offset(x, y + 6), grid);
      }
      label(
        canvas,
        period == 0 ? '${18 + i}' : ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
        Offset(x.clamp(20, w - 20), h - 20),
      );
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1], b = points[i], middle = (a.dx + b.dx) / 2;
      path.cubicTo(middle, a.dy, middle, b.dy, b.dx, b.dy);
    }
    canvas.drawPath(path, line);
    final peak = points[3];
    canvas.drawCircle(peak, 6, Paint()..color = Colors.white);
    canvas.drawCircle(peak, 4, Paint()..color = purple);
    final rect = Rect.fromCenter(
      center: peak - const Offset(0, 36),
      width: 76,
      height: 28,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()..color = ink,
    );
    label(
      canvas,
      money([2395, 7280, 18950, 94820][period]),
      Offset(peak.dx, rect.top + 5),
      color: Colors.white,
      size: 13,
    );
  }

  @override
  bool shouldRepaint(_BalancePainter oldDelegate) =>
      oldDelegate.period != period || oldDelegate.textColor != textColor;
}
