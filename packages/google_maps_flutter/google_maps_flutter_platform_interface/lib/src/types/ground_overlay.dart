import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

@immutable
class GroundOverlayId extends MapsObjectId<GroundOverlay> {
  const GroundOverlayId(String value) : super(value);
}

@immutable
class GroundOverlay implements MapsObject<GroundOverlay> {
  const GroundOverlay({
    required this.groundOverlayId,
    required this.center,
    required this.heightInMeters,
    required this.widthInMeters,
    required this.imgUrl,
    this.transparency = 0.3,
  });

  final int heightInMeters;
  final int widthInMeters;
  final LatLng center;
  final GroundOverlayId groundOverlayId;
  final double transparency;
  final String imgUrl;

  @override
  GroundOverlay clone() {
    return GroundOverlay(
      groundOverlayId: groundOverlayId,
      center: center,
      heightInMeters: heightInMeters,
      widthInMeters: widthInMeters,
      imgUrl: imgUrl,
      transparency: transparency,
    );
  }

  @override
  GroundOverlayId get mapsId => groundOverlayId;

  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('groundOverlayId', groundOverlayId);
    addIfPresent('center', center);
    addIfPresent('height', heightInMeters);
    addIfPresent('width', widthInMeters);
    addIfPresent('imgUrl', imgUrl);
    addIfPresent('transparency', transparency);

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GroundOverlay &&
        groundOverlayId == other.groundOverlayId &&
        center == other.center &&
        widthInMeters == other.widthInMeters &&
        heightInMeters == other.heightInMeters &&
        imgUrl == other.imgUrl &&
        transparency == other.transparency;
  }

  @override
  int get hashCode => groundOverlayId.hashCode;

  @override
  String toString() {
    return 'GroundOverlay{groundOverlayId: $groundOverlayId, center: $center, '
        'imgUrl: $imgUrl, height: $heightInMeters, width: $widthInMeters, transparency: $transparency}';
  }
}
