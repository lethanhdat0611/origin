import 'package:flutter/material.dart';
import 'package:myshop/ui/cart/cart_screen.dart';

import 'products_grid.dart';
import '../shared/app_drawer.dart';

enum FilterOptions {favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen ({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> { var _showOnlyFavorites = false;

@override
Widget build(BuildContext context) { 
  return Scaffold(
    appBar: AppBar(
      title: const Text('MyShop'),
      actions: <Widget>[
        buildProductFilterMenu(),
        buildShoppingCartIcon(),
      ],
    ),
    drawer: const AppDrawer(),
    body: ProductsGrid(_showOnlyFavorites),
  );
}
Widget buildShoppingCartIcon() { 
  return IconButton( 
    icon: const Icon(
      Icons.shopping_cart,
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(CartScreen.routeName);
      },
  
  );
}
      Widget buildProductFilterMenu() {
      return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
      setState(() {
      if (selectedValue == FilterOptions.favorites) {
      _showOnlyFavorites = true;
      } else {
      _showOnlyFavorites = false;
      }
    });
  },
    icon: const Icon(
      Icons.more_vert,
    ),
      itemBuilder: (ctx) => [
      const PopupMenuItem( 
        value: FilterOptions.favorites, 
        child: Text('Only Favorites'),
      ),
      const PopupMenuItem(
        value: FilterOptions.all,
        child: Text('Show ALL'),
      ),
    ],
  );
}
} 