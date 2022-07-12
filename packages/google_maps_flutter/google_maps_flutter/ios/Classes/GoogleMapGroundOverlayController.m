#import "GoogleMapGroundOverlayController.h"
#import "FLTGoogleMapJSONConversions.h"

@interface FLTGoogleMapGroundOverlayController ()

@property(strong, nonatomic) GMSGroundOverlay *groundOverlay;
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGoogleMapGroundOverlayController

- (instancetype)initGroundOverlayWithBounds:(GMSCoordinateBounds *)bounds
                                      image:(UIImage *)image
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
  NSArray *icon = data[@"icon"];
  if (icon && icon != (id)[NSNull null]) {
    UIImage *image = [FLTGoogleMapJSONConversions extractIconFromData:icon registrar:registrar];
    [self setImage:image];
  }
  NSArray *bounds = data[@"latLngBounds"];
  if (bounds && bounds != (id)[NSNull null]) {
    [self setBounds:[FLTGoogleMapJSONConversions coordinateBoundsFromLatLongs:bounds]];
  }
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
    UIImage *image = [FLTGoogleMapJSONConversions extractIconFromData:groundOverlay registrar: self.registrar];
    FLTGoogleMapGroundOverlayController *controller =
        [[FLTGoogleMapGroundOverlayController alloc] initGroundOverlayWithBounds:bounds
                                                                           image:image
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
