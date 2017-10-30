//
//  SuspensionAssistiveTouch.m
//  SuspensionAssistiveTouch
//
//  Created by Rainy on 2017/9/20.
//  Copyright © 2017年 Rainy. All rights reserved.
//



#import "SuspensionAssistiveTouch.h"
#import "PersonalCenterMainView.h"


@interface SuspensionAssistiveTouch ()
{
    UIButton *_touchButton;
}

@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)PersonalCenterMainView *topView;

@end

@implementation SuspensionAssistiveTouch

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.windowLevel = UIWindowLevelAlert + 1;
        [self makeKeyAndVisible];
        
        _touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touchButton setBackgroundImage:kAssistiveTouchIMG forState:UIControlStateNormal];
        [_touchButton setBackgroundImage:kAssistiveTouchIMG forState:UIControlStateDisabled];
        [_touchButton setBackgroundImage:kAssistiveTouchIMG forState:UIControlStateHighlighted];
        _touchButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [_touchButton addTarget:self action:@selector(suspensionAssistiveTouch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_touchButton];
        
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
        [_touchButton addGestureRecognizer:pan];
        
        self.alpha = 1;
        [self performSelector:@selector(setAlpha) withObject:nil afterDelay:3];
        
        [kNotificationCenter addObserver:self selector:@selector(disapper:) name:kSuspensionViewDisNotificationName object:nil];
        [kNotificationCenter addObserver:self selector:@selector(suspensionAssistiveTouch) name:kSuspensionViewShowNotificationName object:nil];
    }
    return self;
}


-(void)suspensionAssistiveTouch {

    [kWindow addSubview:self.backView];
    [kWindow addSubview:self.topView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        
        _topView.X = 0;
        self.alpha = 0;
        _backView.alpha = kAlpha;
        
    } completion:^(BOOL finished) {
        
        [kWindow endEditing:YES];
    }];
}
-(void)disapper:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        
        self.topView.X = -kScreenWidth * kProportion;
        self.alpha = 1;
        [self performSelector:@selector(setAlpha) withObject:nil afterDelay:3];
        self.backView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.topView.X = -kScreenWidth * kProportion;
        self.backView.alpha = 0;
        
        [self.topView removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

-(void)changePostion:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect originalFrame = self.frame;
    if (originalFrame.origin.x >= 0 && originalFrame.origin.x+originalFrame.size.width <= width) {
        originalFrame.origin.x += point.x;
    }
    if (originalFrame.origin.y >= 0 && originalFrame.origin.y+originalFrame.size.height <= height) {
        originalFrame.origin.y += point.y;
    }
    self.frame = originalFrame;
    [pan setTranslation:CGPointZero inView:self];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self beginPoint];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self changePoint];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self endPoint];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self endPoint];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)beginPoint {
    
    _touchButton.enabled = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        
        self.alpha = 1.0;
    }];
}
- (void)changePoint {
    
    BOOL isOver = NO;
    
    CGRect frame = self.frame;
    
    if (frame.origin.x < 0) {
        frame.origin.x = 0;
        isOver = YES;
    } else if (frame.origin.x+frame.size.width > kWindow.Sw) {
        frame.origin.x = kWindow.Sw - frame.size.width;
        isOver = YES;
    }
    
    if (frame.origin.y < 0) {
        frame.origin.y = 0;
        isOver = YES;
    } else if (frame.origin.y+frame.size.height > kWindow.Sh) {
        frame.origin.y = kWindow.Sh - frame.size.height;
        isOver = YES;
    }
    if (isOver) {
        [UIView animateWithDuration:kPrompt_DismisTime animations:^{
            self.frame = frame;
        }];
    }
    _touchButton.enabled = YES;
    
}
static CGFloat _allowance = 30;
- (void)endPoint {
    
    if (self.X <= kWindow.Sw / 2 - self.Sw/2) {
        
        if (self.Y >= kWindow.Sh - self.Sh - _allowance) {
            self.Y = kWindow.Sh - self.Sh;
        }else
        {
            if (self.Y <= _allowance) {
                self.Y = 0;
            }else
            {
                self.X = 0;
            }
        }
        
    }else
    {
        if (self.Y >= kWindow.Sh - self.Sh - _allowance) {
            self.Y = kWindow.Sh - self.Sh;
        }else
        {
            if (self.Y <= _allowance) {
                self.Y = 0;
            }else
            {
                self.X = kWindow.Sw - self.Sw;
            }
        }
    }
    
    _touchButton.enabled = YES;
    [self performSelector:@selector(setAlpha) withObject:nil afterDelay:3];
}
-(void)setAlpha {
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        
        self.alpha = kAlpha;
    }];
}
-(void)setX:(CGFloat)X
{
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        
        [super setX:X];
    }];
}
-(void)setY:(CGFloat)Y
{
    [UIView animateWithDuration:kPrompt_DismisTime animations:^{
        
        [super setY:Y];
    }];
}
#pragma mark - lazy
-(UIView *)backView
{
    if (!_backView) {
        
        _backView = [[UIView alloc]initWithFrame:kScreenBounds];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disapper:)];
        _backView.userInteractionEnabled = YES;
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}
-(PersonalCenterMainView *)topView
{
    if (!_topView) {
        
        _topView = [[PersonalCenterMainView alloc]initWithFrame:CGRectMake(-kScreenWidth * kProportion, 0, kScreenWidth * kProportion, kScreenHeight)];
    }
    return _topView;
}

@end
