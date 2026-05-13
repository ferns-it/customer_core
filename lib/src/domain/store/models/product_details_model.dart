// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductDetailsModel {
  final String? activeMenu;
  final int? activeShopMenuID;
  final List<ProductDataModel> items;
  final String? note;

  ProductDetailsModel({
    this.items = const [],
    this.note,
    this.activeMenu,
    this.activeShopMenuID,
  });

  ProductDetailsModel copyWith({
    List<ProductDataModel>? items,
    String? note,
    String? activeMenu,
    int? activeShopMenuID,
  }) {
    return ProductDetailsModel(
      items: items ?? this.items,
      note: note ?? this.note,
      activeMenu: activeMenu ?? this.activeMenu,
      activeShopMenuID: activeShopMenuID ?? this.activeShopMenuID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((x) => x.toMap()).toList(),
      'note': note,
      'activeMenu': activeMenu,
      'activeShopMenuID': activeShopMenuID,
    };
  }

  factory ProductDetailsModel.fromMap(Map<String, dynamic> map) {
    return ProductDetailsModel(
      items: map['items'] != null
          ? List<ProductDataModel>.from(
              (map['items'] as List<dynamic>).map<ProductDataModel?>(
                (x) => ProductDataModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      note: map['note'] != null ? map['note'] as String : null,
      activeMenu:
          map['activeMenu'] != null ? map['activeMenu'] as String : null,
      activeShopMenuID: map['activeShopMenuID'] != null
          ? map['activeShopMenuID'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDetailsModel.fromJson(String source) =>
      ProductDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ProductDetailsSubDataModel(items: $items, note: $note, activeMenu: $activeMenu, activeShopMenuID: $activeShopMenuID)';

  @override
  bool operator ==(covariant ProductDetailsModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.items, items) &&
        other.note == note &&
        other.activeMenu == activeMenu &&
        other.activeShopMenuID == activeShopMenuID;
  }

  @override
  int get hashCode =>
      items.hashCode ^
      note.hashCode ^
      activeMenu.hashCode ^
      activeShopMenuID.hashCode;
}

class ProductDataModel {
  final String? favouriteID;
  final String? pID;
  final bool? isAvailable;
  final String? productType;
  final String? online;
  final String? dining;
  final String? activeStatus;
  final bool? isMeal;
  final String? name;
  final String? type;
  final String? photo;
  final String? description;
  final bool? availability;
  final String? price;
  final String? priceValue;
  final List<ProductVariationDataModel> variations;
  final bool hasMultipleVariation;
  final List<ProductsAddonDataModel> addons;
  final bool hasAddons;
  final bool hasMasterAddons;
  final List<ProductMasterAddonDataModel> masterAddons;
  final ColorScheme? scheme;
  final bool isFavourite;
  final String? isOfferPrice;
  final ProductOfferPriceDetailsDataModel? offerPriceDetails;

  ProductDataModel({
    this.favouriteID,
    this.pID,
    this.isAvailable,
    this.productType,
    this.online,
    this.dining,
    this.activeStatus,
    this.isMeal,
    this.name,
    this.photo,
    this.type,
    this.description,
    this.availability,
    this.price,
    this.priceValue,
    this.variations = const [],
    this.hasMultipleVariation = false,
    this.addons = const [],
    this.hasAddons = false,
    this.hasMasterAddons = false,
    this.masterAddons = const [],
    this.scheme,
    this.isFavourite = false,
    this.isOfferPrice,
    this.offerPriceDetails,
  });

  ProductDataModel copyWith({
    String? favouriteID,
    String? pID,
    bool? isAvailable,
    String? productType,
    String? online,
    String? dining,
    String? activeStatus,
    bool? isMeal,
    String? name,
    bool? availability,
    String? price,
    String? type,
    String? description,
    String? photo,
    String? priceValue,
    List<ProductVariationDataModel>? variations,
    bool? hasMultipleVariation,
    List<ProductsAddonDataModel>? addons,
    bool? hasAddons,
    bool? hasMasterAddons,
    List<ProductMasterAddonDataModel>? masterAddons,
    ColorScheme? scheme,
    bool? isFavourite,
    String? isOfferPrice,
    ProductOfferPriceDetailsDataModel? offerPriceDetails,
  }) {
    return ProductDataModel(
        favouriteID: favouriteID ?? this.favouriteID,
        pID: pID ?? this.pID,
        isAvailable: isAvailable ?? this.isAvailable,
        productType: productType ?? this.productType,
        online: online ?? this.online,
        dining: dining ?? this.dining,
        activeStatus: activeStatus ?? this.activeStatus,
        isMeal: isMeal ?? this.isMeal,
        name: name ?? this.name,
        availability: availability ?? this.availability,
        price: price ?? this.price,
        description: description ?? this.description,
        photo: photo ?? this.photo,
        type: type ?? this.type,
        priceValue: priceValue ?? this.priceValue,
        variations: variations ?? this.variations,
        hasMultipleVariation: hasMultipleVariation ?? this.hasMultipleVariation,
        addons: addons ?? this.addons,
        hasAddons: hasAddons ?? this.hasAddons,
        hasMasterAddons: hasMasterAddons ?? this.hasMasterAddons,
        masterAddons: masterAddons ?? this.masterAddons,
        scheme: scheme ?? this.scheme,
        isFavourite: isFavourite ?? this.isFavourite,
        isOfferPrice: isOfferPrice ?? this.isOfferPrice,
        offerPriceDetails: offerPriceDetails ?? this.offerPriceDetails);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'favouriteID': favouriteID,
      'pID': pID,
      'isAvailable': isAvailable,
      'productType': productType,
      'online': online,
      'dining': dining,
      'activeStatus': activeStatus,
      'isMeal': isMeal,
      'name': name,
      'availability': availability,
      'price': price,
      'photo': photo,
      'description': description,
      'type': type,
      'priceValue': priceValue,
      'variations': variations.map((x) => x.toMap()).toList(),
      'hasMultipleVariation': hasMultipleVariation,
      'addons': addons.map((x) => x.toMap()).toList(),
      'hasAddons': hasAddons,
      'hasMasterAddons': hasMasterAddons,
      'masterAddons': masterAddons.map((x) => x.toMap()).toList(),
      'isFavourite': isFavourite,
      'isOfferPrice': isOfferPrice,
      'offerPriceDetails': offerPriceDetails?.toMap(),
    };
  }

  factory ProductDataModel.fromMap(Map<String, dynamic> map) {
    return ProductDataModel(
      favouriteID:
          map['favouriteID'] != null ? map['favouriteID'] as String : null,
      pID: map['pID'] != null ? map['pID'] as String : null,
      isAvailable:
          map['isAvailable'] != null ? map['isAvailable'] as bool : null,
      productType:
          map['productType'] != null ? map['productType'] as String : null,
      online: map['online'] != null ? map['online'] as String : null,
      dining: map['dining'] != null ? map['dining'] as String : null,
      activeStatus:
          map['activeStatus'] != null ? map['activeStatus'] as String : null,
      isMeal: map['isMeal'] != null ? map['isMeal'] as bool : null,
      name: map['name'] != null ? map['name'] as String : null,
      availability:
          map['availability'] != null ? map['availability'] as bool : null,
      price: map['price'] != null ? map['price'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      priceValue:
          map['priceValue'] != null ? map['priceValue'] as String : null,
      variations: map['variations'] != null
          ? List<ProductVariationDataModel>.from(
              (map['variations'] as List<dynamic>)
                  .map<ProductVariationDataModel?>(
                (x) => ProductVariationDataModel.fromMap(
                    x as Map<String, dynamic>),
              ),
            )
          : [],
      hasMultipleVariation: map['hasMultipleVariation'] != null
          ? map['hasMultipleVariation'] as bool
          : false,
      addons: map['addons'] != null
          ? List<ProductsAddonDataModel>.from(
              (map['addons'] as List<dynamic>).map<ProductsAddonDataModel?>(
                (x) =>
                    ProductsAddonDataModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      hasAddons: map['hasAddons'] != null ? map['hasAddons'] as bool : false,
      hasMasterAddons: map['hasMasterAddons'] != null
          ? map['hasMasterAddons'] as bool
          : false,
      masterAddons: map['masterAddons'] != null
          ? List<ProductMasterAddonDataModel>.from(
              (map['masterAddons'] as List<dynamic>)
                  .map<ProductMasterAddonDataModel?>(
                (x) => ProductMasterAddonDataModel.fromMap(
                    x as Map<String, dynamic>),
              ),
            )
          : [],
      isFavourite:
          map['isFavourite'] != null ? map['isFavourite'] as bool : false,
      isOfferPrice:
          map['isOfferPrice'] != null ? map['isOfferPrice'] as String : null,
      offerPriceDetails: map['offerPriceDetails'] != null
          ? ProductOfferPriceDetailsDataModel.fromMap(
              map['offerPriceDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDataModel.fromJson(String source) =>
      ProductDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductDataModel(favouriteID: $favouriteID,pID: $pID, isAvailable: $isAvailable,productType: $productType, online: $online, dining: $dining, activeStatus: $activeStatus, isMeal: $isMeal, name: $name, availability: $availability, price: $price,photo: $photo,type: $type,description: $description, priceValue: $priceValue, variations: $variations, hasMultipleVariation: $hasMultipleVariation, addons: $addons, hasAddons: $hasAddons, hasMasterAddons: $hasMasterAddons, masterAddons: $masterAddons, isFavourite: $isFavourite, isOfferPrice: $isOfferPrice, offerPriceDetails: $offerPriceDetails)';
  }

  @override
  bool operator ==(covariant ProductDataModel other) {
    if (identical(this, other)) return true;

    return other.favouriteID == favouriteID &&
        other.pID == pID &&
        other.isAvailable == isAvailable &&
        other.productType == productType &&
        other.online == online &&
        other.dining == dining &&
        other.activeStatus == activeStatus &&
        other.isMeal == isMeal &&
        other.name == name &&
        other.availability == availability &&
        other.price == price &&
        other.photo == photo &&
        other.description == description &&
        other.type == type &&
        other.priceValue == priceValue &&
        listEquals(other.variations, variations) &&
        other.hasMultipleVariation == hasMultipleVariation &&
        listEquals(other.addons, addons) &&
        other.hasAddons == hasAddons &&
        other.hasMasterAddons == hasMasterAddons &&
        listEquals(other.masterAddons, masterAddons) &&
        other.isFavourite == isFavourite &&
        other.isOfferPrice == isOfferPrice &&
        other.offerPriceDetails == offerPriceDetails;
  }

  @override
  int get hashCode {
    return favouriteID.hashCode ^
        pID.hashCode ^
        isAvailable.hashCode ^
        productType.hashCode ^
        online.hashCode ^
        dining.hashCode ^
        activeStatus.hashCode ^
        isMeal.hashCode ^
        name.hashCode ^
        availability.hashCode ^
        price.hashCode ^
        photo.hashCode ^
        type.hashCode ^
        description.hashCode ^
        priceValue.hashCode ^
        variations.hashCode ^
        hasMultipleVariation.hashCode ^
        addons.hashCode ^
        hasAddons.hashCode ^
        hasMasterAddons.hashCode ^
        masterAddons.hashCode ^
        isFavourite.hashCode ^
        isOfferPrice.hashCode ^
        offerPriceDetails.hashCode;
  }
}

class ProductVariationDataModel {
  final String? pvID;
  final String? name;
  final String? price;
  final String? displayPrice;
  final String? ingredients;
  final String? isUnlimitedStock;
  final String? stock;
  final List<ProductsAllergenDataModel>? allergens;
  final List<dynamic>? selectedallergens;
  final List<dynamic>? allergensMaster;
  final List<ProductMasterAddonDataModel>? variationmasteraddons;
  final bool? offerPriceEnabled;
  final ProductOfferPriceDetailsDataModel? offerPriceDetails;

  ProductVariationDataModel({
    this.pvID,
    this.name,
    this.price,
    this.displayPrice,
    this.ingredients,
    this.isUnlimitedStock,
    this.stock,
    this.allergens,
    this.selectedallergens,
    this.allergensMaster,
    this.variationmasteraddons,
    this.offerPriceEnabled,
    this.offerPriceDetails,
  });

  ProductVariationDataModel copyWith({
    String? pvID,
    String? name,
    String? price,
    String? displayPrice,
    String? ingredients,
    String? isUnlimitedStock,
    String? stock,
    List<ProductsAllergenDataModel>? allergens,
    List<dynamic>? selectedallergens,
    List<dynamic>? allergensMaster,
    List<ProductMasterAddonDataModel>? variationmasteraddons,
    bool? offerPriceEnabled,
    ProductOfferPriceDetailsDataModel? offerPriceDetails,
  }) {
    return ProductVariationDataModel(
      pvID: pvID ?? this.pvID,
      name: name ?? this.name,
      price: price ?? this.price,
      displayPrice: displayPrice ?? this.displayPrice,
      ingredients: ingredients ?? this.ingredients,
      isUnlimitedStock: isUnlimitedStock ?? this.isUnlimitedStock,
      stock: stock ?? this.stock,
      allergens: allergens ?? this.allergens,
      selectedallergens: selectedallergens ?? this.selectedallergens,
      allergensMaster: allergensMaster ?? this.allergensMaster,
      variationmasteraddons:
          variationmasteraddons ?? this.variationmasteraddons,
      offerPriceEnabled: offerPriceEnabled ?? this.offerPriceEnabled,
      offerPriceDetails: offerPriceDetails ?? this.offerPriceDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pvID': pvID,
      'name': name,
      'price': price,
      'displayPrice': displayPrice,
      'ingredients': ingredients,
      'isUnlimitedStock': isUnlimitedStock,
      'stock': stock,
      'allergens': allergens?.map((x) => x.toMap()).toList(),
      'selectedallergens': selectedallergens,
      'allergensMaster': allergensMaster,
      'variationmasteraddons':
          variationmasteraddons?.map((x) => x.toMap()).toList(),
      'offerPriceEnabled': offerPriceEnabled,
      'offerPriceDetails': offerPriceDetails?.toMap(),
    };
  }

  factory ProductVariationDataModel.fromMap(Map<String, dynamic> map) {
    return ProductVariationDataModel(
      pvID: map['pvID'] != null ? map['pvID'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      displayPrice:
          map['displayPrice'] != null ? map['displayPrice'] as String : null,
      ingredients:
          map['ingredients'] != null ? map['ingredients'] as String : null,
      isUnlimitedStock: map['isUnlimitedStock'] != null
          ? map['isUnlimitedStock'] as String
          : null,
      stock: map['stock'] != null ? map['stock'] as String : null,
      // allergens: map['allergens'] != null
      //     ? List<ProductsAllergenDataModel>.from(
      //         (map['allergens'] as List<dynamic>).map<ProductsAllergenDataModel?>(
      //           (x) => ProductsAllergenDataModel.fromMap(x as Map<String, dynamic>),
      //         ),
      //       )
      //     : null,
      selectedallergens: map['selectedallergens'] != null
          ? List<dynamic>.from((map['selectedallergens'] as List<dynamic>))
          : null,
      allergensMaster: map['allergensMaster'] != null
          ? List<dynamic>.from((map['allergensMaster'] as List<dynamic>))
          : null,
      variationmasteraddons: map['variationmasteraddons'] != null
          ? List<ProductMasterAddonDataModel>.from(
              (map['variationmasteraddons'] as List<dynamic>)
                  .map<ProductMasterAddonDataModel?>(
                (x) => ProductMasterAddonDataModel.fromMap(
                    x as Map<String, dynamic>),
              ),
            )
          : null,
      offerPriceEnabled: map['offerPriceEnabled'] != null
          ? map['offerPriceEnabled'] as bool
          : null,
      offerPriceDetails: map['offerPriceDetails'] != null
          ? ProductOfferPriceDetailsDataModel.fromMap(
              map['offerPriceDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductVariationDataModel.fromJson(String source) =>
      ProductVariationDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductVariationDataModel(pvID: $pvID, name: $name, price: $price, displayPrice: $displayPrice, ingredients: $ingredients, isUnlimitedStock: $isUnlimitedStock, stock: $stock, allergens: $allergens, selectedallergens: $selectedallergens, allergensMaster: $allergensMaster, variationmasteraddons: $variationmasteraddons, offerPriceEnabled: $offerPriceEnabled, offerPriceDetails: $offerPriceDetails)';
  }

  @override
  bool operator ==(covariant ProductVariationDataModel other) {
    if (identical(this, other)) return true;

    return other.pvID == pvID &&
        other.name == name &&
        other.price == price &&
        other.displayPrice == displayPrice &&
        other.ingredients == ingredients &&
        other.isUnlimitedStock == isUnlimitedStock &&
        other.stock == stock &&
        listEquals(other.allergens, allergens) &&
        listEquals(other.selectedallergens, selectedallergens) &&
        listEquals(other.allergensMaster, allergensMaster) &&
        listEquals(other.variationmasteraddons, variationmasteraddons) &&
        other.offerPriceEnabled == offerPriceEnabled &&
        other.offerPriceDetails == offerPriceDetails;
  }

  @override
  int get hashCode {
    return pvID.hashCode ^
        name.hashCode ^
        price.hashCode ^
        displayPrice.hashCode ^
        ingredients.hashCode ^
        isUnlimitedStock.hashCode ^
        stock.hashCode ^
        allergens.hashCode ^
        selectedallergens.hashCode ^
        allergensMaster.hashCode ^
        variationmasteraddons.hashCode ^
        offerPriceEnabled.hashCode ^
        offerPriceDetails.hashCode;
  }
}

class ProductsAllergenDataModel {
  final String? id;
  final String? name;

  ProductsAllergenDataModel({
    this.id,
    this.name,
  });

  ProductsAllergenDataModel copyWith({
    String? id,
    String? name,
  }) {
    return ProductsAllergenDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory ProductsAllergenDataModel.fromMap(Map<String, dynamic> map) {
    return ProductsAllergenDataModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsAllergenDataModel.fromJson(String source) =>
      ProductsAllergenDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProductsAllergenDataModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant ProductsAllergenDataModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class ProductsAddonDataModel {
  final String? name;
  final String? id;
  final List<ProductsOptionDataModel> options;

  ProductsAddonDataModel({
    this.name,
    this.id,
    this.options = const [],
  });

  ProductsAddonDataModel copyWith({
    String? name,
    String? id,
    List<ProductsOptionDataModel>? options,
  }) {
    return ProductsAddonDataModel(
      name: name ?? this.name,
      id: id ?? this.id,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'options': options.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductsAddonDataModel.fromMap(Map<String, dynamic> map) {
    return ProductsAddonDataModel(
      name: map['name'] != null ? map['name'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      options: List<ProductsOptionDataModel>.from(
        (map['options'] as List<dynamic>).map<ProductsOptionDataModel?>(
          (x) => ProductsOptionDataModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsAddonDataModel.fromJson(String source) =>
      ProductsAddonDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ProductsAddonDataModel(name: $name, id: $id, options: $options)';

  @override
  bool operator ==(covariant ProductsAddonDataModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        listEquals(other.options, options);
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ options.hashCode;
}

class ProductsOptionDataModel {
  final String? text;
  final String? price;
  final String? price_formatted;
  final String? value;
  final bool? checked;

  ProductsOptionDataModel({
    this.text,
    this.price,
    this.price_formatted,
    this.value,
    this.checked,
  });

  ProductsOptionDataModel copyWith({
    String? text,
    String? price,
    String? price_formatted,
    String? value,
    bool? checked,
  }) {
    return ProductsOptionDataModel(
      text: text ?? this.text,
      price: price ?? this.price,
      price_formatted: price_formatted ?? this.price_formatted,
      value: value ?? this.value,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'price': price,
      'price_formatted': price_formatted,
      'value': value,
      'checked': checked,
    };
  }

  factory ProductsOptionDataModel.fromMap(Map<String, dynamic> map) {
    return ProductsOptionDataModel(
      text: map['text'] != null ? map['text'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      price_formatted: map['price_formatted'] != null
          ? map['price_formatted'] as String
          : null,
      value: map['value'] != null ? map['value'] as String : null,
      checked: map['checked'] != null ? map['checked'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsOptionDataModel.fromJson(String source) =>
      ProductsOptionDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductsOptionDataModel(text: $text, price: $price, price_formatted: $price_formatted, value: $value, checked: $checked)';
  }

  @override
  bool operator ==(covariant ProductsOptionDataModel other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.price == price &&
        other.price_formatted == price_formatted &&
        other.value == value &&
        other.checked == checked;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        price.hashCode ^
        price_formatted.hashCode ^
        value.hashCode ^
        checked.hashCode;
  }
}

class ProductMasterAddonDataModel {
  final String? id;
  final String? name;
  final String? minimumRequired;
  final String? maximumRequired;
  final List<ProductsMasterAddonsOptionDataModel> options;

  ProductMasterAddonDataModel({
    this.id,
    this.name,
    this.minimumRequired,
    this.maximumRequired,
    this.options = const [],
  });

  ProductMasterAddonDataModel copyWith({
    String? id,
    String? name,
    String? minimumRequired,
    String? maximumRequired,
    List<ProductsMasterAddonsOptionDataModel>? options,
  }) {
    return ProductMasterAddonDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      minimumRequired: minimumRequired ?? this.minimumRequired,
      maximumRequired: maximumRequired ?? this.maximumRequired,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'minimumRequired': minimumRequired,
      'maximumRequired': maximumRequired,
      'options': options.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductMasterAddonDataModel.fromMap(Map<String, dynamic> map) {
    return ProductMasterAddonDataModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      minimumRequired: map['minimumRequired'] != null
          ? map['minimumRequired'] as String
          : null,
      maximumRequired: map['maximumRequired'] != null
          ? map['maximumRequired'] as String
          : null,
      options: List<ProductsMasterAddonsOptionDataModel>.from(
        (map['options'] as List<dynamic>)
            .map<ProductsMasterAddonsOptionDataModel?>(
          (x) => ProductsMasterAddonsOptionDataModel.fromMap(
              x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductMasterAddonDataModel.fromJson(String source) =>
      ProductMasterAddonDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductMasterAddonDataModel(id: $id, name: $name, minimumRequired: $minimumRequired, maximumRequired: $maximumRequired, options: $options)';
  }

  @override
  bool operator ==(covariant ProductMasterAddonDataModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.minimumRequired == minimumRequired &&
        other.maximumRequired == maximumRequired &&
        listEquals(other.options, options);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        minimumRequired.hashCode ^
        maximumRequired.hashCode ^
        options.hashCode;
  }
}

class ProductsMasterAddonsOptionDataModel {
  final String? text;
  final String? price;
  final String? price_formatted;
  final String? itemId;
  final bool? checked;

  ProductsMasterAddonsOptionDataModel({
    this.text,
    this.price,
    this.price_formatted,
    this.itemId,
    this.checked,
  });

  ProductsMasterAddonsOptionDataModel copyWith({
    String? text,
    String? price,
    String? price_formatted,
    String? itemId,
    bool? checked,
  }) {
    return ProductsMasterAddonsOptionDataModel(
      text: text ?? this.text,
      price: price ?? this.price,
      price_formatted: price_formatted ?? this.price_formatted,
      itemId: itemId ?? this.itemId,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'price': price,
      'price_formatted': price_formatted,
      'itemId': itemId,
      'checked': checked,
    };
  }

  factory ProductsMasterAddonsOptionDataModel.fromMap(
      Map<String, dynamic> map) {
    return ProductsMasterAddonsOptionDataModel(
      text: map['text'] != null ? map['text'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      price_formatted: map['price_formatted'] != null
          ? map['price_formatted'] as String
          : null,
      itemId: map['itemId'] != null ? map['itemId'] as String : null,
      checked: map['checked'] != null ? map['checked'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsMasterAddonsOptionDataModel.fromJson(String source) =>
      ProductsMasterAddonsOptionDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductsMasterAddonsOptionDataModel(text: $text, price: $price, price_formatted: $price_formatted, itemId: $itemId, checked: $checked)';
  }

  @override
  bool operator ==(covariant ProductsMasterAddonsOptionDataModel other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.price == price &&
        other.price_formatted == price_formatted &&
        other.itemId == itemId &&
        other.checked == checked;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        price.hashCode ^
        price_formatted.hashCode ^
        itemId.hashCode ^
        checked.hashCode;
  }
}

class ProductOfferPriceDataModel {
  final String? id;
  final String? offerPrice;
  final String? offerPriceFormatted;
  final String? startTime;
  final String? endTime;
  ProductOfferPriceDataModel({
    this.id,
    this.offerPrice,
    this.offerPriceFormatted,
    this.startTime,
    this.endTime,
  });

  ProductOfferPriceDataModel copyWith({
    String? id,
    String? offerPrice,
    String? offerPriceFormatted,
    String? startTime,
    String? endTime,
  }) {
    return ProductOfferPriceDataModel(
      id: id ?? this.id,
      offerPrice: offerPrice ?? this.offerPrice,
      offerPriceFormatted: offerPriceFormatted ?? this.offerPriceFormatted,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'offerPrice': offerPrice,
      'offerPriceFormatted': offerPriceFormatted,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory ProductOfferPriceDataModel.fromMap(Map<String, dynamic> map) {
    return ProductOfferPriceDataModel(
      id: map['id'] != null ? map['id'] as String : null,
      offerPrice:
          map['offerPrice'] != null ? map['offerPrice'] as String : null,
      offerPriceFormatted: map['offerPriceFormatted'] != null
          ? map['offerPriceFormatted'] as String
          : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOfferPriceDataModel.fromJson(String source) =>
      ProductOfferPriceDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductOfferPriceDataModel(id: $id, offerPrice: $offerPrice, offerPriceFormatted: $offerPriceFormatted, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(covariant ProductOfferPriceDataModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.offerPrice == offerPrice &&
        other.offerPriceFormatted == offerPriceFormatted &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        offerPrice.hashCode ^
        offerPriceFormatted.hashCode ^
        startTime.hashCode ^
        endTime.hashCode;
  }
}

class ProductOfferPriceDetailsDataModel {
  final ProductOfferPriceDataModel? currentOfferPrice;
  final ProductOfferPriceDataModel? upcomingOfferPrice;
  ProductOfferPriceDetailsDataModel({
    this.currentOfferPrice,
    this.upcomingOfferPrice,
  });

  ProductOfferPriceDetailsDataModel copyWith({
    ProductOfferPriceDataModel? currentOfferPrice,
    ProductOfferPriceDataModel? upcomingOfferPrice,
  }) {
    return ProductOfferPriceDetailsDataModel(
      currentOfferPrice: currentOfferPrice ?? this.currentOfferPrice,
      upcomingOfferPrice: upcomingOfferPrice ?? this.upcomingOfferPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentOfferPrice': currentOfferPrice?.toMap(),
      'upcomingOfferPrice': upcomingOfferPrice?.toMap(),
    };
  }

  factory ProductOfferPriceDetailsDataModel.fromMap(Map<String, dynamic> map) {
    return ProductOfferPriceDetailsDataModel(
      currentOfferPrice: map['currentOfferPrice'] != null
          ? ProductOfferPriceDataModel.fromMap(
              map['currentOfferPrice'] as Map<String, dynamic>)
          : null,
      upcomingOfferPrice: map['upcomingOfferPrice'] != null
          ? ProductOfferPriceDataModel.fromMap(
              map['upcomingOfferPrice'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductOfferPriceDetailsDataModel.fromJson(String source) =>
      ProductOfferPriceDetailsDataModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ProductOfferPriceDetailsDataModel(currentOfferPrice: $currentOfferPrice, upcomingOfferPrice: $upcomingOfferPrice)';

  @override
  bool operator ==(covariant ProductOfferPriceDetailsDataModel other) {
    if (identical(this, other)) return true;

    return other.currentOfferPrice == currentOfferPrice &&
        other.upcomingOfferPrice == upcomingOfferPrice;
  }

  @override
  int get hashCode => currentOfferPrice.hashCode ^ upcomingOfferPrice.hashCode;
}
