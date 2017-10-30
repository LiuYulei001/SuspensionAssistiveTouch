//
//  PersonalCenterMainView.m
//  SuspensionAssistiveTouch
//
//  Created by Rainy on 2017/9/26.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "PersonalCenterMainView.h"
#import "PersonalCenterView.h"

@interface PersonalCenterMainView ()

@property(nonatomic,strong)PersonalCenterView *personalCenterView;

@end

@implementation PersonalCenterMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.personalCenterView];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    switch (pan.state) {
        case UIGestureRecognizerStateChanged:
            
            [self commitTranslation:[pan translationInView:self]];
            
            [pan setTranslation:CGPointZero inView:self];
            
            break;
        case UIGestureRecognizerStateEnded:
            
            if (CGRectGetMaxX(pan.view.frame) < (kScreenWidth * kProportion)/2) {
                
                [kNotificationCenter postNotificationName:kSuspensionViewDisNotificationName object:nil];
            }else
            {
                [kNotificationCenter postNotificationName:kSuspensionViewShowNotificationName object:nil];
            }
            
            break;
            
        default:
            break;
    }
    
}

- (void)commitTranslation:(CGPoint)translation
{
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    if (absX > absY) {
        
        if (translation.x < 0) {
            
            self.X += translation.x;
            
        }else{
            
            [UIView animateWithDuration:kPrompt_DismisTime animations:^{
                
                self.X = 0;
            }];
        }
        
    }
}

#pragma mark - lazy
-(PersonalCenterView *)personalCenterView
{
    if (!_personalCenterView) {
        
        _personalCenterView = [[PersonalCenterView alloc]initWithFrame:self.bounds];
    }
    return _personalCenterView;
}

@end
