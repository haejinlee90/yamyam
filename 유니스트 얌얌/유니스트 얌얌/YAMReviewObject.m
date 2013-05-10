//
//  YAMReviewObject.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 20..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMReviewObject.h"

@implementation YAMReviewObject
@synthesize review_id;
@synthesize user_name;
@synthesize date;
@synthesize content;
@synthesize star;

- (void)setDict:(NSDictionary *)dict to:(YAMReviewObject *)object
{
    object.review_id = [dict objectForKey:@"id"];
    object.user_name = [dict objectForKey:@"user_name"];
    object.date = [dict objectForKey:@"date"];
    object.content = [dict objectForKey:@"content"];
    object.star = [dict objectForKey:@"star"];
}
@end
