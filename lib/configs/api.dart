class API {
  // static String JWT_AUTH =
  //     'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIrOTE5ODA0OTQ1MTIyIiwiZXhwIjoxNjAxMzkzMzE5LCJpYXQiOjE1OTg4MDEzMTl9.MHJAzIFDx11_A6AaKloypq45LQq2JPNO_P5lSpU80DU';
  static String JWT_AUTH = '';
  static final String BASE_URL =
      'http://singlestore.us-east-2.elasticbeanstalk.com';
  static String STORE_KEY = '';
  static final String COMMON_STORE_KEY =
      'jhdiuhf843tcu532948.dlvklefkbnvjzcliqaoifo5520359kjbgthvmxcksd.poctowiu5869buvoxthdukrtdcxpra.xlemikchvnrivi34095984cw';

  static final String FETCH_HOME_DATA = BASE_URL + '/api/app/singlestore/home';
  static final String FETCH_MENU_BY_CATEGORY_ID = BASE_URL + '/api/categories/';
  static final String SAVE_TO_CART =
      BASE_URL + '/api/app/singlestore/updateOrderAndgetAppCart';

  static final String FETCH_ALL_PROMOCODE = BASE_URL + '/api/promocodes';

  static final String FEED_BACK = BASE_URL + '/app/helperpages/feedback';
  static final String FAQ = BASE_URL + '/app/helperpages/faqs';
  static final String TandC = BASE_URL + '/app/helperpages/tnc';
  static final String PRIVACY_POLICY =
      BASE_URL + '/app/helperpages/privacypolicy';

  static final String REWARD_POLICY =
      BASE_URL + '/app/helperpages/rewardsPolicy?storeKey=' + STORE_KEY;

  static final String LOAD_ORDER = BASE_URL + '/api/singlestore/orders/';
  static final String ORDER_SUMMARY = BASE_URL + '/api/singlestore/order/';
  static final String REORDER =
      BASE_URL + '/api/app/singlestore/reOrderAppCart';
}
