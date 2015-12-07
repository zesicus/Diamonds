//
//  BezierPathView.m
//  方块块块块块
//
//  Created by TheSix on 8/26/15.
//  Copyright (c) 2015 OCLearning. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

- (void)setPath:(UIBezierPath *)path {
    _path = path;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self.path stroke];
}

@end
