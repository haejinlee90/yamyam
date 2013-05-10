//
//  YAMQnAViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 21..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMQnAViewController.h"

@interface YAMQnAViewController ()

@end

@implementation YAMQnAViewController
@synthesize table;

static NSString *kNormal = @"normal";
static NSString *kNinespoons = @"Ninespoons";
static NSString *kThanksto = @"Thanksto";
static NSString *kNinespoonsVersion = @"NinespoonsVersion";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:@"문의 및 설정"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadView
{
    [super loadView];
    
    [self.table registerNib:[UINib nibWithNibName:@"YAMQnATableCell" bundle:nil] forCellReuseIdentifier:kNormal];
    [self.table registerNib:[UINib nibWithNibName:@"Ninespoons" bundle:nil] forCellReuseIdentifier:kNinespoons];
    [self.table registerNib:[UINib nibWithNibName:@"NinespoonsVersionCell" bundle:nil] forCellReuseIdentifier:kNinespoonsVersion];
    [self.table registerNib:[UINib nibWithNibName:@"ThanksTo" bundle:nil] forCellReuseIdentifier:kThanksto];
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
    if(section == 0 || section == 2)
        return 3;

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    
//    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if(cell == nil)
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    UITableViewCell *cell = nil;
    if(section == 0 && row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kNinespoons];
    }
    else if(section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:kThanksto];
    }
    else if(section == 2 && row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kNinespoonsVersion];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:kNormal];
    }
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    if(section == 0 && row == 1)
        cellLabel.text = @"나인스푼즈 페이스북";
    else if(section == 0 && row == 2)
        cellLabel.text = @"나인스푼즈 히스토리";
    else if(section == 2 && row == 1)
        cellLabel.text = @"페이스북으로 문의하기";
    else if(section == 2 && row == 2)
        cellLabel.text = @"메일로 문의하기";
    
    return cell;
    
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0 && row == 0)
        return 178;
    else if(section == 1)
        return 190;
    else if(section ==2 && row == 0)
        return 124;
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0 && row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.fb.com/ninespoons"]];
    }else if(section == 2 && row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.fb.com/unistyamyam"]];
    }else if(section == 2 && row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:help@unist.me"]];
    }
        
}
@end
