#import "GoogleMapGroundOverlayController.h"
#import "FLTGoogleMapJSONConversions.h"

@interface FLTGoogleMapGroundOverlayController ()

@property(strong, nonatomic) GMSGroundOverlay *groundOverlay;
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGoogleMapGroundOverlayController

- (instancetype)initGroundOverlayWithBounds:(GMSCoordinateBounds *)bounds
                                      image:(nullable UIImage *)image
                                 identifier:(NSString *)identifier
                                    mapView:(GMSMapView *)mapView {
  self = [super init];
  if (self) {
    _groundOverlay = [GMSGroundOverlay groundOverlayWithBounds:bounds icon:image];
    _mapView = mapView;
    _groundOverlay.userData = @[ identifier ];
  }
  return self;
}

- (void)removeGroundOverlay {
  self.groundOverlay.map = nil;
}

- (void)setTransparency:(float)transparency {
  self.groundOverlay.opacity = transparency;
}

- (void)setImage:(UIImage *)image {
  self.groundOverlay.icon = image;
}

- (void)setBounds:(GMSCoordinateBounds *)bounds {
  self.groundOverlay.bounds = bounds;
}

- (void)interpretGroundOverlayOptions:(NSDictionary *)data
                     registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  NSNumber *transparency = data[@"transparency"];
  if (transparency && transparency != (id)[NSNull null]) {
    [self setTransparency:[transparency floatValue]];
  }
  NSArray *icon = data[@"image"];
  if (icon && icon != (id)[NSNull null]) {
    UIImage *image = [self extractIconFromData:icon registrar:registrar];
    [self setImage:image];
  }
  NSArray *bounds = data[@"latLngBounds"];
  if (bounds && bounds != (id)[NSNull null]) {
    [self setBounds:[FLTGoogleMapJSONConversions coordinateBoundsFromLatLongs:bounds]];
  }
  self.groundOverlay.map = self.mapView;
}

- (UIImage *)extractIconFromData:(NSArray *)iconData
                       registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  UIImage *image;
  if ([iconData.firstObject isEqualToString:@"defaultMarker"]) {
      CGFloat hue = (iconData.count == 1) ? 0.0f : [iconData[1] doubleValue];
      image = [GMSMarker markerImageWithColor:[UIColor colorWithHue:hue / 360.0
                                                         saturation:1.0
                                                         brightness:0.7
                                                              alpha:1.0]];
    } else if ([iconData.firstObject isEqualToString:@"fromAsset"]) {
    if (iconData.count == 2) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
    } else {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]
                                                   fromPackage:iconData[2]]];
    }
  } else if ([iconData.firstObject isEqualToString:@"fromAssetImage"]) {
    if (iconData.count == 3) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
      id scaleParam = iconData[2];
      image = [self scaleImage:image by:scaleParam];
    } else {
      NSString *error =
          [NSString stringWithFormat:@"'fromAssetImage' should have exactly 3 arguments. Got: %lu",
                                     (unsigned long)iconData.count];
      NSException *exception = [NSException exceptionWithName:@"InvalidBitmapDescriptor"
                                                       reason:error
                                                     userInfo:nil];
      @throw exception;
    }
  } else if ([iconData[0] isEqualToString:@"fromBytes"]) {
    if (iconData.count == 2) {
      @try {
        FlutterStandardTypedData *byteData = iconData[1];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        image = [UIImage imageWithData:[byteData data] scale:screenScale];
      } @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"InvalidByteDescriptor"
                                       reason:@"Unable to interpret bytes as a valid image."
                                     userInfo:nil];
      }
    } else {
      NSString *error = [NSString
          stringWithFormat:@"fromBytes should have exactly one argument, the bytes. Got: %lu",
                           (unsigned long)iconData.count];
      NSException *exception = [NSException exceptionWithName:@"InvalidByteDescriptor"
                                                       reason:error
                                                     userInfo:nil];
      @throw exception;
    }
  }

  return image;
}

- (UIImage *)scaleImage:(UIImage *)image by:(id)scaleParam {
  double scale = 1.0;
  if ([scaleParam isKindOfClass:[NSNumber class]]) {
    scale = [scaleParam doubleValue];
  }
  if (fabs(scale - 1) > 1e-3) {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * scale)
                         orientation:(image.imageOrientation)];
  }
  return image;
}

@end

@interface FLTGroundOverlaysController ()

@property(strong, nonatomic) NSMutableDictionary *groundOverlayIdentifierToController;
@property(strong, nonatomic) FlutterMethodChannel *methodChannel;
@property(weak, nonatomic) NSObject<FlutterPluginRegistrar> *registrar;
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGroundOverlaysController

- (instancetype)initWithMethodChannel:(FlutterMethodChannel *)methodChannel
                              mapView:(GMSMapView *)mapView
                            registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  self = [super init];
  if (self) {
    _methodChannel = methodChannel;
    _mapView = mapView;
    _groundOverlayIdentifierToController = [[NSMutableDictionary alloc] init];
    _registrar = registrar;
  }
  return self;
}

- (void)addGroundOverlays:(NSArray *)groundOverlaysToAdd {
  for (NSDictionary *groundOverlay in groundOverlaysToAdd) {
    GMSCoordinateBounds *bounds = [FLTGroundOverlaysController getBounds:groundOverlay];
    NSString *identifier = groundOverlay[@"groundOverlayId"];
    //UIImage *image = [FLTGoogleMapJSONConversions extractIconFromData:groundOverlay registrar: self.registrar];
    FLTGoogleMapGroundOverlayController *controller =
        [[FLTGoogleMapGroundOverlayController alloc] initGroundOverlayWithBounds:bounds
                                                                           image:NULL//image
                                                                      identifier:identifier
                                                                         mapView:self.mapView];
    [controller interpretGroundOverlayOptions:groundOverlay registrar:self.registrar];
    self.groundOverlayIdentifierToController[identifier] = controller;
  }
}

- (void)changeGroundOverlays:(NSArray *)groundOverlaysToChange {
  for (NSDictionary *groundOverlay in groundOverlaysToChange) {
    NSString *identifier = groundOverlay[@"groundOverlayId"];
    FLTGoogleMapGroundOverlayController *controller = self.groundOverlayIdentifierToController[identifier];
    if (!controller) {
      continue;
    }
    [controller interpretGroundOverlayOptions:groundOverlay registrar:self.registrar];
  }
}

- (void)removeGroundOverlaysWithIdentifiers:(NSArray *)identifiers {
  for (NSString *identifier in identifiers) {
    FLTGoogleMapGroundOverlayController *controller = self.groundOverlayIdentifierToController[identifier];
    if (!controller) {
      continue;
    }
    [controller removeGroundOverlay];
    [self.groundOverlayIdentifierToController removeObjectForKey:identifier];
  }
}

+ (GMSCoordinateBounds *)getBounds:(NSDictionary *)groundOverlay {
  NSArray *bounds = groundOverlay[@"latLngBounds"];
  return [FLTGoogleMapJSONConversions coordinateBoundsFromLatLongs:bounds];
}

@end
