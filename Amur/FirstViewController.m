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

@interface FirstViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

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
    
    if(abs(howRecent) < 15.0){
        
        
        NSString *urlString = @"https://api.breezometer.com/baqi";
        
        NSString *key = @"7b022bb2e6014358bdc97b60b5ec5912";
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
        NSNumber *lon = [NSNumber numberWithDouble:location.coordinate.longitude];
        
        NSDictionary *params =  @{@"lat" : lat, @"lon" : lon, @"key" : key};
        
        NSMutableURLRequest *urlRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url.absoluteString parameters:params error:nil];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        AFURLSessionManager *sm = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
        
        NSURLSessionDataTask *task = [sm dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if(error){
                NSLog(@"ERROR: %@",error);
            }
            else{
                
                NSArray *viewsToRemove = [self.view subviews];
                for (UIView *v in viewsToRemove) {
                    [v removeFromSuperview];
                }

                
                NSLog(@"JSON: %@",responseObject);
                
                int AQI = [responseObject[@"breezometer_aqi"] intValue];
                
                NSString *description = responseObject[@"breezometer_description"];
                
                NSString *data = [NSString stringWithFormat:@"AQI : %d\nDescription: %@ ",AQI,description];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hello!" message:data preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okayBtn = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
                
                [alert addAction:okayBtn];
                
                int start = 10;
                int diff = 50;
                int origin = 60;
                int yDiff = 10;
                int numOfBubbles = [self getBubbleCount:AQI];
                
               
                
                for(int i = 0; i < numOfBubbles; i++){
                    
                    int y = origin;
                    
                    if(i % 2 != 0){
                        y -= yDiff;
                    }
                    float duration = 0.5f;
                    if(i % 2 == 0){
                        duration -= 0.2f;
                        
                    }
                    
                  
                    
                    UIView *bubble = [[UITextField alloc] initWithFrame:CGRectMake(start, y, 30, 30)];
                    
                    [bubble setBackgroundColor:[UIColor orangeColor]];
                    
                    
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
                    
                    [animation setDuration:duration];
                    [animation setRepeatCount:HUGE_VALF];
                    float bounce = 10.0f;
                    if(i % 3 == 0){
                        
                        bounce = -bounce;
                        
                    }
                    
                    [animation setAutoreverses:YES];
                    
                    [animation setFromValue:[NSValue valueWithCGPoint:
                                             CGPointMake([bubble center].x, [bubble center].y - bounce)]];
                    [animation setToValue:[NSValue valueWithCGPoint:
                                           CGPointMake([bubble center].x, [bubble center].y + bounce)]];
                    [[bubble layer] addAnimation:animation forKey:@"position"];
                    
                    [self setRoundedView:bubble toDiameter:15.0f];
                    
                    [self.view addSubview:bubble];
                    
                    start += diff;

                }
                
                
                
                //[self presentViewController:alert animated:YES completion:nil];
                
                
            }
            
        }];
        
        [task resume];
        
        
    }
    
    
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
