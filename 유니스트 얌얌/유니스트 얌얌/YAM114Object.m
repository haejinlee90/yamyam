//
//  YAM114Object.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 15..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAM114Object.h"

#define     kSection    @"section"
#define     kName       @"name"
#define     kId         @"id"
#define     kPosition   @"position"
#define     kPhoneNum   @"phoneNum"
#define     kEmail      @"email"
#define     kLocation   @"location"

@implementation YAM114Object
@synthesize section;
@synthesize name;
@synthesize id;
@synthesize position;
@synthesize phoneNum;
@synthesize email;
@synthesize location;



+ (void)set:(NSDictionary *)dict Key1:(NSString *)key1 Key2:(NSString *)key2 To:(YAM114Object *)object {
    NSArray *array = [dict objectForKey:key2];
//    NSLog(@"array count: %d", array.count);
//        if(array.count == 1){
//            object.section = key1;
//            object.name = key2;
//            object.id = nil;
//            object.position = nil;
//            object.phoneNum = [array objectAtIndex:0];
//            object.email = nil;
//            object.location = nil;
//        }else if(array.count == 4) {
//            object.section = key1;
//            object.name = key2;
//            object.id = [array objectAtIndex:0];
//            object.position = [array objectAtIndex:1];
//            object.phoneNum = [array objectAtIndex:2];
//            object.email = [array objectAtIndex:3];
//            object.location = nil;
//        }else if(array.count == 5) {
            object.section = key1;
            object.name = key2;
            object.id = [array objectAtIndex:0];
            object.position = [array objectAtIndex:1];
            object.phoneNum = [array objectAtIndex:2];
            object.email = [array objectAtIndex:3];
            object.location = [array objectAtIndex:4];
//        }
}

- (id)initWithObject:(YAM114Object *)object {
    self = [super init];
    if(self)
        self = object;
    
    return self;
    
}

+ (void) sort:(NSMutableArray *)array
{
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] compare:[obj2 name]];
    }];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:section forKey:kSection];
    [aCoder encodeObject:name forKey:kName];
    [aCoder encodeObject:id forKey:kId];
    [aCoder encodeObject:position forKey:kPosition];
    [aCoder encodeObject:phoneNum forKey:kPhoneNum];
    [aCoder encodeObject:email forKey:kEmail];
    [aCoder encodeObject:location forKey:kLocation];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.section = [aDecoder decodeObjectForKey:kSection];
        self.name = [aDecoder decodeObjectForKey:kName];
        self.id = [aDecoder decodeObjectForKey:kId];
        self.position = [aDecoder decodeObjectForKey:kPosition];
        self.phoneNum = [aDecoder decodeObjectForKey:kPhoneNum];
        self.email = [aDecoder decodeObjectForKey:kEmail];
        self.location = [aDecoder decodeObjectForKey:kLocation];
    }
    
    return self;
}

@end
