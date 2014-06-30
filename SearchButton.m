//
//  SearchButton.m
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/21/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import "SearchButton.h"

@implementation SearchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    int errorMargin = 30;
    CGRect largerFrame = CGRectMake(0 - errorMargin, 0 - errorMargin, self.frame.size.width + errorMargin, self.frame.size.height + errorMargin);
    return (CGRectContainsPoint(largerFrame, point) == 1) ? self : nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
