class Product {
  const Product(this.id, this.name, this.price, this.category);
  final String id, name, category;
  final double price;
}

class CartLine {
  CartLine(this.product, this.size, this.color, {this.quantity = 1});
  final Product product;
  final String size;
  final int color;
  int quantity;
  String get key => '${product.id}:$size:$color';
  double get total => product.price * quantity;
  Map<String, dynamic> toJson() => {
    'product': product.id,
    'size': size,
    'color': color,
    'quantity': quantity,
  };
}

class ChatMessage {
  const ChatMessage(this.text, {this.mine = false});
  final String text;
  final bool mine;
}

class Story {
  const Story(this.title, this.author, this.category, this.excerpt);
  final String title, author, category, excerpt;
}

const products = [
  Product('shirt', 'Closed Voile Shirt', 34.99, 'Tops'),
  Product('sweater', 'Nosti Sweater', 420, 'Tops'),
  Product('trousers', 'Harvey Trousers', 166, 'Bottoms'),
  Product('shoes', 'Adidas Running Shoes', 294, 'Shoes'),
  Product('dress', 'Linen Summer Dress', 89, 'Dresses'),
  Product('jacket', 'Everyday Jacket', 125, 'Outerwears'),
];
const stories = [
  Story(
    'Harness The Power Of Your Dreams',
    'James Mack',
    'Technology',
    'Every good idea begins with a little curiosity. Make room for the things that inspire you.',
  ),
  Story(
    'San Diego Vacation Rental',
    'Birdie Bennett',
    'Travelling & Journal',
    'You love having a second home but the mortgage is putting a crater in your plans.',
  ),
  Story(
    'The Art Of Everyday Living',
    'Lou Martin',
    'Fashion & Beauty',
    'Small rituals can change the way we see the world. Begin with something simple, and make it your own.',
  ),
  Story(
    'People Who Inspire Us',
    'Emily Morton',
    'People',
    'The most interesting stories are often the ones waiting just around the corner.',
  ),
];
const contacts = [
  'Warren Cook',
  'Kevin Watkins',
  'Mason McBride',
  'Garrett Park',
  'Christine Elliott',
  'Beulah Malone',
];
const songs = ['Shape Of You', 'Mentions', 'A Little More', 'Stay With Me'];
