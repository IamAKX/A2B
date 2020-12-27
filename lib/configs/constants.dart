import 'package:singlestore/models/branch.dart';
import 'package:singlestore/models/customize.dart';
import 'package:singlestore/models/food.dart';

List<BranchModel> BRANCHES = [
  BranchModel(
      address: '53/2, Sl 319, Doddakannelli Village, Varthur Hobli',
      id: '1',
      name: 'Sarjspur'),
  BranchModel(
      address: '710, Thubarahalli, Varthur Main Road, Whitefield',
      id: '2',
      name: 'Varthur Main Road'),
  BranchModel(
      address: '3, 100 Feet Road, 16th Main Road, 1st Stage, BTM',
      id: '3',
      name: 'BTM'),
  BranchModel(
      address: '2nd Floor, Survey 5/1 Of Madalkunte Village ',
      id: '4',
      name: 'Yelahanka'),
  BranchModel(
      address: '1260, Survey 35/4, SJR Tower\'s, 7th Phase',
      id: '5',
      name: 'JP Nagar'),
];

class FoodCategory {
  static String SOUTH_INDIAN = 'South Indian';
  static String NORTH_INDIAN = 'North Indian';
  static String CHINESE = 'Chinese';
  static String CHAAT = 'Chaat';
  static List<FoodModel> FOOD_LIST = [];
}

List<String> MENU_SECTION = [
  'Home',
  FoodCategory.SOUTH_INDIAN,
  FoodCategory.NORTH_INDIAN,
  FoodCategory.CHINESE,
  FoodCategory.CHAAT,
  'Favourite'
];

List<String> IMAGE_BANNER = [
  'https://aabsweets.com/wp-content/uploads/sb-instagram-feed-images/72212013_2388464631472650_8458492959317590424_nfull.jpg',
  'https://aabsweets.com/wp-content/uploads/sb-instagram-feed-images/72212013_2388464631472650_8458492959317590424_nfull.jpg',
  'https://aabsweets.com/wp-content/uploads/sb-instagram-feed-images/72212013_2388464631472650_8458492959317590424_nfull.jpg',
  'https://aabsweets.com/wp-content/uploads/sb-instagram-feed-images/72212013_2388464631472650_8458492959317590424_nfull.jpg',
  'https://aabsweets.com/wp-content/uploads/sb-instagram-feed-images/72212013_2388464631472650_8458492959317590424_nfull.jpg',
  'https://aabsweets.com/wp-content/uploads/sb-instagram-feed-images/72212013_2388464631472650_8458492959317590424_nfull.jpg',
  'https://aabsweets.com/wp-content/uploads/sb-instagram-feed-images/72212013_2388464631472650_8458492959317590424_nfull.jpg',
  'https://aabsweets.com/wp-content/uploads/sb-instagram-feed-images/72212013_2388464631472650_8458492959317590424_nfull.jpg',
];

List<String> BANNER_LINK = [
  'https://www.eazydiner.com/kolkata/deals/fifty-percent-discounts',
  'https://www.grabon.in/food-coupons/',
  'https://happycheckout.in/coupons/Food',
  'https://www.coupondunia.in/category/food-and-dining',
  'https://freekaamaal.com/food',
  'https://happysale.in/food/offers/',
  'https://www.zomato.com/kolkata/lunch?offers=1',
];

// List<CustomizeModel> CUSTOMIZE_LIST = [
//   CustomizeModel(title: 'Extra Ghee', charge: 20.0),
//   CustomizeModel(title: 'Extra Cheese', charge: 30.0),
//   CustomizeModel(title: 'Extra Spicy', charge: 0.0),
//   CustomizeModel(title: 'Less Sugar', charge: 0.0),
//   CustomizeModel(title: 'Coke', charge: 50.0),
// ];

