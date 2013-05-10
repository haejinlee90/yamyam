//
//  YAMCarteViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 17..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMCarteViewController.h"
#import "AFJSONRequestOperation.h"
#import "YAMCarteObject.h"
#import "YAMCarteSelectViewController.h"
#import "YAMAppDelegate.h"
#import "MBProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface YAMCarteViewController ()

@end

@implementation YAMCarteViewController
@synthesize table;
@synthesize HeaderLabel;
@synthesize date;
@synthesize time;
@synthesize rtype;
@synthesize ArrayOfObjects;
@synthesize labelDate;
@synthesize indicator;

static NSString *kCellIdentifier = @"YAMCarteTableCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)defaultSetting {
    NSDateFormatter *todayDateFormatter = [[NSDateFormatter alloc] init];
    todayDateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *todayDate = [todayDateFormatter stringFromDate:[NSDate date]];
    self.date = todayDate;
//    NSLog(@"%@", self.date);
    
    NSDateFormatter *currentTimeFormatter = [[NSDateFormatter alloc] init];
    currentTimeFormatter.dateFormat = @"HH시mm분";
    NSString *currentTime = [currentTimeFormatter stringFromDate:[NSDate date]];
    NSLog(@"currentTime: %@", currentTime);
    
    NSString *breakfastTime = @"09시30분";
    NSString *lunchTime = @"13시30분";
    NSString *dinnerTime = @"19시30분";			
    
    if ([currentTime compare:breakfastTime] == NSOrderedAscending) {
        self.time = @"1";
    } else if ([currentTime compare:breakfastTime] == NSOrderedDescending && [currentTime compare:lunchTime] == NSOrderedAscending) {
        self.time = @"2";
    } else if ([currentTime compare:lunchTime] == NSOrderedDescending && [currentTime compare:dinnerTime] == NSOrderedAscending) {
        self.time = @"3";
    } else {
        self.time = @"3";
    }
    
    self.rtype = @"1";
    self.HeaderLabel.text = [self headerLabelStartingText];
    NSLog(@"test%@", [self headerLabelStartingText]);
    NSLog(@"headerlabel: %@", HeaderLabel.text);
}

- (void)loadData {
//    [self.indicator startAnimating];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"http://lejong0106.cafe24.com/php/meal.php?date=%@&time=%@&rtype=%@",
                   self.date, self.time, self.rtype]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^
                                         (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSArray *array = [JSON objectForKey:@"meallist"];
        ArrayOfObjects = [[NSMutableArray alloc] init];
        for (int i=0; i<array.count; i++) {
            YAMCarteObject *object = [[YAMCarteObject alloc] init];
            [object setDict:[array objectAtIndex:i] To:object];
            [ArrayOfObjects addObject:object];
        }
        [self.table reloadData];
        if (self.labelDate != nil)
            self.HeaderLabel.text = self.labelDate;
        
        [self.indicator stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@", [error userInfo]);
        [self.indicator stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"네트워크 상태를 확인해주세요"
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles: nil];
        [alert show];
    }];
    [operation start];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonPressed:(id)sender {
    UIButton *pressedButton = (UIButton *)sender;

    UIButton *ourhome = (UIButton *)[self.view viewWithTag:1];
    UIButton *welstory = (UIButton *)[self.view viewWithTag:2];
    UIButton *student = (UIButton *)[self.view viewWithTag:3];
    
    switch (pressedButton.tag) {
        case 1:
            ourhome.enabled = NO;
            welstory.enabled = YES;
            student.enabled = YES;
            self.rtype = @"2";
            break;
        case 2:
            ourhome.enabled = YES;
            welstory.enabled = NO;
            student.enabled = YES;
            self.rtype = @"1";
            break;
        case 3:
            ourhome.enabled = YES;
            welstory.enabled = YES;
            student.enabled = NO;
            self.rtype = @"3";
            break;
    }
    
    [self loadData];
}

- (NSArray *) separateString:(NSString *)string {
    NSArray *array = [[NSArray alloc] init];
    array = [string componentsSeparatedByString:@"/"];
    return array;
}

