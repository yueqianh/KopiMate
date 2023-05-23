class Shop {
  String imageUrl;
  String name;
  String type;

  Shop({
    this.imageUrl = '',
    this.name = '',
    this.type = '',
  });
}

final List<Shop> shops = [
  Shop(
    imageUrl: '1',
    name: 'Shop 0',
    type: '1',
  ),
  Shop(
    imageUrl: '2',
    name: 'Hotel 1',
    type: '2',
  ),
  Shop(
    imageUrl: '3',
    name: 'Hotel 2',
    type: '3',
  ),
];
