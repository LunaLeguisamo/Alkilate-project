// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as String? ?? '',
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
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
      'uid': instance.uid,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'modifiedDate': instance.modifiedDate.toIso8601String(),
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
      id: json['id'] as String?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      disponibleFrom: json['disponibleFrom'] == null
          ? null
          : DateTime.parse(json['disponibleFrom'] as String),
      disponibleTo: json['disponibleTo'] == null
          ? null
          : DateTime.parse(json['disponibleTo'] as String),
      owner: json['owner'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      location:
          Product._latLngFromJson(json['location'] as Map<String, dynamic>?),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      time: json['time'] as String? ?? '',
      availability: json['availability'] as bool? ?? false,
      deposit: (json['deposit'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      approved: json['approved'] as bool? ?? false,
      rejected: json['rejected'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      pictures: (json['pictures'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [
            'https://firebasestorage.googleapis.com/v0/b/alkilate-a4fbc.firebasestorage.app/o/images.jpg?alt=media&token=b7a596a5-3663-4bd9-a542-396e7367641e'
          ],
      bankAccount: json['bankAccount'] as String? ?? '',
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'modifiedDate': instance.modifiedDate.toIso8601String(),
      'owner': instance.owner,
      'name': instance.name,
      'description': instance.description,
      'brand': instance.brand,
      'category': instance.category,
      'location': Product._latLngToJson(instance.location),
      'price': instance.price,
      'time': instance.time,
      'availability': instance.availability,
      'rating': instance.rating,
      'deposit': instance.deposit,
      'approved': instance.approved,
      'rejected': instance.rejected,
      'message': instance.message,
      'disponibleFrom': instance.disponibleFrom.toIso8601String(),
      'disponibleTo': instance.disponibleTo.toIso8601String(),
      'comments': instance.comments,
      'pictures': instance.pictures,
      'bankAccount': instance.bankAccount,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as String?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      buyer: json['buyer'] as String? ?? '',
      seller: json['seller'] as String? ?? '',
      product: json['product'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'modifiedDate': instance.modifiedDate.toIso8601String(),
      'buyer': instance.buyer,
      'seller': instance.seller,
      'product': instance.product,
      'productId': instance.productId,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      modifiedDate: json['modifiedDate'] == null
          ? null
          : DateTime.parse(json['modifiedDate'] as String),
      user: json['user'] as String? ?? '',
      product: json['product'] as String? ?? '',
      text: json['text'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'modifiedDate': instance.modifiedDate.toIso8601String(),
      'user': instance.user,
      'product': instance.product,
      'text': instance.text,
      'rating': instance.rating,
    };
