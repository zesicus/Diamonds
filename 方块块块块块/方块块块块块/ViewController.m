//
//  ViewController.m
//  方块块块块块
//
//  Created by TheSix on 8/24/15.
//  Copyright (c) 2015 OCLearning. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet BezierPathView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropItBehavior *dropItBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *droppingView;
@end

@implementation ViewController

#pragma mark - properties
static const CGSize DROP_SIZE = {40, 40};

#pragma mark - 动画效果
- (UIDynamicAnimator *)animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_gameView];
        _animator.delegate = self;
    }
    return _animator;
}

- (DropItBehavior *)dropItBehavior {
    if (!_dropItBehavior) {
        _dropItBehavior = [[DropItBehavior alloc] init];
        [self.animator addBehavior:_dropItBehavior];
    }
    return _dropItBehavior;
}

#pragma mark - 游戏主体
//手势，点击屏幕
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

//手势，滑块跟随手势移动
- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachmentDroppingViewToPoint:gesturePoint];
    } else if (sender.state == UIGestureRecognizerStateChanged){
        self.attachment.anchorPoint = gesturePoint;
    } else if (sender.state == UIGestureRecognizerStateEnded){
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}
//吸附行为
- (void)attachmentDroppingViewToPoint:(CGPoint)anchorPoint {
    if (self.droppingView) {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:anchorPoint];
        //手指拖动处和滑块连线
        UIView *droppingView = self.droppingView;
        __weak ViewController *weakSelf = self;//创建weak指针防止强引用
        self.attachment.action = ^{
            UIBezierPath *path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];
            weakSelf.gameView.path = path;
        };
        //不允许滑块移动中掉落继续移动
        self.droppingView = nil;
        
        [self.animator addBehavior:self.attachment];
    }
}

//滑块掉落方法
- (void) drop {
//    掉落方块属性
    //设置框架
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random() % (int)self.gameView.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    //画图
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [_gameView addSubview:dropView];
    //抓取掉落的视图
    self.droppingView = dropView;
//    应用动画效果
    [self.dropItBehavior addItem:dropView];
}
//随机方块颜色
- (UIColor *)randomColor {
    switch (arc4random()%5) {
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self removeCompleteRows];
}

- (BOOL) removeCompleteRows {
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];//需要移除的队列
    for (CGFloat y = self.gameView.bounds.size.height - DROP_SIZE.height/2; y > 0; y -= DROP_SIZE.height) {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];//发现需要移除的队列
        for (CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width - DROP_SIZE.width/2; x += DROP_SIZE.width) {
            //检查整个视图，如果有整行的，加入移除队列
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) break;
        if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    //删除存储在dropsToRemove中的滑块，炸掉滑块
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropItBehavior removeItem:drop];
        }
        [self animatorRemovingDrops: dropsToRemove];
    }
    
    return NO;
}
//炸掉滑块动画效果
- (void) animatorRemovingDrops: (NSArray *)dropsToRemove {
    [UIView animateWithDuration:1.0
                    //动画效果
                     animations:^{
                         for (UIView *drop in dropsToRemove) {
                             int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
                             int y = self.gameView.bounds.size.height;
                             drop.center = CGPointMake(x, -y);
                         }
                     }
                    //从视图清除整行的滑块
                     completion:^(BOOL finished){
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }
     ];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
