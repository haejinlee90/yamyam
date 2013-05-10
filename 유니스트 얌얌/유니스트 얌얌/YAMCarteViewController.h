//
//  YAMCarteViewController.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 17..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAMCarteViewController : UIViewController <NSURLConnectionDataDelegate, NSURLConnectionDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UILabel *HeaderLabel;

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *rtype;
@property (strong, nonatomic) NSMutableArray *ArrayOfObjects;
@property (strong, nonatomic) NSString *labelDate;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
- (void)loadData;
- (IBAction)goBack:(id)sender;
- (IBAction)buttonPressed:(id)sender;
@end
