//
//  GodViewController.m
//  Amur
//
//  Created by Shreyas Hirday on 2/27/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

#import "GodViewController.h"
#import "HexColors.h"

@interface GodViewController ()

@end

@implementation GodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    

    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.tabBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor hx_colorWithHexString:@"471d29"] CGColor], (id)[[UIColor hx_colorWithHexString:@"421d29"] CGColor], nil];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    //[self.tabBar.layer insertSublayer:gradient atIndex:0];
    
    int i = 0;
    for(UIViewController *vc in self.viewControllers){
        if(i == 0){
            vc.tabBarItem.image = [[UIImage imageNamed:@"whats-in-my-air.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"what's-in-my-air_select.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.title = @"What's In My Air?";
        }
        else if(i == 1){
            vc.tabBarItem.image = [[UIImage imageNamed:@"aqi-visualizaition.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"aqi-visualization_select.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.title = @"AQI Visualization";
        }
        else if(i == 2){
            vc.tabBarItem.image = [[UIImage imageNamed:@"show-amur.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"show-amur_select.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.title = @"Show Amur";
        }
        else if(i == 3){
            vc.tabBarItem.image = [[UIImage imageNamed:@"settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:@"settings_select.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.title = @"Settings";
        }
        i++;
     

    }
    
}

-(UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
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
