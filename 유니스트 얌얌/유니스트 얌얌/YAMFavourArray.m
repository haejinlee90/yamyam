//
//  YAMFavourArray.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 14..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMFavourArray.h"

#define kFavourArray @"FavourArray"

@implementation YAMFavourArray 
@synthesize favourArray;

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.favourArray forKey:kFavourArray];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.favourArray = [aDecoder decodeObjectForKey:kFavourArray];
    }
    
    return self;
}

#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    YAMFavourArray *copy = [[[self class] allocWithZone:zone] init];
    copy.favourArray = [self.favourArray copyWithZone:zone];
    return copy;
}

@end
