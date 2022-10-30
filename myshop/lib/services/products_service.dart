import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/auth_token.dart';

import 'firebase_service.dart';

class ProductsService extends FirebaseService {
  ProductsService([AuthToken? authToken]) : super(authToken);

  Future<List<Product>> fetchProducts([bool filterByUser = false]) async {
    final List<Product> products = [];

    try {
      final filters =
          filterByUser ? 'orderBy = "creatorId"&equalTo="$userId"' : '';
      final productUrl =
          Uri.parse('$databaseUrl/products.json?auth=$token&$filters');
      final respone = await http.get(productUrl);
      final productMap = json.decode(respone.body) as Map<String, dynamic>;
      if (respone.statusCode != 200) {
        print(productMap['error']);
        return products;
      }

      final userfavoritesUrl =
          Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userfavoriteRespone = await http.get(userfavoritesUrl);
      final userFavoritesMap = json.decode(userfavoriteRespone.body);
      
      productMap.forEach((productId, product) {
        final isFavorite = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[productId] ?? false);
        products.add(
          Product.fromJson({
            'id': productId,
            ...product,
          }).copyWith(isFavorite: isFavorite),
        );
      });
      return products;
    } catch (error) {
      print(error);
      return products;
    }
  }

  Future<Product?> addProduct(Product product) async {
    try {
      final url = Uri.parse('$databaseUrl/products.json?auth=$token');
      final respone = await http.post(
        url,
        body: json.encode(
          product.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );
      if (respone.statusCode != 200) {
        throw Exception(json.decode(respone.body)['error']);
      }
      return product.copyWith(
        id: json.decode(respone.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  } Future<bool> updateProduct(Product product) async {
    try {
      final url = Uri.parse('$databaseUrl/{products.id}.json?auth=$token');
      final respone = await http.patch(
        url,
        body: json.encode(product.toJson()),
      );
      if (respone.statusCode != 200) {
        throw Exception(json.decode(respone.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/products/$id.json?auth=$token');
      final respone = await http.delete(url);
      if (respone.statusCode != 200) {
        throw Exception(json.decode(respone.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
  
 Future<bool> saveFavoriteStatus(Product product) async {
    try {
      final url = Uri.parse(
          '$databaseUrl/userFavorites/$userId/${product.id}.json?auth=$token');
      final respone = await http.put(
        url,
        body: json.encode(
          product.isFavorite,
        ),
      );
      if (respone.statusCode != 200) {
        throw Exception(json.decode(respone.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

}
