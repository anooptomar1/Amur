//
//  RealWIYAViewController.m
//  Amur
//
//  Created by Shreyas Hirday on 4/2/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

#import "RealWIYAViewController.h"
#import "HexColors.h"

@interface RealWIYAViewController ()

@property(strong, nonatomic) NSMutableArray *particles;

@end

@implementation RealWIYAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor hx_colorWithHexString:@"3b1c27"] CGColor], (id)[[UIColor hx_colorWithHexString:@"1a1c25"] CGColor], nil];
    
    
    
    [self.view.layer addSublayer:gradient ];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 300, 30)];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"What's in my air?"];
    
    UIFont *font = [UIFont fontWithName:@"Avenir" size:15.0];
    [label setFont:font];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 100, 350, 450) collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    self.particles = [[NSMutableArray alloc]init];
    
    
    [self.view addSubview:label];
    [self.view addSubview:self.collectionView];
    
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
 
    return 6; //self.particles.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if(cell == nil){
        
        cell = [[UICollectionViewCell alloc]init];
        
    }
    
    //customize cell here
    cell.backgroundColor = [UIColor clearColor];
    
    cell.layer.borderColor = [UIColor orangeColor].CGColor;
    cell.layer.borderWidth = 1.0f;
    
    UILabel *particleName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 140, 20)];
    
     UIFont *font = [UIFont fontWithName:@"Avenir" size:12.0];
    
    [particleName setFont:font];
    
    [particleName setText:@"PARTICLE NAME"];
    
    UILabel *particleDescription = [[UILabel alloc] initWithFrame:CGRectMake(2, 30, 140, 60)];
    
    
    
    UIFont *smallFont = [UIFont fontWithName:@"Avenir" size:8.0];
    
    [particleDescription setFont:smallFont];
    
    particleDescription.numberOfLines = 0;
    //[particleDescription sizeToFit];
    
    [particleName setTextColor:[UIColor whiteColor]];
    [particleDescription setTextColor:[UIColor whiteColor]];
    
    [particleDescription setText:@"whdwuadowadhahausdhausdhaksdhaskjdhaksdkajdhkasjhdkasjdhkasjdhkajsdhkasjdhkaadasdas"];
    
    [cell addSubview:particleName];
    [cell addSubview:particleDescription];
    
    
    
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(175, 100);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
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
