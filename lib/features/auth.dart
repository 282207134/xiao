import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../ui/components.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});
  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  int index = 0;
  final controller = PageController();
  static const titles = [
    'Keep your teeth\nwhite and clean',
    'Find your next\nlittle inspiration',
    'Make room for\nsomething new',
    'Your everyday,\nall together',
  ];
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    bottom: PrimaryButton(
      index == 3 ? 'Explore xiao' : 'Get started',
      onPressed: () => go(context, '/welcome'),
    ),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => go(context, '/welcome'),
            child: const Text('Skip', style: TextStyle(color: muted)),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: controller,
            itemCount: 4,
            onPageChanged: (value) => setState(() => index = value),
            itemBuilder: (context, page) => SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  AspectRatio(
                    aspectRatio: 1,
                    child: GreyBox(
                      radius: 16,
                      label: 'Lifestyle illustration ${page + 1}',
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'LIFESTYLE',
                    style: TextStyle(
                      fontSize: 11,
                      color: muted,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    titles[page],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You will undoubtedly have dreams.\nWhether you dream of having the perfect\nhouse with the perfect car',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (page) => Semantics(
                label: 'Page ${page + 1}',
                child: InkResponse(
                  onTap: () => controller.animateToPage(
                    page,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: page == index ? purple : placeholder,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    color: placeholder,
    bottom: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton('Sign Up', onPressed: () => go(context, '/signup')),
        const SizedBox(height: 14),
        TextButton(
          onPressed: () => go(context, '/login'),
          child: const Text(
            'Already have account?',
            style: TextStyle(color: Color(0xFF8E9195)),
          ),
        ),
      ],
    ),
    child: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const _XiaoLogo(),
            const SizedBox(height: 28),
            const Text(
              'Welcome to\nxiao ui kit',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 42, height: 1.15, color: ink),
            ),
          ],
        ),
      ),
    ),
  );
}

class _XiaoLogo extends StatelessWidget {
  const _XiaoLogo();
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 80,
    height: 80,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ink, width: 2.5),
          ),
          child: const Center(
            child: Text(
              'x',
              style: TextStyle(
                fontSize: 48,
                height: 1,
                fontWeight: FontWeight.bold,
                color: ink,
              ),
            ),
          ),
        ),
        Positioned(
          right: 6,
          top: 4,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: const Color(0xFFFF2456),
              shape: BoxShape.circle,
              border: Border.all(color: placeholder, width: 2),
            ),
          ),
        ),
      ],
    ),
  );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.signup = false});
  final bool signup;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController();
  bool hidden = true;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    final store = StoreScope.of(context);
    if (widget.signup) {
      store.updateProfile(
        name.text.trim(),
        email.text.trim(),
        store.bio,
        store.phone,
      );
    }
    store.signIn(email.text.trim());
    Navigator.of(context).pushNamedAndRemoveUntil('/feed', (_) => false);
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    child: Form(
      key: form,
      child: ListView(
        children: [
          Container(
            height: 180,
            color: placeholder,
            child: const Center(
              child: Text('xiao', style: TextStyle(fontSize: 36, color: ink)),
            ),
          ),
          Row(
            children: [
              for (final signup in [true, false])
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(22),
                    ),
                    onPressed: () => Navigator.of(
                      context,
                    ).pushReplacementNamed(signup ? '/signup' : '/login'),
                    child: Text(
                      signup ? 'SIGNUP' : 'LOGIN',
                      style: TextStyle(
                        letterSpacing: 1.4,
                        fontSize: 11,
                        color: widget.signup == signup ? purple : muted,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 34, 32, 24),
            child: Column(
              children: [
                if (widget.signup)
                  LabeledField(
                    'Full name',
                    controller: name,
                    validator: requiredValue,
                  ),
                LabeledField(
                  'Email',
                  controller: email,
                  validator: validEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                LabeledField(
                  'Password',
                  controller: password,
                  obscure: hidden,
                  validator: (value) => (value?.length ?? 0) >= 6
                      ? null
                      : 'Use at least 6 characters',
                  suffix: IconButton(
                    tooltip: hidden ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => hidden = !hidden),
                    icon: Icon(
                      hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: muted,
                    ),
                  ),
                ),
                if (!widget.signup)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Demo account'),
                          content: const Text(
                            'Use any valid email and a password of 6 or more characters. No server account is created.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Got it'),
                            ),
                          ],
                        ),
                      ),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: muted, fontSize: 13),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                PrimaryButton(
                  widget.signup ? 'Create account' : 'Login',
                  onPressed: submit,
                ),
                const SizedBox(height: 28),
                const Text(
                  'LOCAL DEMO',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: muted,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try any email and a 6-character password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: muted),
                ),
                TextButton(
                  onPressed: () {
                    StoreScope.of(context).signIn('guest@xiao.io');
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/feed', (_) => false);
                  },
                  child: const Text('Explore as guest'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
