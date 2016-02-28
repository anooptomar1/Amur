//
//  FirstViewController.m
//  Amur
//
//  Created by Shreyas Hirday on 2/27/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

#import "FirstViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "SWRevealViewController.h"
#import "HexColors.h"
#import "LocationViewController.h"

@interface FirstViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated{
   
    
    int i = 0;
    for(UIView *view in [self.view subviews]){
        if(view.tag != 3 && view.tag != 4 && view.tag != 5){
            [self setAnimation:view withNum:i];
            i++;
        }
    }
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   self.sidebarButton.image = [[UIImage imageNamed:@"top_bar_icons-07.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
    ;
    
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationController.navigationBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor hx_colorWithHexString:@"471d29"] CGColor], (id)[[UIColor hx_colorWithHexString:@"421d29"] CGColor], nil];
    
    UIGraphicsBeginImageContext(gradient.bounds.size);
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationController.navigationBar setBackgroundImage:gradientImage forBarMetrics:UIBarMetricsDefault];
   
    
    
#if !TARGET_IPHONE_SIMULATOR
    
    UIView *arView = self.view;
    
    NSError *error = nil;
    AVCaptureSession *avCaptureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    if (videoInput) {
        [avCaptureSession addInput:videoInput];
    }
    else {
        // Handle the failure.
    }
    
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:avCaptureSession];
    int cameraOrientation = AVCaptureVideoOrientationPortrait;
    
    [[arView layer] setMasksToBounds:YES];
    [newCaptureVideoPreviewLayer setFrame:[arView bounds]];
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    if ([[newCaptureVideoPreviewLayer connection] isVideoOrientationSupported])
        [[newCaptureVideoPreviewLayer connection] setVideoOrientation:cameraOrientation];
    
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [[arView layer] insertSublayer:newCaptureVideoPreviewLayer below:[[[arView layer] sublayers] objectAtIndex:0]];
    
    [self.view.layer addSublayer:newCaptureVideoPreviewLayer];
    
    
    [avCaptureSession setSessionPreset:AVCaptureSessionPresetHigh];
    [avCaptureSession startRunning];
    
    
    
#endif
    
    [self startStandardUpdates];
    
    UIImageView *barImageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 430, 165, 180)];
    
    [barImageView setImage:[[UIImage imageNamed:@"bar_parts-01.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    barImageView.tag = 3;
    
    [self.view addSubview:barImageView];
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startStandardUpdates
{
    
    NSLog(@"Starting Standard Updates...");
    
    
    if(_locationManager == nil) _locationManager = [[CLLocationManager alloc] init];
    
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    
    [_locationManager setDistanceFilter:500];
    
    [_locationManager requestAlwaysAuthorization];
    
    [_locationManager startUpdatingLocation];
    

}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"didUpdateLocations");
    
    CLLocation *location = [locations lastObject];
    
    NSDate *eventDate = location.timestamp;
    
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if(YES || abs(howRecent) < 5.0){
        
        
        NSString *urlString = @"https://api.breezometer.com/baqi";
        
        NSString *key = @"7b022bb2e6014358bdc97b60b5ec5912";
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
        NSNumber *lon = [NSNumber numberWithDouble:location.coordinate.longitude];
        
        
        
        NSDictionary *params =  @{@"lat" : lat, @"lon" : lon, @"key" : key};
        
        NSMutableURLRequest *urlRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url.absoluteString parameters:params error:nil];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        AFURLSessionManager *sm = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
        NSLog(@"task being initialized");
        NSURLSessionDataTask *task = [sm dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if(error){
                NSLog(@"ERROR: %@",error);
            }
            else{
                
                NSLog(@"NOT ERROR");
                NSArray *viewsToRemove = [self.view subviews];
                for (UIView *v in viewsToRemove) {
                    if(v.tag != 3 && v.tag != 4){
                        [v removeFromSuperview];
                    }
                }

                
                //NSLog(@"JSON: %@",responseObject);
                
                int AQI = [responseObject[@"breezometer_aqi"] intValue];
                
                NSString *description = responseObject[@"breezometer_description"];
                
                NSString *pollutant = responseObject[@"dominant_pollutant_description"];
                
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Woah!" message:[NSString stringWithFormat:@"The dominant pollutant is %@",pollutant] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
                
                [controller addAction:action];
                
                [self presentViewController:controller animated:YES completion:nil];
                
                NSString *data = [NSString stringWithFormat:@"AQI : %d\nDescription: %@ ",AQI,description];
                
                
          
                [self generateButtonsForView];
                
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                
                [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                   
                    NSString *cityname = placemarks[0].locality;
                    
                    BOOL foundOne = NO;
                    BOOL foundTwo = NO;
                    for(UIView* v in self.view.subviews){
                        if(v.tag == 4){
                            int offset = [self offsetCalculator:AQI];
                            NSLog(@"Offset: %d",offset);
                            [v setFrame:CGRectMake(255, offset, 160, 30)];
                            //[v layoutSubviews];
                            foundOne = YES;
                        }
                        if(v.tag == 5){
                            [(UITextField *)v setText:[NSString stringWithFormat:@"%d\n%@",AQI,cityname]];
                            foundTwo = YES;
                        }
                    }
                    
                    if(!foundOne){
                        int offset = [self offsetCalculator:AQI];
                        NSLog(@"Offset: %d",offset);
                        UIImageView *indicator = [[UIImageView alloc]initWithFrame:CGRectMake(255,offset, 160, 30)];
                        
                        [indicator setImage:[[UIImage imageNamed:@"bar_parts-02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                        
                        indicator.tag = 4;
                        
                        [self.view addSubview:indicator];
                        
                    }
                    if(!foundTwo){
                        
                        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(283, 572, 95, 30)];
                        
                        [tf setText:[NSString stringWithFormat:@"%d\n%@",AQI,cityname]];
                        [tf setTextColor:[UIColor whiteColor]];
                        UIFont *font = [UIFont fontWithName:@"Avenir" size:10.0];
                        [tf setFont:font];
                        tf.tag = 5;
                        [self.view addSubview:tf];
                        
                    }

                    
                }];
             
               
                
                
            }
            
        }];
        
        NSLog(@"resuming task");
        
        [task resume];
        
        NSLog(@"task resumed");
        
    }
    else{
        NSLog(@"Nah");
    }
    
    
}

