//
//  WIYAViewController.m
//  Amur
//
//  Created by Shreyas Hirday on 3/26/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//


/****this is actually "how I can help"*****/

#import "WIYAViewController.h"
#import "HexColors.h"
#import <QuartzCore/QuartzCore.h>

@interface WIYAViewController ()

@end

@implementation WIYAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];

    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 160, 350, 450) collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 60, 350, 30)];
    [label setText:@"How Can I Help?"];
    [label setTextColor:[UIColor whiteColor]];
    
    UIView *pinkBox = [[UIView alloc]initWithFrame:CGRectMake(5, 100, 350, 40) ];
    [pinkBox setBackgroundColor:[UIColor hx_colorWithHexString:@"cb314b"]];
    pinkBox.layer.cornerRadius = 4;
    pinkBox.clipsToBounds = YES;
    
    UILabel *desc = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 5, 40)];
    [desc setTextColor:[UIColor whiteColor]];
    [desc setBackgroundColor:[UIColor clearColor]];
    
    [desc setText:@"There are tons of small lifestyle changes that can be done to help reduce the amount of air\n pollution in our atmosphere and the best part is: it all starts at home!"];
    [desc sizeToFit];
    desc.numberOfLines = 0;
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont fontWithName:@"Avenir" size:8.0];
    [desc setFont:font];
    
    
    
    [pinkBox addSubview:desc];
    
   
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor hx_colorWithHexString:@"3b1c27"] CGColor], (id)[[UIColor hx_colorWithHexString:@"1a1c25"] CGColor], nil];
    
    
    
    [self.view.layer addSublayer:gradient ];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:label];
    [self.view addSubview:pinkBox];
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    if(cell == nil){
        
        cell = [[UICollectionViewCell alloc] init];
        
        
    }
    
   
    
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [backgroundImage setImage:[UIImage imageNamed:[[[self class]imageNames] objectAtIndex:indexPath.row]]];
    
    cell.backgroundView = backgroundImage;
     
    
    
    
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.backgroundView = nil;
    
    NSLog(@"index: %ld",(long)indexPath.row);
    
    
    if(indexPath.row == 0){
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"f78e57"];
    }
    else if(indexPath.row == 1){
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"f07f55"];
    }
    else if(indexPath.row == 2){
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"eb7454"];
    }
    else if(indexPath.row == 3){
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"dc5450"];
    }
    else if(indexPath.row == 4){
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"dc5450"];
    }
    else if(indexPath.row == 5){
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"e66952"];
    }
    else if(indexPath.row == 6){
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"d74a4e"];
    }
    else if(indexPath.row == 7){
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"d13e4d"];
    }
    else if(indexPath.row == 8){
        cell.backgroundColor = [UIColor hx_colorWithHexString:@"cb314b"];
    }
     
    
    
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    
    box.layer.borderColor = [UIColor whiteColor].CGColor;
    box.layer.borderWidth = 1.0f;
    
    box.tag = 3;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
    [label setText:[[[self class] facts] objectAtIndex:indexPath.row]];
    UIFont *font = [UIFont fontWithName:@"Avenir" size:6.0];
    [label setFont:font];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor whiteColor]];
    label.tag = 4;
    [label sizeToFit];
    [cell addSubview:box];
    [cell addSubview:label];
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    for(UIView *view in cell.subviews){
        if(view.tag == 3 || view.tag == 4){
            [view removeFromSuperview];
        }
    }
    
   
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    NSString *string = [[[self class] imageNames] objectAtIndex:indexPath.row];
    NSLog(@"Image name: %@ for index %ld",string,indexPath.row);
    [backgroundImage setImage:[UIImage imageNamed:string]];
    cell.backgroundView = backgroundImage;
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(100, 100);
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+(NSArray *)facts{
    static NSArray *_facts;
    static dispatch_once_t oneT;
    dispatch_once(&oneT, ^{
        
        _facts = @[@"Conserve energy - turn off appliances and lights when you leave the room", @"Recycle paper, plastic, glass bottles, cardboard, and aluminum cans. (This conserves energy and reduces production emissions.)", @"Buy green electricity-produced by low-or even zero-pollution facilities",@"Wash clothes with warm or cold water instead of hot",@"Lower the thermostat on your water heater to 120F",@"Plant deciduous trees in locations around your home to provide shade in the summer, but to allow light in the winter",@"Buy ENERGY STAR products, including energy efficient lighting and appliances. They are environmentally friendly products.", @"Choose efficient, low-polluting models of vehicles", @"Choose products that have less pacakaging and are re-usable"];
        
    });
    
    return _facts;
}

+ (NSArray *)imageNames
{
    static NSArray *_titles;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _titles = @[@"IMG_1750.PNG",@"IMG_1749.PNG",@"IMG_1748.PNG",@"IMG_1747.PNG",@"IMG_1746.PNG",@"IMG_1745.PNG",@"IMG_1744.PNG",@"IMG_1743.PNG",@"IMG_1742.PNG"];
    });
    return _titles;
}

@end
