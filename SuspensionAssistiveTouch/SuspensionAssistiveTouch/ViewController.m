//
//  ViewController.m
//  SuspensionAssistiveTouch
//
//  Created by Rainy on 2017/10/30.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "ViewController.h"
#import "SuspensionAssistiveTouch.h"

@interface ViewController ()
{
    SuspensionAssistiveTouch * _assistiveTouch;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    [self performSelector:@selector(setAssistiveTouch) withObject:nil afterDelay:1];
}

#pragma mark - AssistiveTouch
-(void)releseAssistiveTouch
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    if (windows.count > 1) {
        
        SuspensionAssistiveTouch *touchView = [windows lastObject];
        [touchView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        touchView = nil;
    }
}
#pragma mark - AssistiveTouch
- (void)setAssistiveTouch
{
    _assistiveTouch = [[SuspensionAssistiveTouch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height/2-25, 50, 50)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