-(int)offsetCalculator:(int)AQI{
    
    int start = 370;
    
    int multiplier = 0;
    
    if(AQI == 0){
        return start;
    }
    else if(AQI >= 0 && AQI <= 50){
        multiplier = 6;
    }
    else if(AQI >= 51 && AQI <= 100){
        multiplier = 5;
    }
    else if(AQI >= 101 && AQI <= 150){
        multiplier = 4;
    }
    else if(AQI >= 151 && AQI <= 200){
        multiplier = 3;
    }
    else if(AQI <= 201 && AQI <= 300){
        multiplier = 2;
    }
    else{
        multiplier = 1;
    }
    
    return start + multiplier * 30;
    
}

-(void)generateButtonsForView {
    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height - 300;
    UIView *initialView = [[UIView alloc] initWithFrame:CGRectMake(arc4random() % (int)viewWidth, arc4random() % (int)viewHeight, 50, 30)];
    initialView.backgroundColor = [UIColor orangeColor];
    [self setRoundedView:initialView toDiameter:15.0f];
    [self setAnimation:initialView withNum:0];
    [self.view addSubview:initialView];
    int numViews = 0;
    while (numViews < 19) {
        BOOL goodView = YES;
        UIView *candidateView = [[UIView alloc] initWithFrame:CGRectMake(arc4random() % (int)viewWidth, arc4random() % (int)viewHeight, 50, 30)];
        candidateView.backgroundColor = [UIColor orangeColor];
        for (UIView *placedView in self.view.subviews) {
            if(placedView.tag != 3 && placedView.tag != 4){
            if (CGRectIntersectsRect(CGRectInset(candidateView.frame, -10, -10), placedView.frame)) {
                goodView = NO;
                break;
            }
            }
        }
        if (goodView) {
        
            [self setAnimation:candidateView withNum:numViews];
            
            [self setRoundedView:candidateView toDiameter:15.0f];
                
        
            [self setRoundedView:candidateView toDiameter:15.0f];
            //NSLog(@"Adding subview");
            [self.view addSubview:candidateView];
            //NSLog(@"Added subview");
            numViews += 1;
        }
    }
}


