// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GoogleMapController.h"

NS_ASSUME_NONNULL_BEGIN

// Defines groundOverlay controllable by Flutter.
@interface FLTGoogleMapGroundOverlayController : NSObject
- (instancetype)initGroundOverlayWithBounds:(GMSCoordinateBounds *)bounds
                                      image:(nullable UIImage *)image
                                 identifier:(NSString *)identifier
                                    mapView:(GMSMapView *)mapView;
- (void)removeGroundOverlay;
@end

@interface FLTGroundOverlaysController : NSObject
- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)methodChannel
                              mapView:(GMSMapView *)mapView
                            registrar:(NSObject<FlutterPluginRegistrar> *)registrar;
- (void)addGroundOverlays:(NSArray *)groundOverlaysToAdd;
- (void)changeGroundOverlays:(NSArray *)groundOverlaysToChange;
- (void)removeGroundOverlaysWithIdentifiers:(NSArray *)identifiers;
@end

NS_ASSUME_NONNULL_END
