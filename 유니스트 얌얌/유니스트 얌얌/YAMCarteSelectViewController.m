//
//  YAMCarteSelectViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 17..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMCarteSelectViewController.h"
#import "YAMCarteViewController.h"
#import "PKRevealController.h"

@interface YAMCarteSelectViewController ()

@end

@implementation YAMCarteSelectViewController
@synthesize today;
@synthesize tomorrow;
@synthesize dayAfterTomorrow;
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)setDay:(NSString *)day {
    if([day isEqualToString:@"Monday"])
        day = @"월요일";
    else if([day isEqualToString:@"Tuesday"])
        day = @"화요일";
    else if([day isEqualToString:@"Wednesday"])
        day = @"수요일";
    else if([day isEqualToString:@"Thursday"])
        day = @"목요일";
    else if([day isEqualToString:@"Friday"])
        day = @"금요일";
    else if([day isEqualToString:@"Saturday"])
        day = @"토요일";
    else if([day isEqualToString:@"Sunday"])
        day = @"일요일";
    
    return day;
}

- (void)setDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM월dd일";
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    dayFormatter.dateFormat = @"EEEE";

    NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *todayDay = [dayFormatter stringFromDate:[NSDate date]];
    todayDay = [self setDay:todayDay];

    NSString *tomorrowDate = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60]];
    NSString *tomorrowDay = [dayFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60]];
    tomorrowDay = [self setDay:tomorrowDay];

    NSString *dayAfterTomorrowDate = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:48*60*60]];
    NSString *dayAfterTomorrowDay = [dayFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:48*60*60]];
    dayAfterTomorrowDay = [self setDay:dayAfterTomorrowDay];
    
    self.today = [NSString stringWithFormat:@"%@ %@", todayDate, todayDay];
    self.tomorrow = [NSString stringWithFormat:@"%@ %@", tomorrowDate, tomorrowDay];
    self.dayAfterTomorrow = [NSString stringWithFormat:@"%@ %@", dayAfterTomorrowDate, dayAfterTomorrowDay];
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.revealController setMinimumWidth:160.0f maximumWidth:160.0f forViewController:self];
    
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 160, self.view.frame.size.height)];
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    [self.view addSubview:table];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDate];

    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if(row == 0)
        cell.textLabel.text = @"아침";
    else if(row == 1)
        cell.textLabel.text = @"점심";
    else if(row == 2)
        cell.textLabel.text = @"저녁";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 155, 30)];
    
    headerView.backgroundColor = [UIColor blackColor];
    headerLabel.backgroundColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:15];
    headerLabel.textColor = [UIColor whiteColor];

    if(section == 0)
        headerLabel.text = [NSString stringWithFormat:@"%@(오늘)", self.today];
    else if(section == 1)
        headerLabel.text = [NSString stringWithFormat:@"%@(내일)", self.tomorrow];
    else if(section == 2)
        headerLabel.text = [NSString stringWithFormat:@"%@(모레)", self.dayAfterTomorrow];
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *navController = (UINavigationController *)self.revealController.frontViewController;
    
    YAMCarteViewController *front = (YAMCarteViewController *)navController.topViewController;

    front.time = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:indexPath.row + 1]];
    front.date = [self setDateToSend:indexPath.section];
    
    NSString *mealType = [[NSString alloc] init];
    switch (indexPath.row) {
        case 0:
            mealType = @"아침";
            break;
        case 1:
            mealType = @"점심";
            break;
        case 2:
            mealType = @"저녁";
            break;
    }
    
    if(indexPath.section == 0)
        front.labelDate = [NSString stringWithFormat:@"%@ %@", self.today, mealType];
    else if(indexPath.section == 1)
        front.labelDate = [NSString stringWithFormat:@"%@ %@", self.tomorrow, mealType];
    else
        front.labelDate = [NSString stringWithFormat:@"%@ %@", self.dayAfterTomorrow, mealType];
    
    
    [front loadData];
    [self.revealController showViewController:self.revealController.frontViewController];
}

- (NSString *)setDateToSend:(int)i {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    NSString *date = [[NSString alloc] init];
    switch (i) {
        case 0:
            date = [dateFormatter stringFromDate:[NSDate date]];
            break;
        case 1:
            date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60]];
            break;
        case 2:
            date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:48*60*60]];
            break;
    }
    
    return date;
}
@end
