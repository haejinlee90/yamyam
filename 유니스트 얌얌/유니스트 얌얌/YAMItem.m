//
//  YAMItem.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 13..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMItem.h"

#define     kRestID     @"restID"
#define     kRtype      @"rtype"
#define     kName       @"name"
#define     kPhonenum   @"phonenum"
#define     kStar       @"star"
#define     kJoinNum    @"join_num"

@implementation YAMItem
@synthesize restID;
@synthesize rtype;
@synthesize name;
@synthesize phonenum;
@synthesize star;
@synthesize join_num;

+ (void)convert:(NSDictionary *)dict toItem:(YAMItem *)item
{
    item.restID = [dict objectForKey:@"id"];
    item.rtype = [dict objectForKey:@"rtype"];
    item.name = [dict objectForKey:@"name"];
    item.phonenum = [dict objectForKey:@"phonenum"];
    item.star = [dict objectForKey:@"star"];
    item.join_num = [dict objectForKey:@"join_num"];
}



#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:restID forKey:kRestID];
    [aCoder encodeObject:rtype forKey:kRtype];
    [aCoder encodeObject:name forKey:kName];
    [aCoder encodeObject:phonenum forKey:kPhonenum];
    [aCoder encodeObject:star forKey:kStar];
    [aCoder encodeObject:join_num forKey:kJoinNum];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.restID = [aDecoder decodeObjectForKey:kRestID];
        self.rtype = [aDecoder decodeObjectForKey:kRtype];
        self.name = [aDecoder decodeObjectForKey:kName];
        self.phonenum = [aDecoder decodeObjectForKey:kPhonenum];
        self.star = [aDecoder decodeObjectForKey:kStar];
        self.join_num = [aDecoder decodeObjectForKey:kJoinNum];
    }
    
    return self;
}


@end
