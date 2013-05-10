//
//  YAMDeliveryViewController.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 13..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAMDeliverySelectViewController.h"
#import "YAMAppDelegate.h"
#import "YAMItem.h"
#import "YAMDeliveryReviewViewController.h"


@interface YAMDeliveryViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
NSURLConnectionDataDelegate,
NSURLConnectionDelegate,
completeReview>

//@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) YAMDeliverySelectViewController *selectVC;
@property (strong, nonatomic) YAMAppDelegate *delegate;
@property (strong, nonatomic) NSMutableArray *allRest;
@property (strong, nonatomic) NSMutableArray *allSections;
@property (strong, nonatomic) NSMutableDictionary *sectionsDict;
@property (strong, nonatomic) NSArray *sectionsIndex;
@property (strong, nonatomic) NSString *selectedSection;
@property NSInteger selectedSectionIndex;
@property (strong, nonatomic) NSMutableArray *favourArray;
@property (strong, nonatomic) YAMItem *currentObject;
@property int consist;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
- (IBAction)closeView;
- (IBAction) goBack;
- (IBAction)callPhone:(id)sender;
@end

