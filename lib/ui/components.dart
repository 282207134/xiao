import 'package:flutter/material.dart';

const purple = Color(0xFF4109DE);
const placeholder = Color(0xFFD7D8DA);
const muted = Color(0xFFACAFB3);
const ink = Color(0xFF0D0E10);
String money(num value) => '\$${value.toStringAsFixed(value % 1 == 0 ? 0 : 2)}';
void go(BuildContext context, String route, [Object? arguments]) =>
    Navigator.of(context).pushNamed(route, arguments: arguments);
void toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.child,
    this.title,
    this.menu = false,
    this.actions = const [],
    this.bottom,
    this.color,
  });
  final Widget child;
  final String? title;
  final bool menu;
  final List<Widget> actions;
  final Widget? bottom;
  final Color? color;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: color,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              if (title != null)
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: menu ? 'Open navigation' : 'Back',
                        onPressed: () => menu
                            ? go(context, '/menu')
                            : Navigator.of(context).maybePop(),
                        icon: Icon(
                          menu ? Icons.menu_rounded : Icons.chevron_left,
                          color: muted,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ...actions,
                      if (actions.isEmpty) const SizedBox(width: 48),
                    ],
                  ),
                ),
              Expanded(child: child),
              if (bottom != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: bottom,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        if (onPressed != null)
          BoxShadow(
            color: purple.withValues(alpha: .18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
      ],
    ),
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: purple,
        foregroundColor: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 19), const SizedBox(width: 8)],
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    ),
  );
}

class GreyBox extends StatelessWidget {
  const GreyBox({
    super.key,
    this.width,
    this.height,
    this.radius = 8,
    this.child,
    this.onTap,
    this.label,
  });
  final double? width, height;
  final double radius;
  final Widget? child;
  final VoidCallback? onTap;
  final String? label;
  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    image: label != null,
    child: LayoutBuilder(
      builder: (context, constraints) => Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF35363C)
            : placeholder,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width:
                width ??
                (constraints.hasBoundedWidth ? constraints.maxWidth : null),
            height:
                height ??
                (constraints.hasBoundedHeight ? constraints.maxHeight : null),
            child: child,
          ),
        ),
      ),
    ),
  );
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.size = 40, this.onTap, this.initials});
  final double size;
  final VoidCallback? onTap;
  final String? initials;
  @override
  Widget build(BuildContext context) => GreyBox(
    width: size,
    height: size,
    radius: size / 2,
    onTap: onTap,
    label: 'Profile picture',
    child: initials == null
        ? null
        : Center(
            child: Text(initials!, style: const TextStyle(color: Colors.white)),
          ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.onViewAll});
  final String title;
  final VoidCallback? onViewAll;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 24))),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: const Text(
              'View all',
              style: TextStyle(color: muted, fontSize: 13),
            ),
          ),
      ],
    ),
  );
}

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    required this.followed,
    required this.onPressed,
  });
  final bool followed;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(72, 28),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      side: BorderSide(color: followed ? purple : const Color(0xFFE5E6E8)),
      visualDensity: VisualDensity.compact,
    ),
    child: Text(
      followed ? 'Following' : '+ Follow',
      style: const TextStyle(fontSize: 13),
    ),
  );
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    required this.onChanged,
    this.hint = 'Search here…',
  });
  final ValueChanged<String> onChanged;
  final String hint;
  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search, color: muted, size: 21),
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF292A30)
          : const Color(0xFFEFF0F1),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

class LabeledField extends StatelessWidget {
  const LabeledField(
    this.label, {
    super.key,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
    this.maxLines = 1,
  });
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;
  final int maxLines;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 1.3,
            color: muted,
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscure,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ],
    ),
  );
}

String? requiredValue(String? value) =>
    value == null || value.trim().isEmpty ? 'Please complete this field' : null;
String? validEmail(String? value) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '')
    ? null
    : 'Enter a valid email address';

class EmptyState extends StatelessWidget {
  const EmptyState(
    this.title,
    this.subtitle, {
    super.key,
    this.icon = Icons.search_rounded,
    this.action,
  });
  final String title, subtitle;
  final IconData icon;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: placeholder),
          const SizedBox(height: 24),
          Text(title, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: muted),
          ),
          if (action != null) ...[const SizedBox(height: 28), action!],
        ],
      ),
    ),
  );
}
