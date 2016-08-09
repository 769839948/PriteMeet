//
//  AboutViewController.m
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "AboutViewController.h"
#import "MeetBaseViewController.h"
#import "UserProtocolViewController.h"
#import "Meet-Swift.h"

@interface AboutViewController () {
    
    __weak IBOutlet UIImageView *_logoImageView;
    __weak IBOutlet UILabel *_labelLogoBottom;
    
    UserProtocolViewController *_userProtocolVC;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于Meet";
    _logoImageView.layer.masksToBounds = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self setUpNavigationBarItem];
    self.talKingDataPageName = @"Me-About";
}

- (void)setUpNavigationBarItem
{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];

    UIBarButtonItem *rightBtItem = [[UIBarButtonItem alloc] initWithTitle:@"联系客服" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarPress:)];
    [rightBtItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:HomeDetailViewNameColor],NSFontAttributeName:NavigationBarRightItemFont} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBtItem;
}

- (void)rightBarPress:(UIBarButtonItem *)sender
{
    NSString *tempPhone = @"";
    if ([self.phone isEqualToString:@""]) {
        tempPhone = @"18513008226";
    }else{
        tempPhone = _phone;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tempPhone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (IBAction)useProtocolAction:(UIButton *)sender {
    if (_userProtocolVC) {
        [self.navigationController pushViewController:_userProtocolVC animated:YES];
    } else {
        [self performSegueWithIdentifier:@"PushToUserProtocolViewController" sender:self];
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PushToUserProtocolViewController"]) {
        _userProtocolVC = (UserProtocolViewController *)segue.destinationViewController;
    }
}


@end
