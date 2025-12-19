import 'package:dio/dio.dart';
import 'dart:convert';

const String baseUrl = "http://92.249.61.58:8080/";

// ===================== MODELLER =====================

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json["id"].toString()),
      name: json["name"] ?? "",
    );
  }
}

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImage = json["image_url"]?.toString() ?? "";

    final imageUrl = rawImage.isEmpty
        ? ""
        : rawImage.startsWith("http")
            ? rawImage
            : "http://92.249.61.58$rawImage";

    return Product(
      id: int.parse(json["id"].toString()),
      name: json["name"]?.toString() ?? "Ürün",
      imageUrl: imageUrl,
      price: json["price"]?.toString() ?? "0",
      description: json["description"]?.toString() ?? "",
    );
  }
}

class SearchResponse {
  final List<Category> categories;
  final List<Product> products;

  SearchResponse({
    required this.categories,
    required this.products,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      categories: (json["categories"] as List? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
      products: (json["products"] as List? ?? [])
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}

// ===================== AUTH MODELLER =====================

class LoginResponse {
  final bool success;
  final String token;
  final Map<String, dynamic> user;

  LoginResponse({
    required this.success,
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"] == true,
      token: json["token"]?.toString() ?? "",
      user: json["user"] ?? {},
    );
  }
}

class RegisterResponse {
  final bool success;
  final String message;
  final String token;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json["success"] == true,
      message: json["message"]?.toString() ?? "",
      token: json["token"]?.toString() ?? "",
    );
  }
}

// ===================== API SERVICE =====================

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );
  }

  // -------- LOGIN --------
  Future<LoginResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        "/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      print("LOGIN RAW => ${res.data}");
      print("LOGIN TYPE => ${res.data.runtimeType}");

      final Map<String, dynamic> data =
          res.data is String
              ? Map<String, dynamic>.from(jsonDecode(res.data))
              : Map<String, dynamic>.from(res.data);

      return LoginResponse.fromJson(data);
    } catch (e, s) {
      print("LOGIN ERROR => $e");
      print(s);
      return null;
    }
  }

  // -------- REGISTER --------
  Future<RegisterResponse?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        "/register",
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "phone": phone,
          "password": password,
          "role": "ALICI",
        },
      );

      final Map<String, dynamic> data =
          res.data is String
              ? Map<String, dynamic>.from(jsonDecode(res.data))
              : Map<String, dynamic>.from(res.data);

      return RegisterResponse.fromJson(data);
    } catch (e) {
      print("REGISTER ERROR => $e");
      return null;
    }
  }

  // -------- KATEGORİLER --------
  Future<List<Category>> getCategories() async {
    final res = await _dio.get("/get_categories");

    if (res.data != null && res.data["success"] == true) {
      return (res.data["categories"] as List)
          .map((e) => Category.fromJson(e))
          .toList();
    }
    return [];
  }

  // -------- ÜRÜNLER --------
  Future<List<Product>> getProducts(int categoryId) async {
    final res = await _dio.get(
      "/get_products",
      queryParameters: {
        "category_id": categoryId.toString(),
      },
    );

    if (res.data != null && res.data["success"] == true) {
      final list = res.data["products"];
      if (list == null) return [];

      return (list as List)
          .map((e) => Product.fromJson(e))
          .toList();
    }

    return [];
  }

  // -------- ARAMA --------
  Future<SearchResponse?> search(String query) async {
    final res = await _dio.get(
      "/search",
      queryParameters: {"q": query},
    );

    if (res.data != null && res.data["success"] == true) {
      return SearchResponse.fromJson(res.data);
    }
    return null;
  }
}
