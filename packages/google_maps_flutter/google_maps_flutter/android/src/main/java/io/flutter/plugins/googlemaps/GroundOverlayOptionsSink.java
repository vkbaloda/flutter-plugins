package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.LatLngBounds;

public interface GroundOverlayOptionsSink {
    void setTransparency(float transparency);

    void setImgUrl(String imgUrl);

    void setLatLngBounds(LatLngBounds latLngBounds);

    void setImage(BitmapDescriptor bitmapDescriptor);
}
