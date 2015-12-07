//
//  DropItBehavior.m
//  方块块块块块
//
//  Created by TheSix on 8/24/15.
//  Copyright (c) 2015 OCLearning. All rights reserved.
//

#import "DropItBehavior.h"

@interface DropItBehavior()
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;
//@property (strong, nonatomic) UIDynamicItemBehavior *animationOptions;
@end

@implementation DropItBehavior
#pragma mark - getter
//重力
- (UIGravityBehavior *)gravity {
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.9; //滑块重力
    }
    return _gravity;
}
//边界
- (UICollisionBehavior *)collider {
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}
//禁止方块旋转
/*
- (UIDynamicItemBehavior *)animationOptions {
    if (!_animationOptions) {
        _animationOptions = [[UIDynamicItemBehavior alloc] init];
        _animationOptions.allowsRotation = NO;
    }
    return _animationOptions;
}
*/
#pragma mark -
- (void) addItem: (id<UIDynamicItem>)item {
    [self.gravity addItem:item];
    [self.collider addItem:item];
//    [self.animationOptions addItem:item];
}
- (void) removeItem: (id<UIDynamicItem>)item {
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
//    [self.animationOptions removeItem:item];
}

#pragma mark -
- (instancetype) init {
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collider];
//    [self addChildBehavior:self.animationOptions];
    return self;
}

@end
