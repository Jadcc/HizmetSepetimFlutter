import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../utils/token_store.dart';

const String baseUrl = "http://92.249.61.58:8080/";

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json["id"].toString()),
      name: json["name"] ?? "",
    );
  }
}

class Product {
  final int id;
  final int categoryId;
  final String name;
  final String imageUrl;
  final String price;
  final String description;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawImage = json["image_url"]?.toString() ?? "";

    return Product(
      id: int.parse(json["id"].toString()),
      categoryId: int.parse(json["category_id"].toString()),
      name: json["name"] ?? "Ürün",
      imageUrl: rawImage.isEmpty
          ? ""
          : rawImage.startsWith("http")
          ? rawImage
          : "http://92.249.61.58$rawImage",
      price: json["price"]?.toString() ?? "0",
      description: json["description"]?.toString() ?? "",
    );
  }
}

class Review {
  final String userName;
  final double rating;
  final String comment;
  final String date;

  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json["user_name"] ?? "Anonim",
      rating: double.tryParse(json["rating"]?.toString() ?? "0") ?? 0,
      comment: json["comment"] ?? "",
      date: json["date"] ?? "",
    );
  }
}

class Seller {
  final int id;
  final String name;
  final String phone;
  final double rating;

  Seller({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: int.parse(json["id"].toString()),
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      rating: double.tryParse(json["rating"]?.toString() ?? "5") ?? 5,
    );
  }
}

class ProductDetailResponse {
  final bool success;
  final Product product;
  final List<String> images;
  final List<Review> reviews;
  final Seller? seller;

  ProductDetailResponse({
    required this.success,
    required this.product,
    required this.images,
    required this.reviews,
    required this.seller,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      success: json["success"] == true,
      product: Product.fromJson(json["product"]),
      images: (json["images"] as List? ?? []).map((e) => e.toString()).toList(),
      reviews: (json["reviews"] as List? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),
      seller: json["seller"] != null ? Seller.fromJson(json["seller"]) : null,
    );
  }
}

class SearchResponse {
  final List<Category> categories;
  final List<Product> products;

  SearchResponse({required this.categories, required this.products});

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
      token: json["token"] ?? "",
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
      message: json["message"] ?? "",
      token: json["token"] ?? "",
    );
  }
}

class Address {
  final int id;
  final String fullName;
  final String phone;
  final String addressLine;
  final String district;
  final String city;

  Address({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.district,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: int.parse(json["id"].toString()),
      fullName: json["full_name"] ?? "",
      phone: json["phone"] ?? "",
      addressLine: json["address_line"] ?? "",
      district: json["district"] ?? "",
      city: json["city"] ?? "",
    );
  }
}

class Booking {
  final int id;
  final String productName;
  final double price;
  final double totalPrice;
  final String appointmentDatetime;
  final String? addons;
  final String status;
  final String? addressLine;
  final String? district;
  final String? city;
  final String createdAt;

  Booking({
    required this.id,
    required this.productName,
    required this.price,
    required this.totalPrice,
    required this.appointmentDatetime,
    this.addons,
    required this.status,
    this.addressLine,
    this.district,
    this.city,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: int.parse(json["id"]?.toString() ?? "0"),
      productName: json["product_name"]?.toString() ?? "",
      price: double.tryParse(json["price"]?.toString() ?? "0") ?? 0.0,
      totalPrice:
          double.tryParse(json["total_price"]?.toString() ?? "0") ?? 0.0,
      appointmentDatetime: json["appointment_datetime"]?.toString() ?? "",
      addons: json["addons"]?.toString(),
      status: json["status"]?.toString() ?? "PENDING",
      addressLine: json["address_line"]?.toString(),
      district: json["district"]?.toString(),
      city: json["city"]?.toString(),
      createdAt: json["created_at"]?.toString() ?? "",
    );
  }
}

class WalletTransaction {
  final int id;
  final double amount;
  final String type;
  final String description;
  final String createdAt;

  WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: int.parse(json["id"]?.toString() ?? "0"),
      amount: double.tryParse(json["amount"]?.toString() ?? "0") ?? 0.0,
      type: json["type"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      createdAt: json["created_at"]?.toString() ?? "",
    );
  }
}

