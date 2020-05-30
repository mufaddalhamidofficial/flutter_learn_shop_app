import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:learn_shop_app_4/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final url =
        'https://flutter-test-prj.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final res = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (res.statusCode >= 400) {
        print(res.body);
        print(res.reasonPhrase);
        isFavorite = oldStatus;
        notifyListeners();
        throw HttpException('Error!!');
      }
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException('Error!!');
    }
  }
}
