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
    required this.latLngBounds,
    this.imgUrl,
    this.image,
    this.transparency = 0.3,
  }) : assert(imgUrl != null || image != null);

  final LatLngBounds latLngBounds;
  final GroundOverlayId groundOverlayId;
  final double transparency;
  final String? imgUrl;
  final BitmapDescriptor? image;

  GroundOverlay copyWith({
    GroundOverlayId? groundOverlayId,
    LatLngBounds? latLngBounds,
    String? imgUrl,
    BitmapDescriptor? image,
    double? transparency = 0.3,
  }) {
    return GroundOverlay(
      groundOverlayId: groundOverlayId ?? this.groundOverlayId,
      latLngBounds: latLngBounds ?? this.latLngBounds,
      image: image ?? this.image,
      imgUrl: imgUrl ?? this.imgUrl,
      transparency: transparency ?? this.transparency,
    );
  }

  @override
  GroundOverlay clone() {
    return GroundOverlay(
      groundOverlayId: groundOverlayId,
      latLngBounds: latLngBounds,
      imgUrl: imgUrl,
      image: image,
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

    addIfPresent('groundOverlayId', groundOverlayId.value);
    addIfPresent('latLngBounds', <List<double>>[
      <double>[
        latLngBounds.southwest.latitude,
        latLngBounds.southwest.longitude
      ],
      <double>[
        latLngBounds.northeast.latitude,
        latLngBounds.northeast.longitude
      ],
    ]);
    addIfPresent('imgUrl', imgUrl);
    addIfPresent('image', image?.toJson());
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
        latLngBounds == other.latLngBounds &&
        imgUrl == other.imgUrl &&
        image == other.image &&
        transparency == other.transparency;
  }

  @override
  int get hashCode => groundOverlayId.hashCode;

  @override
  String toString() {
    return 'GroundOverlay{groundOverlayId: $groundOverlayId, imgUrl: $imgUrl'
        'image: ${image?.toString()}, latLngBounds: $latLngBounds, transparency: $transparency}';
  }
}
