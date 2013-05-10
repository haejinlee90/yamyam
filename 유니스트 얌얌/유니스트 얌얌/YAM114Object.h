//
//  YAM114Object.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 15..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAM114Object : NSObject <NSCoding>

@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *position;
@property (strong, nonatomic) NSString *phoneNum;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *location;


- (id)initWithObject:(YAM114Object *)object;
+ (void)set:(NSDictionary *)dict Key1:(NSString *)key1 Key2:(NSString *)key2 To:(YAM114Object *)object;
+ (void) sort:(NSMutableArray *)array;
@end
