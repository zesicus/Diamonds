//
//  DropItBehavior.h
//  方块块块块块
//
//  Created by TheSix on 8/24/15.
//  Copyright (c) 2015 OCLearning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropItBehavior : UIDynamicBehavior

- (void) addItem: (id<UIDynamicItem>)item;
- (void) removeItem: (id<UIDynamicItem>)item;

@end
