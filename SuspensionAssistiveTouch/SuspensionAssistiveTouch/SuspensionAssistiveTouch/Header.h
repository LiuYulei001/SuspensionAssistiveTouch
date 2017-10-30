//
//  Header.h
//  SuspensionAssistiveTouch
//
//  Created by Rainy on 2017/10/30.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "UIView+Extension.h"
#define kSuspensionViewDisNotificationName    @"SUSPENSIONVIEWDISAPPER_NOTIFICATIONNAME"
#define  kSuspensionViewShowNotificationName  @"SUSPENSIONVIEWSHOW_NOTIFICATIONNAME"

#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kWindow          [[UIApplication sharedApplication].windows firstObject]
#define kScreenBounds    [[UIScreen mainScreen] bounds]
#define kScreenWidth     kScreenBounds.size.width
#define kScreenHeight    kScreenBounds.size.height

#define kAssistiveTouchIMG          [UIImage imageNamed:@"icon.png"]
#define kHeaderViewIMG              [UIImage imageNamed:@"header"]
#define kHeaderIMG                  [UIImage imageNamed:@"touxiang"]

#define kAlpha                0.5
#define kPrompt_DismisTime    0.2
#define kProportion           0.82

#endif /* Header_h */
