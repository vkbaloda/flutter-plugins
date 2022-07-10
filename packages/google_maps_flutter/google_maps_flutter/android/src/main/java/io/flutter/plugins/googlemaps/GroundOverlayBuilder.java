package io.flutter.plugins.googlemaps;

import android.graphics.Bitmap;
import android.os.StrictMode;

import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.GroundOverlayOptions;
import com.google.android.gms.maps.model.LatLngBounds;

public class GroundOverlayBuilder implements GroundOverlayOptionsSink{
    private  final GroundOverlayOptions groundOverlayOptions;

    GroundOverlayBuilder(){groundOverlayOptions = new GroundOverlayOptions();}

    GroundOverlayOptions build(){
        return groundOverlayOptions;
    }

    @Override
    public void setTransparency(float transparency) {
        groundOverlayOptions.transparency(transparency);
    }

    @Override
    public void setImgUrl(String imgUrl) {
//        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder()
//                .permitAll().build();
//        StrictMode.setThreadPolicy(policy);

        Bitmap bitmap = Convert.getBitmapFromUrl(imgUrl);
        if(bitmap == null) return;
        groundOverlayOptions.image(BitmapDescriptorFactory.fromBitmap(bitmap));
    }

    @Override
    public void setLatLngBounds(LatLngBounds latLngBounds) {
        groundOverlayOptions.positionFromBounds(latLngBounds);
    }
}