class ApiService {
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStore.read();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data == null) return <String, dynamic>{};
    if (data is String) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return Map<String, dynamic>.from(data as Map);
  }

  Future<bool> addAddress({
    required String fullName,
    required String phone,
    required String addressLine,
    required String district,
    required String city,
  }) async {
    try {
      await _dio.post(
        "/add_address",
        data: {
          "full_name": fullName,
          "phone": phone,
          "address_line": addressLine,
          "district": district,
          "city": city,
        },
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Address>> getAddresses() async {
    try {
      final res = await _dio.get("/get_addresses");
      final data = _asMap(res.data);

      if (data["success"] == true) {
        final list = (data["addresses"] as List? ?? []);
        return list.map((e) => Address.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<LoginResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        "/login",
        data: {"email": email, "password": password},
      );

      final data = _asMap(res.data);
      return LoginResponse.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAddons() async {
    try {
      final res = await _dio.get("/get_addons");

      if (res.data == null || res.data.toString().trim().isEmpty) {
        print("❌ getAddons: EMPTY RESPONSE");
        return [];
      }

      final data = res.data is String ? jsonDecode(res.data) : res.data;

      if (data["success"] != true) {
        print("❌ getAddons failed: $data");
        return [];
      }

      return List<Map<String, dynamic>>.from(data["addons"]);
    } catch (e) {
      print("❌ getAddons error: $e");
      return [];
    }
  }

  Future<bool> createOrder({
    required int addressId,
    required int categoryId,
    required String productName,
    required double price,
    required double totalPrice,
    required String appointment,
    required String addons,
    required double walletPayment,
    required double cardPayment,
    required String paymentMethod,
  }) async {
    try {
      final res = await _dio.post(
        "/create_order_with_payment",
        data: {
          "address_id": addressId,
          "category_id": categoryId,
          "product_name": productName,
          "price": price,
          "total_price": totalPrice,
          "appointment_datetime": appointment,
          "addons": addons,
          "wallet_payment": walletPayment,
          "card_payment": cardPayment,
          "payment_method": paymentMethod,
        },
      );
      return res.data["success"] == true;
    } catch (e) {
      debugPrint("❌ createOrder error: $e");
      return false;
    }
  }

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

      final data = _asMap(res.data);
      return RegisterResponse.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final token = await TokenStore.read();

    final res = await _dio.put(
      "/update_profile",
      options: Options(headers: {"Authorization": "Bearer $token"}),
      data: {"name": name, "email": email, "phone": phone},
    );

    final data = _asMap(res.data);
    return data["success"] == true;
  }

  Future<List<Category>> getCategories() async {
    final res = await _dio.get("/get_categories");
    final data = _asMap(res.data);

    if (data["success"] == true) {
      final list = (data["categories"] as List? ?? []);
      return list.map((e) => Category.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Product>> getProducts(int categoryId) async {
    final res = await _dio.get(
      "/get_products",
      queryParameters: {"category_id": categoryId},
    );

    final data = _asMap(res.data);

    if (data["success"] == true) {
      final list = (data["products"] as List? ?? []);
      return list.map((e) => Product.fromJson(e)).toList();
    }
    return [];
  }

  Future<ProductDetailResponse?> getProductDetail(int productId) async {
    try {
      final res = await _dio.get(
        "/get_product_detail",
        queryParameters: {"id": productId},
      );

      final data = _asMap(res.data);

      if (data["success"] == true) {
        return ProductDetailResponse.fromJson(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<SearchResponse?> search(String query) async {
    final res = await _dio.get("/search", queryParameters: {"q": query});

    final data = _asMap(res.data);

    if (data["success"] == true) {
      return SearchResponse.fromJson(data);
    }
    return null;
  }

  Future<List<Booking>> getBookings() async {
    try {
      final res = await _dio.get("/get_orders");
      final data = _asMap(res.data);

      if (data["success"] == true) {
        final list = (data["orders"] as List? ?? []);
        return list.map((e) => Booking.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ getBookings error: $e");
      return [];
    }
  }

  Future<double> getWalletBalance() async {
    try {
      final res = await _dio.get("/wallet/balance");
      final data = _asMap(res.data);

      if (data["success"] == true) {
        return double.tryParse(data["balance"]?.toString() ?? "0") ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      debugPrint("❌ getWalletBalance error: $e");
      return 0.0;
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions() async {
    try {
      final res = await _dio.get("/wallet/transactions");
      final data = _asMap(res.data);

      if (data["success"] == true) {
        final list = (data["transactions"] as List? ?? []);
        return list.map((e) => WalletTransaction.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ getWalletTransactions error: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> redeemPromoCode(String code) async {
    try {
      final res = await _dio.post("/redeem_promo", data: {"code": code});
      final data = _asMap(res.data);

      if (data["success"] == true) {
        return data;
      }
      return data;
    } catch (e) {
      debugPrint("❌ redeemPromoCode error: $e");
      return {"success": false, "message": "Kod kullanılamadı"};
    }
  }
}
