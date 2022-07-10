import 'package:google_maps_flutter_platform_interface/src/types/ground_overlay.dart';
import 'maps_object.dart';

/// Converts an [Iterable] of GroundOverlay in a Map of GroundOverlayId -> GroundOverlay.
Map<GroundOverlayId, GroundOverlay> keyByGroundOverlayId(
    Iterable<GroundOverlay> groundOverlays) {
  return keyByMapsObjectId<GroundOverlay>(groundOverlays)
      .cast<GroundOverlayId, GroundOverlay>();
}

/// Converts a Set of GroundOverlays into something serializable in JSON.
Object serializeGroundOverlaySet(Set<GroundOverlay> groundOverlays) {
  return serializeMapsObjectSet(groundOverlays);
}
