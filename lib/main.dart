import 'package:flutter/material.dart';
import 'package:learn_shop_app_4/providers/auth.dart';
import 'package:learn_shop_app_4/providers/cart.dart';
import 'package:learn_shop_app_4/providers/orders.dart';
import 'package:learn_shop_app_4/screens/auth_screen.dart';
import 'package:learn_shop_app_4/screens/cart_screen.dart';
import 'package:learn_shop_app_4/screens/edit_product_screen.dart';
import 'package:learn_shop_app_4/screens/orders_screen.dart';
import 'package:learn_shop_app_4/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // builder: (ctx) => Products(),
      // value: Products(),
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, prevProds) => Products(
            auth.token,
            auth.userId,
            prevProds == null ? [] : prevProds.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, prevOrds) => Orders(
            auth.token,
            auth.userId,
            prevOrds == null ? [] : prevOrds.orders,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple, accentColor: Colors.deepOrange),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Scaffold(
                              body: Center(
                                child: Text('Loading...'),
                              ),
                            )
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrdersScreen.routeName: (_) => OrdersScreen(),
            UserProductsScreen.routeName: (_) => UserProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
