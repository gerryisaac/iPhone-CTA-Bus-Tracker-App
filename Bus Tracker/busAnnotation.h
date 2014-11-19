//
//  busAnnotation.h
//  ColorMyWorld
//
//  Created by Gerard Isaac on 8/5/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface busAnnotation: NSObject <MKAnnotation> {
	
    CLLocationCoordinate2D coordinate;

}

-(id)initWithCoordinate:(CLLocationCoordinate2D)c;

@end