- (void)loadView {
    [super loadView];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    YAMCarteSelectViewController *selectVC = [[YAMCarteSelectViewController alloc] init];
    YAMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.viewController.rightViewController = selectVC;
    [self.table registerNib:[UINib nibWithNibName:@"YAMCarteViewTableCell" bundle:nil] forCellReuseIdentifier: kCellIdentifier];

    UIButton *ourhome = (UIButton *)[self.view viewWithTag:1];
    UIImage *ourhomeImg = [UIImage imageNamed:@"ourhome"];
    UIImage *ourhome_sel_Img = [UIImage imageNamed:@"ourhome_sel"];
    [ourhome setBackgroundImage:ourhomeImg forState:UIControlStateHighlighted];
    [ourhome setBackgroundImage:ourhome_sel_Img forState:UIControlStateDisabled];
    
    UIButton *welstory = (UIButton *)[self.view viewWithTag:2];
    UIImage *welstoryImg = [UIImage imageNamed:@"welstory"];
    UIImage *welstory_sel_Img = [UIImage imageNamed:@"welstory_sel"];
    welstory.enabled = NO;
    [welstory setBackgroundImage:welstoryImg forState:UIControlStateHighlighted];
    [welstory setBackgroundImage:welstory_sel_Img forState:UIControlStateDisabled];
    
    UIButton *student = (UIButton *)[self.view viewWithTag:3];
    UIImage *studentImg = [UIImage imageNamed:@"student"];
    UIImage *student_sel_Img = [UIImage imageNamed:@"student_sel"];
    [student setBackgroundImage:studentImg forState:UIControlStateHighlighted];
    [student setBackgroundImage:student_sel_Img forState:UIControlStateDisabled];

    [ourhome addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [welstory addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [student addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self defaultSetting];
    
//    [self.indicator startAnimating];
    [self loadData];
}

- (NSString *)headerLabelStartingText {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"MM월dd일";
    
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
    dayFormat.dateFormat = @"EEEE";
    
    NSString *dateString = [dateFormat stringFromDate:[dateFormatter dateFromString:self.date]];
    NSString *dayString = [dayFormat stringFromDate:[dateFormatter dateFromString:self.date]];
    dayString = [self setDay:dayString];
    
    NSString *mealType = [[NSString alloc] init];
    
    if (self.time.intValue == 1) {
        mealType = @"아침";
    } else if (self.time.intValue == 2) {
        mealType = @"점심";
    } else
        mealType = @"저녁";
    
    NSString *returnString = [NSString stringWithFormat:@"%@ %@ %@", dateString, dayString, mealType];
    return returnString;
}

- (NSString *)setDay:(NSString *)day {
    if ([day isEqualToString:@"Monday"])
        day = @"월요일";
    else if ([day isEqualToString:@"Tuesday"])
        day = @"화요일";
    else if ([day isEqualToString:@"Wednesday"])
        day = @"수요일";
    else if ([day isEqualToString:@"Thursday"])
        day = @"목요일";
    else if ([day isEqualToString:@"Friday"])
        day = @"금요일";
    else if ([day isEqualToString:@"Saturday"])
        day = @"토요일";
    else if ([day isEqualToString:@"Sunday"])
        day = @"일요일";
    
    return day;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.time isEqualToString:@"1"] && [self.rtype isEqualToString:@"2"])
        return 1;
    return ArrayOfObjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.time isEqualToString:@"1"] && [self.rtype isEqualToString:@"2"])
        return 1;
    YAMCarteObject *object = [self.ArrayOfObjects objectAtIndex:section];
    NSArray *arrayOfMeal = [self separateString:object.item];
    return arrayOfMeal.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    NSString *cellIdentifier = kCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.userInteractionEnabled = NO;
    UILabel *label = (UILabel *)[cell viewWithTag:10];
    if ([self.time isEqualToString:@"1"] && [self.rtype isEqualToString:@"2"]){
        label.text = @"아워홈은 아침 음슴~";
        return cell;
    }
    YAMCarteObject *object = [self.ArrayOfObjects objectAtIndex:section];
    NSArray *array = [self separateString:object.item];
    
    label.text = [array objectAtIndex:row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YAMCarteObject *object = [self.ArrayOfObjects objectAtIndex:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 292, 35)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 200, 30)];
    
    headerLabel.font = [UIFont boldSystemFontOfSize:20];
//    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.text = object.corner;
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 2)];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 290, 2)];

    if (section % 3 == 0) {
        topLine.backgroundColor = UIColorFromRGB(0x2495D8);
        bottomLine.backgroundColor = UIColorFromRGB(0x2495D8);//C6EAF8);
        headerLabel.textColor = UIColorFromRGB(0x2495D8);
    } else if (section %3 == 1) {
        topLine.backgroundColor = UIColorFromRGB(0xFEAD19);
        bottomLine.backgroundColor = UIColorFromRGB(0xFEAD19);
        headerLabel.textColor = UIColorFromRGB(0xFEAD19);//FFF1D2);
    } else {
        topLine.backgroundColor = UIColorFromRGB(0x459700);
        bottomLine.backgroundColor = UIColorFromRGB(0x459700);
        headerLabel.textColor = UIColorFromRGB(0x459700);//AED978);
    }
    
    [headerView addSubview:topLine];
    [headerView addSubview:bottomLine];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.time isEqualToString:@"1"] && [self.rtype isEqualToString:@"2"])
        return 0;

    return 35;
}

- (void)viewDidUnload {
    [self setHeaderLabel:nil];
    [self setHeaderLabel:nil];
    [super viewDidUnload];
}

@end
