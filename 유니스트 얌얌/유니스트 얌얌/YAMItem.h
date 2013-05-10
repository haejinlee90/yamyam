//
//  YAMItem.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 13..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YAMItem : NSObject <NSCoding>
@property NSString* restID;
@property NSString* rtype;
@property NSString* name;
@property NSString* phonenum;
@property NSString* star;
@property NSString* join_num;

+ (void)convert:(NSDictionary *)dict toItem:(YAMItem *)item;

@end
