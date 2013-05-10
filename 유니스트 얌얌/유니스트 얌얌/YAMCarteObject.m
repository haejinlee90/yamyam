//
//  YAMCarteObject.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 17..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMCarteObject.h"

@implementation YAMCarteObject
@synthesize corner;
@synthesize item;

- (id)init {
    self = [super init];
    
    return self;
}

- (id)initWithObject:(YAMCarteObject *)object {
    self = [super init];
    if(self)
        self = object;
    return object;
}

- (void)setDict:(NSDictionary *)dict To:(YAMCarteObject *)object {
    self.corner = [dict objectForKey:@"corner"];
    self.item = [dict objectForKey:@"item"];
}
@end
