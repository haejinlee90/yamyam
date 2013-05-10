//
//  YAMBusViewController.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 14..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAMBusViewController : UIViewController <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) NSDictionary *busTime;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

- (IBAction)goBack;
@end
