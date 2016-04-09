//
//  UIBezierPathExtension.h
//  Amur
//
//  Created by Shreyas Hirday on 4/2/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPathExtension : UIBezierPath

-(void)interpolatePointsWithHermite:(NSArray *)points;

@end
