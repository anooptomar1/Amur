//
//  LocationViewController.h
//  Amur
//
//  Created by Shreyas Hirday on 2/27/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol sendDataProtocol <NSObject>

-(void)sendDataBack:(NSDecimalNumber *)lat and:(NSDecimalNumber *)lng withName:(NSString *)name;

@end


@interface LocationViewController : UIViewController<MKMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property(nonatomic, assign) id delegate;


@end
