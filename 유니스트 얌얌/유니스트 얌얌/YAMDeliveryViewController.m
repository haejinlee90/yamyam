//
//  YAMDeliveryViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 13..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMDeliveryViewController.h"
#import "YAMFavourArray.h"
#import "YAMDeliveryReviewViewController.h"
#import "AFJSONRequestOperation.h"
#import "MBProgressHUD.h"

#define SELECT (selectedSection != nil && ![selectedSection isEqualToString:@"All"])
#define SELECT_ALL [selectedSection isEqualToString:@"All"]

#define kFilename @"favourArray"
#define kDataKey @"favour"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface YAMDeliveryViewController ()

@end

@implementation YAMDeliveryViewController

@synthesize table;
@synthesize selectVC;
@synthesize delegate;
@synthesize allRest;
@synthesize allSections;
@synthesize sectionsDict;
@synthesize sectionsIndex;
@synthesize selectedSection;
@synthesize selectedSectionIndex;
@synthesize favourArray;
@synthesize currentObject;
@synthesize consist;
@synthesize currentIndexPath;
@synthesize indicator;

static NSString *kYamCellIdentifier = @"YamTableCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)dataFilePath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"favourite"];
    return filePath;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) createData {
    allSections = [[NSMutableArray alloc] init];
    NSString *rType = nil;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSDecimalNumber numberWithInt:0]];
    YAMItem *item = [[YAMItem alloc] init];
    NSLog(@"self.allREst: %@", self.allRest);
    for (int i=0; i<self.allRest.count; i++) {
        item = [self.allRest objectAtIndex:i];
        if (rType == nil || [rType isEqualToString:item.rtype]) {
            rType = item.rtype;
        } else if (![rType isEqualToString:item.rtype]) {
            [self.allSections addObject:rType];
            [array addObject:[NSDecimalNumber numberWithInt:i]];
            rType = item.rtype;
        }
        if (i == self.allRest.count -1) {
            [allSections addObject:rType];
        }
    }
    
    NSLog(@"add to all sections %@", self.allSections);
 
    self.sectionsIndex = [[NSArray alloc] initWithArray:array];
    [table reloadData];
}

- (void) loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectVC = [[YAMDeliverySelectViewController alloc] init];
    self.delegate = [[UIApplication sharedApplication] delegate];
    self.delegate.viewController.rightViewController = self.selectVC;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat height = screenRect.size.height;
    [self.table registerNib:[UINib nibWithNibName:@"YAMDeliveryViewTableCell" bundle:nil] forCellReuseIdentifier:kYamCellIdentifier];

    UIControl *detailBack1 = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, height-140)];
    detailBack1.backgroundColor = [UIColor clearColor];
    detailBack1.alpha = 0.0;
    detailBack1.tag = 1;
    [detailBack1 addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailBack1];
    
    UIView *detail = (UIView *)[self.view viewWithTag:3];
    detail.frame = CGRectMake(0, height + 5, 320, 160);
    detail.backgroundColor = [UIColor whiteColor];

    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //server connection
    [self loadData];
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    YAMFavourArray *FavourArray = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];
    
    if (FavourArray.favourArray.count == 0){
        self.favourArray = [[NSMutableArray alloc] init];
        NSLog(@"not exists");
    } else {
        self.favourArray = FavourArray.favourArray;
        NSLog(@"exists!");
    }
}

