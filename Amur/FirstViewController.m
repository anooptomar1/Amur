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

@interface FirstViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated{
   
    
    int i = 0;
    for(UIView *view in [self.view subviews]){
        [self setAnimation:view withNum:i];
        i++;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   self.sidebarButton.image = [[UIImage imageNamed:@"top_bar_icons-07.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
    ;
    

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
    
    if(abs(howRecent) > 5.0){
        
        
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
                    [v removeFromSuperview];
                }

                
                //NSLog(@"JSON: %@",responseObject);
                
                int AQI = [responseObject[@"breezometer_aqi"] intValue];
                
                NSString *description = responseObject[@"breezometer_description"];
                
                NSString *data = [NSString stringWithFormat:@"AQI : %d\nDescription: %@ ",AQI,description];
                
                
          
                [self generateButtonsForView:AQI];
             
                
              
                
                
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

-(void)generateButtonsForView:(int)AQI {
    float viewWidth = self.view.frame.size.width - 50;
    float viewHeight = self.view.frame.size.height - 30;
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
            if (CGRectIntersectsRect(CGRectInset(candidateView.frame, -10, -10), placedView.frame)) {
                goodView = NO;
                break;
            }
        }
        if (goodView) {
        
            [self setAnimation:candidateView withNum:numViews];
            
            [self setRoundedView:candidateView toDiameter:15.0f];
                
        
            [self setRoundedView:candidateView toDiameter:15.0f];
            [self.view addSubview:candidateView];
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

@end
