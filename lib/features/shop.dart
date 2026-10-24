import 'package:flutter/material.dart';
import '../data/app_store.dart';
import '../data/models.dart';
import '../ui/components.dart';

Widget bagAction(BuildContext context) {
  final store = StoreScope.of(context);
  return IconButton(
    tooltip: 'Shopping bag',
    onPressed: () => go(context, '/cart'),
    icon: Badge(
      isLabelVisible: store.bagCount > 0,
      label: Text('${store.bagCount}'),
      child: const Icon(Icons.shopping_bag_outlined, color: muted),
    ),
  );
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'xiao',
    menu: true,
    actions: [
      IconButton(
        tooltip: 'Browse products',
        onPressed: () => go(context, '/catalogue'),
        icon: const Icon(Icons.search, color: muted),
      ),
      bagAction(context),
    ],
    child: ListView(
      children: [
        GreyBox(
          height: 300,
          radius: 0,
          onTap: () => go(context, '/catalogue'),
          label: 'Sale campaign',
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'UP TO\n70% OFF',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  height: 1.15,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 62),
              Text(
                'FREE SHIPPING ON ORDER OVER \$100',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '● ○ ○ ○',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: purple),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              for (final title in ['SHOP MAN', 'SHOP WOMAN', 'SHOP KIDS']) ...[
                GreyBox(
                  height: 120,
                  onTap: () => go(context, '/catalogue'),
                  label: title,
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              SectionHeading(
                'Best sellers',
                onViewAll: () => go(context, '/catalogue'),
              ),
              SizedBox(
                height: 235,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => SizedBox(
                    width: 150,
                    child: ProductTile(product: products[index]),
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

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => go(context, '/product', product),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GreyBox(width: double.infinity, label: product.name),
        ),
        const SizedBox(height: 12),
        Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        Text(
          money(product.price),
          style: const TextStyle(color: purple, fontSize: 14),
        ),
      ],
    ),
  );
}

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});
  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  String query = '', category = 'All';
  bool affordable = false;
  @override
  Widget build(BuildContext context) {
    final filtered = products
        .where(
          (p) =>
              (category == 'All' || category == p.category) &&
              p.name.toLowerCase().contains(query.toLowerCase()) &&
              (!affordable || p.price <= 100),
        )
        .toList();
    return PageFrame(
      title: 'Collection',
      actions: [bagAction(context)],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: SearchBox(
              hint: 'Search products…',
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final label in [
                  'All',
                  'Tops',
                  'Bottoms',
                  'Shoes',
                  'Dresses',
                  'Outerwears',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: category == label,
                      onSelected: (_) => setState(() => category = label),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${filtered.length} items',
                    style: const TextStyle(color: muted, fontSize: 13),
                  ),
                ),
                FilterChip(
                  label: const Text('Under \$100'),
                  selected: affordable,
                  onSelected: (value) => setState(() => affordable = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    'No products found',
                    'Try another category or remove the price filter.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .64,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 24,
                        ),
                    itemBuilder: (context, index) =>
                        ProductTile(product: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product});
  final Product product;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String size = 'M';
  int color = 0;
  static const colors = [
    Color(0xFFFFB800),
    placeholder,
    Color(0xFF39475A),
    Color(0xFFB88F75),
  ];
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context), product = widget.product;
    return PageFrame(
      title: product.name,
      actions: [bagAction(context)],
      bottom: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              'Add to Bag',
              onPressed: () {
                store.addToCart(product, size, color);
                go(context, '/cart');
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            tooltip: 'Save product',
            onPressed: () => store.toggle(store.saved, product.id),
            icon: Icon(
              store.saved.contains(product.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: store.saved.contains(product.id) ? purple : muted,
            ),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          GreyBox(
            height: 400,
            label: product.name,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  money(product.price),
                  style: const TextStyle(color: ink),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              const SizedBox(
                width: 90,
                child: Text(
                  'Color',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
              ),
              for (final (index, swatch) in colors.indexed)
                Semantics(
                  label: 'Color ${index + 1}',
                  selected: color == index,
                  child: InkResponse(
                    onTap: () => setState(() => color = index),
                    child: Container(
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: swatch,
                        shape: BoxShape.circle,
                      ),
                      child: color == index
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const SizedBox(
                width: 90,
                child: Text(
                  'Size',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
              ),
              Expanded(
                child: Wrap(
                  spacing: 2,
                  children: [
                    for (final label in ['XS', 'S', 'M', 'L', 'XL'])
                      ChoiceChip(
                        label: Text(
                          label,
                          style: const TextStyle(fontSize: 13),
                        ),
                        selected: size == label,
                        showCheckmark: false,
                        onSelected: (_) => setState(() => size = label),
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Made for every day. A comfortable fit with carefully considered details.',
            style: TextStyle(color: muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return PageFrame(
      title: 'My bag  ${store.bagCount}',
      bottom: store.cart.isEmpty
          ? null
          : PrimaryButton(
              'Checkout',
              onPressed: () => go(context, '/checkout'),
            ),
      child: store.cart.isEmpty
          ? EmptyState(
              'Your bag is empty',
              'Find something you will love.',
              icon: Icons.shopping_bag_outlined,
              action: PrimaryButton(
                'Explore collection',
                onPressed: () => go(context, '/catalogue'),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                for (final line in store.cart)
                  Dismissible(
                    key: ValueKey(line.key),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) =>
                        store.changeQuantity(line, -line.quantity),
                    background: Container(
                      color: const Color(0xFFFF2456),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        children: [
                          GreyBox(
                            width: 48,
                            height: 48,
                            radius: 4,
                            label: line.product.name,
                            onTap: () => go(context, '/product', line.product),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(line.product.name),
                                Text(
                                  '${line.size} · Color ${line.color + 1}',
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  money(line.total),
                                  style: const TextStyle(
                                    color: purple,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Decrease quantity',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => store.changeQuantity(line, -1),
                            icon: const Icon(Icons.remove, size: 18),
                          ),
                          Text('${line.quantity}'),
                          IconButton(
                            tooltip: 'Increase quantity',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => store.changeQuantity(line, 1),
                            icon: const Icon(Icons.add, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 28),
                OrderTotals(store: store),
                const SizedBox(height: 20),
                const Text(
                  'Swipe an item left to remove it.',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
    );
  }
}

class OrderTotals extends StatelessWidget {
  const OrderTotals({super.key, required this.store});
  final AppStore store;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final (label, value) in [
        ('Subtotal', money(store.subtotal)),
        ('Shipping', store.shipping == 0 ? 'Free' : money(store.shipping)),
        ('Total', money(store.total)),
      ])
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(child: Text(label)),
              Text(
                value,
                style: TextStyle(
                  fontSize: label == 'Total' ? 24 : 18,
                  color: label == 'Total' ? purple : null,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int step = 0;
  final form = GlobalKey<FormState>();
  final name = TextEditingController(text: 'Emilie Gonzales');
  final address = TextEditingController(text: '952 Vladimir Ranch');
  final city = TextEditingController(text: 'Pollichborough');
  final zip = TextEditingController(text: '02972');
  final country = TextEditingController(text: 'Portugal');
  @override
  void dispose() {
    for (final c in [name, address, city, zip, country]) {
      c.dispose();
    }
    super.dispose();
  }

  void next() {
    if (step == 0 && !form.currentState!.validate()) return;
    if (step < 2) {
      setState(() => step++);
      return;
    }
    if (StoreScope.of(context).placeOrder()) {
      Navigator.of(context).pushReplacementNamed('/success');
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return PageFrame(
      title: 'Checkout',
      bottom: PrimaryButton(
        step == 2 ? 'Place demo order' : 'Next',
        onPressed: store.cart.isEmpty ? null : next,
      ),
      child: store.cart.isEmpty
          ? const EmptyState(
              'Your bag is empty',
              'Add a product before checking out.',
            )
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (final (index, icon) in [
                      Icons.local_shipping_outlined,
                      Icons.credit_card,
                      Icons.check_circle_outline,
                    ].indexed)
                      IconButton(
                        tooltip: ['Shipping', 'Payment', 'Review'][index],
                        onPressed: index < step
                            ? () => setState(() => step = index)
                            : null,
                        icon: Icon(
                          icon,
                          color: index <= step ? purple : placeholder,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'STEP ${step + 1}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: muted,
                    letterSpacing: 1.3,
                  ),
                ),
                Text(
                  ['Shipping', 'Payment', 'Review order'][step],
                  style: const TextStyle(fontSize: 42),
                ),
                const SizedBox(height: 36),
                if (step == 0)
                  Form(
                    key: form,
                    child: Column(
                      children: [
                        LabeledField(
                          'Full name',
                          controller: name,
                          validator: requiredValue,
                        ),
                        LabeledField(
                          'Address',
                          controller: address,
                          validator: requiredValue,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: LabeledField(
                                'City',
                                controller: city,
                                validator: requiredValue,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: LabeledField(
                                'Zip code',
                                controller: zip,
                                validator: requiredValue,
                              ),
                            ),
                          ],
                        ),
                        LabeledField(
                          'Country',
                          controller: country,
                          validator: requiredValue,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'SHIPPING METHOD',
                            style: TextStyle(
                              color: muted,
                              fontSize: 11,
                              letterSpacing: 1.3,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Standard Shipping (${store.shipping == 0 ? 'Free' : '+ ${money(store.shipping)}'})',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (step == 1) ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: purple,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.credit_card, color: Colors.white),
                        SizedBox(height: 36),
                        Text(
                          'DEMO VISA',
                          style: TextStyle(
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '••••  ••••  ••••  4242',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'This checkout uses a demo payment method. No payment is collected.',
                    style: TextStyle(color: muted, height: 1.6),
                  ),
                ],
                if (step == 2) ...[
                  Text(name.text, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text(
                    '${address.text}\n${city.text}, ${zip.text}\n${country.text}',
                    style: const TextStyle(color: muted, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  for (final line in store.cart)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(line.product.name),
                      subtitle: Text('${line.size} · Qty ${line.quantity}'),
                      trailing: Text(money(line.total)),
                    ),
                  const Divider(),
                  OrderTotals(store: store),
                ],
              ],
            ),
    );
  }
}

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Checkout',
    bottom: PrimaryButton(
      'Continue shopping',
      onPressed: () => Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/shop', (route) => route.isFirst),
    ),
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline, color: purple, size: 100),
            const SizedBox(height: 24),
            const Text('Congrats!', style: TextStyle(fontSize: 42)),
            const SizedBox(height: 20),
            const Text(
              'Thank you for purchasing. Your order will\nbe shipped in 2–4 international days.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: muted),
            ),
            const SizedBox(height: 20),
            Text(
              StoreScope.of(context).lastOrder,
              style: const TextStyle(color: purple),
            ),
            const SizedBox(height: 8),
            const Text(
              'Demo order · no payment collected',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}
