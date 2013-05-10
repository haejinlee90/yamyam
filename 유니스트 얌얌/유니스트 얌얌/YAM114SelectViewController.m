//
//  YAM114SelectViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 14..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAM114SelectViewController.h"
#import "PKRevealController.h"
#import "YAM114ViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface YAM114SelectViewController ()

@end

@implementation YAM114SelectViewController
@synthesize table;
@synthesize Lists;
@synthesize sections;

static NSString *selectCell = @"selectCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.revealController setMinimumWidth:160.0f maximumWidth:160.0f forViewController:self];
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat height = screenRect.size.height;
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 160, height) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.table registerNib:[UINib nibWithNibName:@"YAM114SelectViewCell" bundle:nil] forCellReuseIdentifier:selectCell];
    NSArray *array = [[NSArray alloc] initWithObjects:@"All", @"All(가나다순)",
                      @"즐겨찾기", @"기초과정부", @"기계 및 신소재공학부", @"나노생명화학공학부",
                      @"도시환경공학부", @"디자인 및 인간공학부", @"전기전자컴퓨터공학부", @"친환경에너지공학부",
                      @"테크노경영학부", @"학교 부서", @"기타", nil];
    
    self.sections = array;
    [self.view addSubview:self.table];
}

#pragma mark -
#pragma mark - Table Veiw Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    NSString *sectionName = [self.sections objectAtIndex:row];
    
    NSString *cellIdentifier = selectCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.textLabel.text = sectionName;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    UIView *selectedView = (UIView *)[cell viewWithTag:10];
    selectedView.alpha = 0;

    UINavigationController *navController = (UINavigationController *)self.revealController.frontViewController;
    YAM114ViewController *front = (YAM114ViewController *)navController.topViewController;
    
    if (row == 0 && front.selectedSection == NULL)
        selectedView.alpha = 1;
    
    if (front.selectedSection != NULL) {
        if ([front.selectedSection isEqualToString:sectionName]) {
            selectedView.alpha = 1;
        } else {
            selectedView.alpha = 0;
        }
    }
    [cell addSubview:selectedView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *navController = (UINavigationController *)self.revealController.frontViewController;
    
    YAM114ViewController *front = (YAM114ViewController *)navController.topViewController;
    //    NSLog(@"%@", [rest_types objectAtIndex:[indexPath row]]);
    front.selectedSection = [self.sections objectAtIndex:[indexPath row]];
    [self.table reloadData];
    front.selectChanged = YES;
    [front closeView];
    if(front.searched == YES) {
        front.search.text = @"";
        [front resetSearch];
        [front setData];
        front.searched = NO;
    }
    [front.search resignFirstResponder];
    
    [front.table reloadData];
    [self.revealController showViewController:self.revealController.frontViewController];
}

@end
