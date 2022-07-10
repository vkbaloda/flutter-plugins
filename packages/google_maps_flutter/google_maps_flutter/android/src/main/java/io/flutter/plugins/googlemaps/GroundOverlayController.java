package io.flutter.plugins.googlemaps;

import android.graphics.Bitmap;
import android.os.StrictMode;

import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.LatLngBounds;

public class GroundOverlayController implements GroundOverlayOptionsSink{
    private final GroundOverlay groundOverlay;
    private final String googleMapsGroundOverlayId;

    GroundOverlayController(GroundOverlay groundOverlay){
        this.groundOverlay = groundOverlay;
        this.googleMapsGroundOverlayId = groundOverlay.getId();
    }

    void remove(){
        groundOverlay.remove();
    }

    String getGoogleMapsGroundOverlayId() {
        return googleMapsGroundOverlayId;
    }


    @Override
    public void setTransparency(float transparency) {
        groundOverlay.setTransparency(transparency);
    }

    @Override
    public void setImgUrl(String imgUrl) {
//        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder()
//                .permitAll().build();
//        StrictMode.setThreadPolicy(policy);

        Bitmap bitmap = Convert.getBitmapFromUrl(imgUrl);
        if(bitmap == null) return;
        groundOverlay.setImage(BitmapDescriptorFactory.fromBitmap(bitmap));
    }

    @Override
    public void setLatLngBounds(LatLngBounds latLngBounds) {
        groundOverlay.setPositionFromBounds(latLngBounds);
    }
}
