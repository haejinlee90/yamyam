//
//  YAMDeliveryReviewViewController.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 19..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAMWriteReviewViewController.h"
#import "EGORefreshTableHeaderView.h"

@protocol completeReview <NSObject>
- (void) completeReviewWithStar:(NSString *)star andJoin:(NSString *)join;
@end

@interface YAMDeliveryReviewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate ,WriteReviewDelegate, EGORefreshTableHeaderDelegate>
{
    id reviewDelegate;
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    BOOL _reloading;
}

@property (strong, nonatomic) NSString *currentDeliveryId;
@property (strong, nonatomic) NSString *currentDeliveryStar;
@property (strong, nonatomic) NSString *currentTitle;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *arrayOfObjects;
@property (strong, nonatomic) NSString *last_id;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *review_content;
@property (strong, nonatomic) NSString *star_point;
@property (nonatomic) id<completeReview> reviewDelegate;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL ascending;
- (IBAction) buttonPressed:(id)sender;
- (IBAction)gotoReview:(id)sender;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
