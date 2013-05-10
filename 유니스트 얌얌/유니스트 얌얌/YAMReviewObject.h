//
//  YAMReviewObject.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 20..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAMReviewObject : NSObject
@property (strong, nonatomic) NSString *review_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *star;

- (void)setDict:(NSDictionary *)dict to:(YAMReviewObject *)object;

@end
