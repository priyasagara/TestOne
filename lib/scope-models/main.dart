import 'package:scoped_model/scoped_model.dart';

import 'package:food_orage_app/scope-models/connected_products.dart';

class MainModel extends Model
    with ConnectedProductsModel, UserModel, ProductsModel, UtilityModel {}
