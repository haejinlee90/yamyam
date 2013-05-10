//
//  YAM114SelectViewController.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 14..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAM114SelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSDictionary *Lists;
@property (strong, nonatomic) NSArray *sections;


@end