- (void)loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [self.indicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"http://lejong0106.cafe24.com/php/get_yamDelivery_data.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^
                                         (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.allRest = [[NSMutableArray alloc] init];
        NSArray *array = [JSON objectForKey:@"deliverylists"];
        for(int i=0; i<array.count; i++){
            YAMItem *item = [[YAMItem alloc] init];
            NSDictionary *dict = [array objectAtIndex:i];
            [YAMItem convert:dict toItem:item];
            NSLog(@"name: %@", item.name);
            [self.allRest insertObject:item atIndex:i];
        }
        [self createData];
//        [self.indicator stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [self.indicator stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"네트워크 상태를 확인해주세요"
                                                       delegate:self cancelButtonTitle:@"확인"
                                              otherButtonTitles: nil];
        [alert show];
    }];
    [operation start];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"data received");
    //json parsing
    NSError *error = nil;
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    //allRest create
    if(jsonDict != nil){
        self.allRest = [[NSMutableArray alloc] init];
        NSArray *array = [jsonDict objectForKey:@"deliverylists"];
        for(int i=0; i<array.count; i++){
            YAMItem *item = [[YAMItem alloc] init];
            NSDictionary *dict = [array objectAtIndex:i];
            [YAMItem convert:dict toItem:item];
            NSLog(@"name: %@", item.name);
            [self.allRest insertObject:item atIndex:i];
        }
    }
    
    if(data == nil)
        [self loadData];
    [self createData];
    [self.indicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"response");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error: %@", error);
    [self.indicator stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                    message:@"네트워크 상태를 확인해주세요"
                                                   delegate:self
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"number of rows sections");
    if (SELECT)
        return 1;

    if (SELECT_ALL || self.selectedSection == nil){
        if(self.favourArray.count == 0)
            return self.allSections.count;
        else
            return self.allSections.count+1;
    }
    NSLog(@"section count: %d", self.allSections.count);
    NSLog(@"------------------------");
    return self.allSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedSection == nil || SELECT_ALL){
        if (self.favourArray.count != 0){
            if (section == 0) {
                NSLog(@"%d", self.favourArray.count);
                return self.favourArray.count;
            } else {
                if (section < self.allSections.count){
                    int currentSection = [[self.sectionsIndex objectAtIndex:section-1] intValue];
                    int nextSection = [[self.sectionsIndex objectAtIndex:section] intValue];
                    NSLog(@"------------------------");
                    NSLog(@"%d", nextSection - currentSection);
                    return nextSection - currentSection;
                } else {
                    return (self.allRest.count - [[self.sectionsIndex objectAtIndex:section-1] intValue]);
                }
            }
        } else if (section < self.allSections.count - 1){
            int currentSection = [[self.sectionsIndex objectAtIndex:section] intValue];
            int nextSection = [[self.sectionsIndex objectAtIndex:section+1] intValue];
            return nextSection - currentSection;
        } else
            return (self.allRest.count - [[self.sectionsIndex objectAtIndex:section] intValue]);
    } else if (SELECT){
        if ([self.selectedSection isEqualToString:@"즐겨찾기"])
            return self.favourArray.count;
        for (int i=0; i<self.allSections.count; i++) {
            if ([self.selectedSection isEqualToString:[self.allSections objectAtIndex:i]] && i<self.allSections.count -1){
                self.selectedSectionIndex = i;
                int currentSection = [[self.sectionsIndex objectAtIndex:i] intValue];
                int nextSection = [[self.sectionsIndex objectAtIndex:i+1] intValue];
                return nextSection - currentSection;
            } else if ([self.selectedSection isEqualToString:[self.allSections objectAtIndex:i]] && i == self.allSections.count - 1){
                self.selectedSectionIndex = i;
                int currentSection = [[self.sectionsIndex objectAtIndex:i] intValue];
                return self.allRest.count - currentSection;
            }
        }
    }
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *cellIdentifier = kYamCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    UILabel *numLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *starNum = (UILabel *)[cell viewWithTag:102];
    
    if (self.selectedSection == nil || SELECT_ALL){
        if (self.favourArray.count != 0){
            if (section == 0){
                label.text = [[self.favourArray objectAtIndex:row] name];
                numLabel.text = [NSString stringWithFormat:@"052-%@", [[self.favourArray objectAtIndex:row] phonenum]];
                starNum.text = [NSString stringWithFormat:@"x%@", [[self.favourArray objectAtIndex:row] star]];
                return cell;
            } else
                section -= 1;
        }
    } else if (SELECT)
        section = self.selectedSectionIndex;
    
    YAMItem *cellObject = [self.allRest objectAtIndex:(row + [[self.sectionsIndex objectAtIndex:section] intValue])];
    label.text = cellObject.name;
    numLabel.text = [NSString stringWithFormat:@"052-%@", cellObject.phonenum];
    starNum.text = [NSString stringWithFormat:@"x%@", cellObject.star];
    
    if ([self.selectedSection isEqualToString:@"즐겨찾기"]) {
        cellObject = [self.favourArray objectAtIndex:row];
        label.text = cellObject.name;
        numLabel.text = [NSString stringWithFormat:@"052-%@",cellObject.phonenum];
        starNum.text = cellObject.star;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *rest_type = nil;

    if (self.selectedSection == nil){
        if (self.favourArray.count == 0)
            rest_type = [self.allSections objectAtIndex:section];
        else if (section == 0)
            rest_type = @"즐겨찾기";
        else
            rest_type = [self.allSections objectAtIndex:section -1];
    } else if (SELECT){
        if ([self.selectedSection isEqualToString:@"즐겨찾기"]){
            rest_type = @"즐겨찾기";
        } else {
            for (int i=0; i<self.allSections.count; i++) {
                if ([selectedSection isEqualToString:[self.allSections objectAtIndex:i]])
                    rest_type = [self.allSections objectAtIndex:i];
            }
        }
    } else if (SELECT_ALL && self.favourArray.count != 0) {
        if (section == 0){
            rest_type = @"즐겨찾기";
        } else {
            rest_type = [self.allSections objectAtIndex:section-1];
        }
    } else
        rest_type = [self.allSections objectAtIndex:section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 35)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 25)];
    headerLabel.text = rest_type;
    headerLabel.font = [UIFont boldSystemFontOfSize:20];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 290, 2)];
    
    if ([rest_type isEqualToString:@"즐겨찾기"]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xC6EAF8);
        headerLabel.textColor = UIColorFromRGB(0x2CA5DF);
    } else if ([rest_type isEqualToString:[self.allSections objectAtIndex:0]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0x7F7F7F);
        headerLabel.textColor = UIColorFromRGB(0x666666);
    } else if ([rest_type isEqualToString:[self.allSections objectAtIndex:1]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xAED978);
        headerLabel.textColor = UIColorFromRGB(0x53A618);
    } else if ([rest_type isEqualToString:[self.allSections objectAtIndex:2]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xFFF1D2);
        headerLabel.textColor = UIColorFromRGB(0xFCAE28);
    } else if ([rest_type isEqualToString:[self.allSections objectAtIndex:3]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xFF3947);
        headerLabel.textColor = UIColorFromRGB(0xFF0000);
    } else if ([rest_type isEqualToString:[self.allSections objectAtIndex:4]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xF25DFF);
        headerLabel.textColor = UIColorFromRGB(0xF603FF);
    }
    
    [headerView addSubview:headerLabel];
    [headerView addSubview:bottomLine];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentIndexPath = indexPath;
    [self detailView:indexPath];
}

