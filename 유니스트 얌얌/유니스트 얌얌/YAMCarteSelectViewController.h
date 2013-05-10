//
//  YAMCarteSelectViewController.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 17..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAMCarteSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString *today;
@property (strong, nonatomic) NSString *tomorrow;
@property (strong, nonatomic) NSString *dayAfterTomorrow;
@property (strong, nonatomic) UITableView *table;
@end
