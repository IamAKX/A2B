import 'dart:convert';

import 'package:singlestore/models/homePageGimages.dart';

class NotificationGimages {
  HomePageGimages gimage;
  int heightInPx;
  NotificationGimages({
    this.gimage,
    this.heightInPx,
  });

  NotificationGimages copyWith({
    HomePageGimages gimage,
    int heightInPx,
  }) {
    return NotificationGimages(
      gimage: gimage ?? this.gimage,
      heightInPx: heightInPx ?? this.heightInPx,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gimage': gimage?.toMap(),
      'heightInPx': heightInPx,
    };
  }

  static NotificationGimages fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return NotificationGimages(
      gimage: HomePageGimages.fromMap(map['gimage']),
      heightInPx: map['heightInPx'],
    );
  }

  String toJson() => json.encode(toMap());

  static NotificationGimages fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'NotificationGimages(gimage: $gimage, heightInPx: $heightInPx)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is NotificationGimages &&
      o.gimage == gimage &&
      o.heightInPx == heightInPx;
  }

  @override
  int get hashCode => gimage.hashCode ^ heightInPx.hashCode;
}
