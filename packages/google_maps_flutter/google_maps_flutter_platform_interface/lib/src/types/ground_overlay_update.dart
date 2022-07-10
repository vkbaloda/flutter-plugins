import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

/// [GroundOverlay] update events to be applied to the [GoogleMap].
///
/// Used in [GoogleMapController] when the map is updated.
class GroundOverlayUpdates extends MapsObjectUpdates<GroundOverlay> {
  GroundOverlayUpdates.from(
      Set<GroundOverlay> previous, Set<GroundOverlay> current)
      : super.from(previous, current, objectName: 'groundOverlay');

  Set<GroundOverlay> get groundOverlaysToAdd => objectsToAdd;

  Set<GroundOverlayId> get groundOverlayIdsToRemove =>
      objectIdsToRemove.cast<GroundOverlayId>();

  Set<GroundOverlay> get groundOverlaysToChange => objectsToChange;
}
