//
//  YAMDeliverySelectViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 13..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMDeliverySelectViewController.h"
#import "YAMDeliveryViewController.h"
#import "PKRevealController.h"

@interface YAMDeliverySelectViewController ()

@end

@implementation YAMDeliverySelectViewController
@synthesize table;
@synthesize Lists;
@synthesize rest_types;

static NSString *kYamSelectTableCell = @"YamSelectTableCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self.revealController setMinimumWidth:120.0f maximumWidth:120.0f forViewController:self];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat height = screenRect.size.height;
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, height) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.scrollEnabled = NO;
    [self.table registerNib:[UINib nibWithNibName:@"YAMDeliverySelectViewTableCell" bundle:nil] forCellReuseIdentifier:kYamSelectTableCell];
    
    [self.view addSubview:self.table];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"All", @"즐겨찾기", @"치킨집", @"피자", @"중국집", @"족발집", @"돈까스", nil];
    self.rest_types = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Table Veiw Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rest_types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSString *restType = [rest_types objectAtIndex:row];
    NSString *cellIdentifier = kYamSelectTableCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.textLabel.text = restType;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIView *selectedView = (UIView *)[cell viewWithTag:10];
    selectedView.alpha = 0;

    UINavigationController *navController = (UINavigationController *)self.revealController.frontViewController;
    YAMDeliveryViewController *front = (YAMDeliveryViewController *)navController.topViewController;
    
    NSLog(@"selected section: %@", front.selectedSection);
    if (row == 0 && front.selectedSection == NULL)
        selectedView.alpha = 1;
    
    if (front.selectedSection != NULL)
        if ([restType isEqualToString:front.selectedSection])
            selectedView.alpha = 1;
        else
            selectedView.alpha = 0;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *navController = (UINavigationController *)self.revealController.frontViewController;
    
    YAMDeliveryViewController *front = (YAMDeliveryViewController *)navController.topViewController;
    NSLog(@"%@", [rest_types objectAtIndex:[indexPath row]]);
    front.selectedSection = [rest_types objectAtIndex:[indexPath row]];
    [self.table reloadData];
    [front.table reloadData];
    [self.revealController showViewController:self.revealController.frontViewController];
}

@end