// List<FoodModel> FOOD_LIST = [
//   FoodModel(
//     id: '1',
//     name: 'Plain Dosa',
//     description: 'Light roasted tava dosa',
//     image:
//         'https://bramptonist.com/wp-content/uploads/2018/01/dosa-brampton-1280x720.png',
//     amount: 35.0,
//     category: FoodCategory.SOUTH_INDIAN,
//     customizationList: CUSTOMIZE_LIST,
//     isVeg: true,
//     stock: 4,
//   ),
//   FoodModel(
//     id: '2',
//     name: 'Idli Vada',
//     description: 'Freshly cooked Idly, Vada and chutney',
//     image:
//         'https://images.jdmagicbox.com/comp/dharwad/p9/0836px836.x836.171231054924.r1p9/catalogue/sri-maruti-idli-vada-centre-kundgol-dharwad-restaurants-i5iz0.jpg',
//     amount: 25.0,
//     category: FoodCategory.SOUTH_INDIAN,
//     customizationList: CUSTOMIZE_LIST,
//     isVeg: true,
//     stock: 2,
//   ),
//   FoodModel(
//     id: '3',
//     name: 'Rava Dosai',
//     description: 'Special South Inida dish',
//     image:
//         'https://i2.wp.com/www.vegrecipesofindia.com/wp-content/uploads/2014/04/onion-rava-dosa-recipe-1-1-500x500.jpg',
//     amount: 65.0,
//     category: FoodCategory.SOUTH_INDIAN,
//     customizationList: CUSTOMIZE_LIST,
//     isVeg: true,
//     stock: 0,
//   ),
//   FoodModel(
//     id: '4',
//     name: 'Special A2B Meal',
//     description: 'Mix of over 15 items',
//     image:
//         'https://imgmedia.lbb.in/media/2017/08/599bf9be632a0d4bbcf0d62f_599aca1a7cba110dead973ba_1503394238291.jpg',
//     amount: 100.0,
//     category: FoodCategory.SOUTH_INDIAN,
//     customizationList: [],
//     isVeg: true,
//     stock: 5,
//   ),
//   FoodModel(
//     id: '5',
//     name: 'Chicken 65',
//     description: 'North India tadka special',
//     image:
//         'https://recipe52.com/wp-content/uploads/2019/04/Chicken-65-1-of-1-2-480x270.jpg',
//     amount: 80.0,
//     category: FoodCategory.NORTH_INDIAN,
//     customizationList: [],
//     isVeg: false,
//     stock: 5,
//   ),
//   FoodModel(
//     id: '6',
//     name: 'Stuffed Kulcha',
//     description: 'Direct from the kitchen of Punjab',
//     image:
//         'https://www.archanaskitchen.com/images/archanaskitchen/1-Author/Richa_Gupta/Stuffed_Veggie_Kulcha.jpg',
//     amount: 90.0,
//     category: FoodCategory.NORTH_INDIAN,
//     customizationList: CUSTOMIZE_LIST,
//     isVeg: true,
//     stock: 5,
//   ),
//   FoodModel(
//     id: '7',
//     name: 'Veg Noodles',
//     description: 'Fried with fresh veggies',
//     image:
//         'https://thechutneylife.com/wp-content/uploads/2017/09/Veg-Hakka-Noodles-The-Chutney-Life-4.jpg',
//     amount: 55.0,
//     category: FoodCategory.CHINESE,
//     customizationList: [],
//     isVeg: true,
//     stock: 10,
//   ),
//   FoodModel(
//     id: '8',
//     name: 'Baby Corn Golden',
//     description: 'Yumms of Indo-Chineese tradition',
//     image:
//         'https://www.bbcgoodfoodme.com/assets/recipes/24543/original/f385634a59f6d2f7fa3aeb6d8d570dcb.jpg',
//     amount: 50.0,
//     category: FoodCategory.CHINESE,
//     customizationList: CUSTOMIZE_LIST,
//     isVeg: true,
//     stock: 0,
//   ),
//   FoodModel(
//     id: '9',
//     name: 'Dahi Papdi',
//     description: 'Taste and Mood changer!',
//     image:
//         'https://img-global.cpcdn.com/recipes/4f073be5cfbb7490/1200x630cq70/photo.jpg',
//     amount: 40.0,
//     category: FoodCategory.CHAAT,
//     customizationList: [],
//     isVeg: true,
//     stock: 0,
//   ),
//   FoodModel(
//     id: '10',
//     name: 'Pani Puri',
//     description: 'Mouth watering snack',
//     image:
//         'https://upload.wikimedia.org/wikipedia/commons/5/53/Panipuri%2C_Golgappa%2C_Phuchka.jpg',
//     amount: 30.0,
//     category: FoodCategory.CHAAT,
//     customizationList: [],
//     isVeg: true,
//     stock: 5,
//   ),
// ];
