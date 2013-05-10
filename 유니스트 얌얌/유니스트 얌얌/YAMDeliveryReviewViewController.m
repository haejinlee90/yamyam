//
//  YAMDeliveryReviewViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 19..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMDeliveryReviewViewController.h"
#import "AFJSONRequestOperation.h"
#import "YAMReviewObject.h"
#import "YAMWriteReviewViewController.h"
#import "MBProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface YAMDeliveryReviewViewController ()

@end

@implementation YAMDeliveryReviewViewController
@synthesize currentDeliveryId;
@synthesize currentDeliveryStar;
@synthesize currentTitle;
@synthesize table;
@synthesize arrayOfObjects;
@synthesize last_id;
@synthesize user_name;
@synthesize review_content;
@synthesize star_point;
@synthesize titleLabel;

static NSString *kReviewTableCell = @"reviewTableCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    [self.table registerNib:[UINib nibWithNibName:@"YAMDeliveryReviewTableCell" bundle:nil] forCellReuseIdentifier:kReviewTableCell];
    self.titleLabel.text = self.currentTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://lejong0106.cafe24.com/php/get_review_data.php?delivery_id=%@", self.currentDeliveryId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^
                                         (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray *array = [JSON objectForKey:@"reviewLists"];
        self.arrayOfObjects = [[NSMutableArray alloc] init];
        for(int i=0; i<array.count; i++) {
            YAMReviewObject *object = [[YAMReviewObject alloc] init];
            [object setDict:[array objectAtIndex:i] to:object];
            [arrayOfObjects addObject:object];
            [self.table reloadData];
        }
        NSLog(@"test: %@", arrayOfObjects);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    [operation start];
    
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc]
                                           initWithFrame:CGRectMake(0.0f,
                                                                    0.0f - self.table.bounds.size.height,
                                                                    self.view.frame.size.width,
                                                                    self.table.bounds.size.height)];
		view.delegate = self;
		[self.table addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) buttonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];  // 현재 모달로 띄워진 뷰 컨트롤러를 닫음
}

- (IBAction)gotoReview:(id)sender {
    YAMWriteReviewViewController *writeVC = [[YAMWriteReviewViewController alloc] initWithNibName:@"YAMWriteReviewViewController" bundle:nil];
    writeVC.myDelegate = self;
    writeVC.deliveryId = currentDeliveryId;
    
    [writeVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:writeVC animated:YES];
}

- (void)writeReviewViewControllerDismissedAndSendStar:(NSString *)star JoinNum:(NSString *)join {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"http://lejong0106.cafe24.com/php/get_review_data.php?delivery_id=%@",
                   self.currentDeliveryId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^
                                         (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray *array = [JSON objectForKey:@"reviewLists"];
        self.arrayOfObjects = [[NSMutableArray alloc] init];
        for(int i=0; i<array.count; i++) {
            YAMReviewObject *object = [[YAMReviewObject alloc] init];
            [object setDict:[array objectAtIndex:i] to:object];
            [arrayOfObjects addObject:object];
            [self.table reloadData];
        }
        [self.reviewDelegate completeReviewWithStar:star andJoin:join];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    [operation start];
}

- (void) showMore {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"http://lejong0106.cafe24.com/php/get_review_data.php?delivery_id=%@&last_id=%@",
                   self.currentDeliveryId, self.last_id]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^
                                         (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray *array = [JSON objectForKey:@"reviewLists"];
        for(int i=0; i<array.count; i++) {
            YAMReviewObject *object = [[YAMReviewObject alloc] init];
            [object setDict:[array objectAtIndex:i] to:object];
            [self.arrayOfObjects addObject:object];
            [self.table reloadData];
        }
        NSLog(@"------------------");
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    [operation start];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayOfObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    YAMReviewObject *currentObject = [self.arrayOfObjects objectAtIndex:row];

    NSString *cellIdentifier = kReviewTableCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.userInteractionEnabled = NO;
    
    UILabel *userName = (UILabel *)[cell viewWithTag:11];
    [userName sizeToFit];
    UILabel *date = (UILabel *)[cell viewWithTag:12];
    [date sizeToFit];
    
    CGRect dateFrame = date.frame;
    dateFrame.origin.x = userName.frame.origin.x + userName.frame.size.width + 10;
    dateFrame.origin.y = userName.frame.origin.y;
    date.frame = dateFrame;
    
    UILabel *content = (UILabel *)[cell viewWithTag:13];
    
    userName.text = currentObject.user_name;
    date.text = currentObject.date;
    content.text = currentObject.content;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 320, 2)];
    bottomLine.backgroundColor = UIColorFromRGB(0x2AA6FF);
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 25)];
    headerLabel.text = @"review";
    
    UIImage *star_0 = [UIImage imageNamed:@"0star"];
    UIImage *star_1 = [UIImage imageNamed:@"1star"];
    UIImage *star_2 = [UIImage imageNamed:@"2star"];
    UIImage *star_3 = [UIImage imageNamed:@"3star"];
    UIImage *star_4 = [UIImage imageNamed:@"4star"];
    UIImage *star_5 = [UIImage imageNamed:@"5star"];
    UIImageView *starImgView = [[UIImageView alloc] initWithFrame:CGRectMake(215, 10, 97, 19)];
    
    int star_point = [self.currentDeliveryStar intValue];
    switch (star_point) {
        case 0:
            starImgView.image = star_0;
            break;
        case 1:
            starImgView.image = star_1;
            break;
        case 2:
            starImgView.image = star_2;
            break;
        case 3:
            starImgView.image = star_3;
            break;
        case 4:
            starImgView.image = star_4;
            break;
        case 5:
            starImgView.image = star_5;
            break;
    }
    [headerView addSubview:bottomLine];
    [headerView addSubview:headerLabel];
    [headerView addSubview:starImgView];
    return headerView;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _reloading = YES;
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"http://lejong0106.cafe24.com/php/get_review_data.php?delivery_id=%@",
                   self.currentDeliveryId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^
                                         (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray *array = [JSON objectForKey:@"reviewLists"];
        self.arrayOfObjects = [[NSMutableArray alloc] init];
        for(int i=0; i<array.count; i++) {
            YAMReviewObject *object = [[YAMReviewObject alloc] init];
            [object setDict:[array objectAtIndex:i] to:object];
            [arrayOfObjects addObject:object];
            [self.table reloadData];
        }
        NSLog(@"test: %@", arrayOfObjects);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    [operation start];
	
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return [NSDate date]; // should return date data source was last changed
}

@end
