//
//  FirstViewController.h
//  Amur
//
//  Created by Shreyas Hirday on 2/27/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationViewController.h"

@interface FirstViewController : UIViewController<sendDataProtocol>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)goToMap:(id)sender;

@property (strong, nonatomic) IBOutlet UINavigationItem *navBar;
@property(weak,nonatomic) NSString* name;


@end

