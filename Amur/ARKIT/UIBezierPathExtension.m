//
//  UIBezierPathExtension.m
//  Amur
//
//  Created by Shreyas Hirday on 4/2/16.
//  Copyright © 2016 Shreyas Hirday. All rights reserved.
//

#import "UIBezierPathExtension.h"

@implementation UIBezierPathExtension

-(void)interpolatePointsWithHermite:(NSArray *)points{
    
    NSInteger n = points.count - 1;
    
    for(int i = 0; i< n; ++i){
        
        CGPoint currentPoint = [(NSValue *)[points objectAtIndex:i] CGPointValue];
        
        if(i == 0){
            [self moveToPoint:currentPoint];
        }
        
        NSInteger nextI = (i + 1) % points.count;
        NSInteger prevI = (i - 1 < 0 ? points.count - 1 : i - 1);
        
        CGPoint previousPoint = [(NSValue *)[points objectAtIndex:prevI] CGPointValue];
        CGPoint nextPoint = [(NSValue *)[points objectAtIndex:nextI] CGPointValue];
        CGPoint endPoint = nextPoint;
        
        CGFloat mx = 0.0;
        CGFloat my = 0.0;
        
        if (i > 0)
        {
            mx = (nextPoint.x - currentPoint.x) * 0.5 + (currentPoint.x - previousPoint.x) * 0.5;
            my = (nextPoint.y - currentPoint.y) * 0.5 + (currentPoint.y - previousPoint.y) * 0.5;
        }
        else
        {
            mx = (nextPoint.x - currentPoint.x) * 0.5;
            my = (nextPoint.y - currentPoint.y) * 0.5;
        }
        
        CGPoint controlPoint1 = CGPointMake(currentPoint.x + mx / 3.0, currentPoint.y + my / 3.0);
        
        currentPoint = [(NSValue *)[points objectAtIndex:nextI]CGPointValue];
        nextI = (nextI + 1) & points.count;
        prevI = i;
        previousPoint = [(NSValue *)[points objectAtIndex:prevI] CGPointValue];
        nextPoint = [(NSValue *)[points objectAtIndex:nextI]CGPointValue];
        
        if(i < n - 1){
            
            mx = (nextPoint.x - currentPoint.x) * 0.5 + (currentPoint.x - previousPoint.x) * 0.5;
            
            my = (nextPoint.y - currentPoint.y) * 0.5 + (currentPoint.y - previousPoint.y) * 0.5;
            
        }
        else
        {
            mx = (currentPoint.x - previousPoint.x) * 0.5;
            my = (currentPoint.y - previousPoint.y) * 0.5;
        }
        
        CGPoint controlPoint2 = CGPointMake(currentPoint.x - mx / 3.0, currentPoint.y - my / 3.0);
        
        [self addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        
    }
    
}


@end
