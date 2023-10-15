import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class WebMapMarker extends Clusterable {
  final String id;
  String icon;
  ValueChanged<String> onTap;

  WebMapMarker({
    @required this.id,
    @required this.icon,
    @required this.onTap,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: id,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );
}
