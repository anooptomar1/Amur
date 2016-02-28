//
//  GodViewController.m
//  Amur
//
//  Created by Shreyas Hirday on 2/27/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

#import "GodViewController.h"

@interface GodViewController ()

@end

@implementation GodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    int i = 0;
    for(UIViewController *vc in self.viewControllers){
        if(i == 0){
            vc.tabBarItem.image = [[UIImage imageNamed:@"icons_color-02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else if(i == 1){
            vc.tabBarItem.image = [[UIImage imageNamed:@"icons_color-03.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else if(i == 2){
            vc.tabBarItem.image = [[UIImage imageNamed:@"icons_color-04.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else if(i == 3){
            vc.tabBarItem.image = [[UIImage imageNamed:@"icons_color-05.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        i++;
        
    }
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
