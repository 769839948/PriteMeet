//
//  MoreInfoViewController.m
//  Meet
//
//  Created by Zhang on 6/6/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "MoreInfoViewController.h"
@interface MoreInfoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextTime;
@end

@implementation MoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (IBAction)nextTimeAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
