//
//  LocationViewController.m
//  Amur
//
//  Created by Shreyas Hirday on 2/27/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

#import "LocationViewController.h"
#import "FirstViewController.h"
#import "GodViewController.h"



@interface LocationViewController ()


@property(strong,nonatomic) NSMutableArray *results;
@property(strong,nonatomic) NSMutableArray *resultLocations;

@property(strong,nonatomic) NSDecimalNumber *lt;
@property(strong,nonatomic) NSDecimalNumber *lg;
@property(strong,nonatomic) NSNumber *ch;
@property(strong,nonatomic) NSString *name;

@end

@implementation LocationViewController

bool lock = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _map.delegate = self;
    _map.showsUserLocation = YES;
    
    
    
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(20, 80, 240, 80)];
    
    [searchView setBackgroundColor:[UIColor orangeColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 100, 20)];
    [label setText:@"Location"];
    
    UITextField *locationSearch = [[UITextField alloc] initWithFrame:CGRectMake(30, 45, 200, 25)];
    
    locationSearch.delegate = self;
    
    [locationSearch setBorderStyle:UITextBorderStyleRoundedRect];
    
    [locationSearch setPlaceholder:@"Location Search"];
    
    [searchView addSubview:label];
    [searchView addSubview:locationSearch];
    
    [self.view addSubview:searchView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if(!lock){
    
        MKCoordinateRegion mapRegion;
        mapRegion.center = _map.userLocation.coordinate;
        mapRegion.span.latitudeDelta = 0.2;
        mapRegion.span.longitudeDelta = 0.2;
    
        [_map setRegion:mapRegion animated: YES];
    
        lock = YES;
        
    }

    
}

-(void)search:(NSString *)query{
    
    CLGeocoder* geocoder = [[CLGeocoder alloc]init];
    
    [geocoder geocodeAddressString:query completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        _results = [[NSMutableArray alloc]init];
        _resultLocations = [[NSMutableArray alloc]init];
    
        
        for(CLPlacemark *pl in placemarks)
        {
            
            NSString *result = [NSString stringWithFormat:@"%@, %@, %@",pl.locality,pl.administrativeArea,pl.country];
            
            NSLog(@"%@",result);
            
            [_results addObject:result];
            [_resultLocations addObject:pl];
        }
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 160, 240.0, 50)];
         tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        
        
        
        [self.view addSubview:tableView];
        
        NSLog(@"Count: %d",_results.count);
        
        [tableView reloadData];
        
        
        
        
    }];
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"rc %d", _results.count);
    
    return _results.count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CLPlacemark *placemark = [_resultLocations objectAtIndex:indexPath.row];
    
    NSLog(@"double check: %d",_resultLocations.count);
    
    CLLocation *location = placemark.location;

    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.05, .05));
    
    NSLog(@"coord for %@: %f,%f",placemark.locality,location.coordinate.latitude,location.coordinate.longitude);
    
    self.name = placemark.locality;
    
    [_map setRegion:region animated:YES];
    
    
    self.lt = [[NSDecimalNumber alloc]initWithDouble:location.coordinate.latitude];
    if(self.lt == nil){
        NSLog(@"lt nil here! %f",location.coordinate.latitude);
    }
    else{
        NSLog(@"lt not nil here");
    }
    self.lg = [[NSDecimalNumber alloc]initWithDouble:location.coordinate.longitude];
    self.ch = [NSNumber numberWithBool:YES];
    
    
    
    
    
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    NSLog(@"Count: %d",_results.count);

    
     NSString * r = [_results objectAtIndex:indexPath.row];
    
    NSLog(@"setting text: %@",r);
    
   
    
    [cell.textLabel setText:r];
    
    return cell;
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *text = [textField text];
    
    [self search:text];
    
    return YES;
}

@synthesize delegate;
-(void)viewWillDisappear:(BOOL)animated{
    
    [delegate sendDataBack:self.lt and:self.lg withName:self.name];
    
}

#pragma mark - Navigation




@end
