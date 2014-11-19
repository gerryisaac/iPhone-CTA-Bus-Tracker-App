//
//  busAnnotation.m
//  ColorMyWorld
//
//  Created by Gerard Isaac on 8/5/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

#import "busAnnotation.h"

@interface busAnnotation()

@end

@implementation busAnnotation

@synthesize coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c {
	
    if (self) {
    
        coordinate = c;
    
    }
    return self;
}

- (NSString *)subtitle{
	return nil;
}

- (NSString *)title{
	return nil;
}

@end
