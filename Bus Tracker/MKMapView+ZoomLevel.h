//
//  MKMapView+ZoomLevel.h
//  ColorMyWorld
//
//  Created by Gerard Isaac on 8/5/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
