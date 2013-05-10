//
//  YAMCarteObject.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 17..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAMCarteObject : NSObject
@property (strong, nonatomic) NSString *corner;
@property (strong, nonatomic) NSString *item;

- (id)init;
- (id)initWithObject:(YAMCarteObject *)object;
- (void)setDict:(NSDictionary *)dict To:(YAMCarteObject *)object;
@end