- (IBAction) detailView:(id)sender {
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    UIControl *detailBack1 = (UIControl *)[self.view viewWithTag:1];
    UIView *detail = (UIView *)[self.view viewWithTag:3];
    CGFloat height = self.view.frame.size.height;
    
    UILabel *nameLabel = (UILabel *)[self.view viewWithTag:4];
    UILabel *phoneLabel = (UILabel *)[self.view viewWithTag:5];
    UIImageView *star = (UIImageView *)[self.view viewWithTag:6];
    UILabel *join_num = (UILabel *)[self.view viewWithTag:7];
    
    NSInteger currentSectionIndex = NAN;//[[self.sectionsIndex objectAtIndex:section] intValue];
    NSInteger currentIndex = NAN;//currentSectionIndex + row;
    self.currentObject = nil;//[self.allRest objectAtIndex:currentIndex];
    
    if (selectedSection == nil || SELECT_ALL) {
        if (self.favourArray.count != 0) {
            if (section == 0){
                currentObject = [self.favourArray objectAtIndex:row];
            } else {
                currentSectionIndex = [[self.sectionsIndex objectAtIndex:section -1] intValue];
                currentIndex = currentSectionIndex + row;
                currentObject = [self.allRest objectAtIndex:currentIndex];
            }
        } else {
            currentSectionIndex = [[self.sectionsIndex objectAtIndex:section] intValue];
            currentIndex = currentSectionIndex + row;
            currentObject = [self.allRest objectAtIndex:currentIndex];
        }
    } else if (SELECT) {
        if ([self.selectedSection isEqualToString:@"즐겨찾기"])
            currentObject = [self.favourArray objectAtIndex:row];
        else {
            for (int i=0; i<self.allSections.count; i++)
                if ([self.selectedSection isEqualToString:[self.allSections objectAtIndex:i]]) {
                    currentSectionIndex = [[self.sectionsIndex objectAtIndex:i] intValue];
                    currentIndex = currentSectionIndex + row;
                    currentObject = [self.allRest objectAtIndex:currentIndex];
                }
        }
    }
    int star_num;
    nameLabel.text = currentObject.name;
    [nameLabel sizeToFit];
    phoneLabel.text = [NSString stringWithFormat:@"052-%@", currentObject.phonenum];
    phoneLabel.frame = CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width + 10, 23, 170, 20);
    [phoneLabel sizeToFit];
    star_num = [currentObject.star intValue];
    join_num.text = [NSString stringWithFormat:@"%@명참여", currentObject.join_num];
    [join_num sizeToFit];
    UIImage *star_img = nil;
    switch (star_num) {
        case 0:
            star_img = [UIImage imageNamed:@"0star"];
            break;
        case 1:
            star_img = [UIImage imageNamed:@"1star"];
            break;
        case 2:
            star_img = [UIImage imageNamed:@"2star"];
            break;
        case 3:
            star_img = [UIImage imageNamed:@"3star"];
            break;
        case 4:
            star_img = [UIImage imageNamed:@"4star"];
            break;
        case 5:
            star_img = [UIImage imageNamed:@"5star"];
            break;
    }
    star.image = star_img;
    
    [UIView beginAnimations:@"up" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    detailBack1.alpha = 0.1;
    detailBack1.frame = CGRectMake(0, 0, 320, height-160);
    detail.frame = CGRectMake(0, height - 160, 320, 160);
    [UIView commitAnimations];
    self.table.scrollEnabled = NO;
    self.consist = 0;

    for (int i=0; i<favourArray.count; i++) {
        if ([currentObject.restID isEqualToString:[[self.favourArray objectAtIndex:i] restID]]) {
            consist = 1;
            NSLog(@"consist!");
        }
    }
    
    UIButton *favourBtn = (UIButton *)[self.view viewWithTag:8];
    UIImage *favourImg = [UIImage imageNamed:@"favour"];
    UIImage *favour_sel_Img = [UIImage imageNamed:@"favour_sel"];
    UIImage *favour_star_Img = [UIImage imageNamed:@"favour_star"];
    UIImage *favour_star_sel_Img = [UIImage imageNamed:@"favour_star_sel"];
    
    if (consist == 1) {
        NSLog(@"consist!");
        [favourBtn setBackgroundImage:favour_star_Img forState:UIControlStateNormal];
        [favourBtn setBackgroundImage:favour_star_sel_Img forState:UIControlStateHighlighted];
    } else {
        NSLog(@"not consist!");
        [favourBtn setBackgroundImage:favourImg forState:UIControlStateNormal];
        [favourBtn setBackgroundImage:favour_sel_Img forState:UIControlStateHighlighted];
    }
    [favourBtn addTarget:self action:@selector(favour:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reviewBtn = (UIButton *)[self.view viewWithTag:9];
    [reviewBtn addTarget:self action:@selector(showReview:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) closeView {
    UIControl *detailBack1 = (UIControl *)[self.view viewWithTag:1];
    UIView *detail = (UIView *)[self.view viewWithTag:3];
    CGFloat height = self.view.frame.size.height;
    
    [UIView beginAnimations:@"down" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    detailBack1.alpha = 0;
    detailBack1.frame = CGRectMake(0, 0, 320, height);
    detail.frame = CGRectMake(0, height + 5, 320, 160);
    [UIView commitAnimations];
    self.table.scrollEnabled = YES;
}

- (IBAction) callPhone:(id)sender {
    NSString *phoneNum = [(UILabel *)[self.view viewWithTag:5] text];
    NSLog(@"%@", phoneNum);
    NSArray *numArray = [phoneNum componentsSeparatedByString:@"/"];
    NSString *number = numArray[0];
    NSLog(@"number: %@", number);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]]];
}

- (void) favour:(id)sender {
    UIButton *favourBtn = (UIButton *)[self.view viewWithTag:8];
    UIImage *favourImg = [UIImage imageNamed:@"favour"];
    UIImage *favour_sel_Img = [UIImage imageNamed:@"favour_sel"];
    UIImage *favour_star_Img = [UIImage imageNamed:@"favour_star"];
    UIImage *favour_star_sel_Img = [UIImage imageNamed:@"favour_star_sel"];

    if (self.consist == 1) {
        UIAlertView *delete = [[UIAlertView alloc] initWithTitle:@"알림" message:@"즐겨찾기에서 제외되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [favourBtn setBackgroundImage:favourImg forState:UIControlStateNormal];
        [favourBtn setBackgroundImage:favour_sel_Img forState:UIControlStateHighlighted];

        [self.favourArray removeObject:self.currentObject];
        YAMFavourArray *FavourArray = [[YAMFavourArray alloc] init];
        FavourArray.favourArray = self.favourArray;
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:FavourArray forKey:kDataKey];
        [archiver finishEncoding];
        [data writeToFile:[self dataFilePath] atomically:YES];
        consist = 0;
        [delete show];
    } else {
        UIAlertView *add = [[UIAlertView alloc] initWithTitle:@"알림" message:@"즐겨찾기에 추가되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [favourBtn setBackgroundImage:favour_star_Img forState:UIControlStateNormal];
        [favourBtn setBackgroundImage:favour_star_sel_Img forState:UIControlStateHighlighted];
        [self.favourArray addObject:currentObject];
        YAMFavourArray *FavourArray = [[YAMFavourArray alloc] init];
        FavourArray.favourArray = self.favourArray;
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:FavourArray forKey:kDataKey];
        [archiver finishEncoding];
        [data writeToFile:[self dataFilePath] atomically:YES];
        consist = 1;
        [add show];
    }
    [self.table reloadData];
}

- (void) showReview:(id)sender {
    YAMDeliveryReviewViewController *reviewController = [[YAMDeliveryReviewViewController alloc] initWithNibName:@"YAMDeliveryReviewViewController" bundle:nil];
    reviewController.currentDeliveryId = self.currentObject.restID;
    reviewController.currentDeliveryStar = self.currentObject.star;
    reviewController.currentTitle = self.currentObject.name;
    reviewController.reviewDelegate = self;
    [reviewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:reviewController animated:YES];
}

- (void) completeReviewWithStar:(NSString *)star andJoin:(NSString *)join {
    NSString *url = @"http://lejong0106.cafe24.com/php/get_yamDelivery_data.php";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connect = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connect == nil) {
        NSLog(@"connection failed");
    } else {
        NSLog(@"connection succeed!");
    }

    UIImageView *starImgView = (UIImageView *)[self.view viewWithTag:6];
    UILabel *join_num = (UILabel *)[self.view viewWithTag:7];
    
    join_num.text = [NSString stringWithFormat:@"%@명참여", join];
    [join_num sizeToFit];
    UIImage *star_img = nil;
    switch ([star intValue]) {
        case 0:
            star_img = [UIImage imageNamed:@"0star"];
            break;
        case 1:
            star_img = [UIImage imageNamed:@"1star"];
            break;
        case 2:
            star_img = [UIImage imageNamed:@"2star"];
            break;
        case 3:
            star_img = [UIImage imageNamed:@"3star"];
            break;
        case 4:
            star_img = [UIImage imageNamed:@"4star"];
            break;
        case 5:
            star_img = [UIImage imageNamed:@"5star"];
            break;
    }
    
    starImgView.image = star_img;
}

@end