-(void)setAnimation:(UIView *)view withNum:(int)num{
    
    float duration = 0.5f;
    if(num % 2 == 0){
        duration -= 0.2f;
        
    }
    
    
    
    UIView *bubble = view;
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    [animation setDuration:duration];
    [animation setRepeatCount:HUGE_VALF];
    float bounce = 10.0f;
    if(num % 3 == 0){
        
        bounce = -bounce;
        
    }
    
    [animation setAutoreverses:YES];
    
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([bubble center].x, [bubble center].y - bounce)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([bubble center].x, [bubble center].y + bounce)]];
    [[bubble layer] addAnimation:animation forKey:@"position"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view.layer removeAllAnimations]; // or whatever you need to use to remove your specific animation
}

-(int)getBubbleCount:(int)AQI{
    
    return AQI/10 + 5;
    
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (IBAction)goToMap:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LocationViewController *lvc = [sb instantiateViewControllerWithIdentifier:@"lvc"];
    
    lvc.delegate = self;
    
    [self showViewController:lvc sender:nil];
}

-(void)sendDataBack:(NSDecimalNumber *)lat and:(NSDecimalNumber *)lng withName:(NSString *)name{
    
    
    NSLog(@"Changed pt 1");
    NSString *urlString = @"https://api.breezometer.com/baqi";
    NSLog(@"t1");
    NSString *key = @"7b022bb2e6014358bdc97b60b5ec5912";
    NSLog(@"t2");
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"t3");
 
    if(lat == nil || lng == nil) return;
    
    NSDictionary *params =  @{@"lat" : lat , @"lon" : lng, @"key" : key};
    NSLog(@"t4");
    NSMutableURLRequest *urlRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url.absoluteString parameters:params error:nil];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSLog(@"task being initialized");
    NSLog(@"t5");
    
    
    AFURLSessionManager *sm = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURLSessionDataTask *task = [sm dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        
        if(error){
            NSLog(@"ERROR: %@",[error localizedDescription]);
        }
        else{
            NSLog(@"Changed pt 2");
            NSLog(@"NOT ERROR");
            NSArray *viewsToRemove = [self.view subviews];
            for (UIView *v in viewsToRemove) {
                if(v.tag != 3 && v.tag != 4){
                    [v removeFromSuperview];
                }
            }
            
            
            //NSLog(@"JSON: %@",responseObject);
            
            int AQI = [responseObject[@"breezometer_aqi"] intValue];
            
            NSString *description = responseObject[@"breezometer_description"];
            
            NSString *pollutant = responseObject[@"dominant_pollutant_description"];
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Woah!" message:[NSString stringWithFormat:@"The dominant pollutant is %@",pollutant] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
            
            [controller addAction:action];
            
            [self presentViewController:controller animated:YES completion:nil];
            
            NSString *data = [NSString stringWithFormat:@"AQI : %d\nDescription: %@ ",AQI,description];
            
            
            
            [self generateButtonsForView];
            
            BOOL foundOne = NO;
            BOOL foundTwo = NO;
            for(UIView* v in self.view.subviews){
                if(v.tag == 4){
                
                    int offset = [self offsetCalculator:AQI];
                    NSLog(@"Offset: %d",offset);
                    [v setFrame:CGRectMake(255, offset, 160, 30)];
                    //[v layoutSubviews];
                    foundOne = YES;
                }
                if(v.tag == 5){
                    [(UITextField *)v setText:[NSString stringWithFormat:@"%d\n%@",AQI,name]];
                    foundTwo = YES;
                }
            }
            
            if(!foundOne){
                int offset = [self offsetCalculator:AQI];
                NSLog(@"Offset: %d",offset);
                UIImageView *indicator = [[UIImageView alloc]initWithFrame:CGRectMake(255, offset, 160, 30)];
                
                [indicator setImage:[[UIImage imageNamed:@"bar_parts-02.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                
                indicator.tag = 4;
                
                [self.view addSubview:indicator];
                
            }
            if(!foundTwo){
                
                UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(283, 572, 95, 30)];
                
                [tf setText:[NSString stringWithFormat:@"%d\n%@",AQI,name]];
                [tf setTextColor:[UIColor whiteColor]];
                UIFont *font = [UIFont fontWithName:@"Avenir" size:10.0];
                [tf setFont:font];
                
                tf.tag = 5;
                [self.view addSubview:tf];
                
            }
            
            
        }
        
    }];
    
    NSLog(@"resuming task");
    
    [task resume];
    
    NSLog(@"task resumed");
    

    
}

@end
