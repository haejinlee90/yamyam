//
//  YAMDeliverySelectViewController.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 13..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAMDeliverySelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSDictionary *Lists;
@property (strong, nonatomic) NSArray *rest_types;

@end
