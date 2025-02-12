// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String? ?? '',
      dateCreated: json['dateCreated'] as String? ?? '',
      modifiedDate: json['modifiedDate'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      photoURL: json['photoURL'] as String? ?? '',
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isAdmin: json['isAdmin'] as bool? ?? false,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated,
      'modifiedDate': instance.modifiedDate,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'phoneNumber': instance.phoneNumber,
      'photoURL': instance.photoURL,
      'comments': instance.comments,
      'products': instance.products,
      'rating': instance.rating,
      'isAdmin': instance.isAdmin,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String? ?? '',
      dateCreated: json['dateCreated'] as String? ?? '',
      modifiedDate: json['modifiedDate'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      location: json['location'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      availability: json['availability'] as bool? ?? false,
      deposit: (json['deposit'] as num?)?.toDouble() ?? 0.0,
      approved: json['approved'] as bool? ?? false,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      pictures: (json['pictures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bankAccount: json['bankAccount'] as String? ?? '',
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated,
      'modifiedDate': instance.modifiedDate,
      'owner': instance.owner,
      'name': instance.name,
      'brand': instance.brand,
      'category': instance.category,
      'location': instance.location,
      'price': instance.price,
      'availability': instance.availability,
      'deposit': instance.deposit,
      'approved': instance.approved,
      'comments': instance.comments,
      'pictures': instance.pictures,
      'bankAccount': instance.bankAccount,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as String? ?? '',
      dateCreated: json['dateCreated'] as String? ?? '',
      modifiedDate: json['modifiedDate'] as String? ?? '',
      buyer: json['buyer'] as String? ?? '',
      seller: json['seller'] as String? ?? '',
      product: json['product'] as String? ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated,
      'modifiedDate': instance.modifiedDate,
      'buyer': instance.buyer,
      'seller': instance.seller,
      'product': instance.product,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String? ?? '',
      dateCreated: json['dateCreated'] as String? ?? '',
      modifiedDate: json['modifiedDate'] as String? ?? '',
      user: json['user'] as String? ?? '',
      product: json['product'] as String? ?? '',
      text: json['text'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated,
      'modifiedDate': instance.modifiedDate,
      'user': instance.user,
      'product': instance.product,
      'text': instance.text,
      'rating': instance.rating,
    };
