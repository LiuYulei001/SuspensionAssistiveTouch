//
//  PersonalCenterView.m
//  SuspensionAssistiveTouch
//
//  Created by Rainy on 2017/9/26.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#define kCellIdentifier             @"PersonalCenterCell"
#define kHeaderViewHeight           197


#import "PersonalCenterView.h"

@interface PersonalCenterView ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _backImgHeight;
    CGFloat _backImgWidth;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *sourceArray;

@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIImageView *headerBackView;

@end

@implementation PersonalCenterView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.headerBackView];
        [self addSubview:self.tableView];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.sourceArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *currentViewController = [self currentViewController];
    UIViewController *vc = [[UIViewController alloc]init];
    vc.title = self.sourceArray[indexPath.row];
    vc.view.backgroundColor = [UIColor whiteColor];
    [currentViewController.navigationController pushViewController:vc animated:YES];
    [kNotificationCenter postNotificationName:kSuspensionViewDisNotificationName object:nil];
}

- (UIViewController *)topMostController
{
    UIViewController *topController = [kWindow rootViewController];
    while ([topController presentedViewController]) topController = [topController presentedViewController];
    return topController;
}
- (UIViewController *)currentViewController
{
    UIViewController *currentViewController = [self topMostController];
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    return currentViewController;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (contentOffsety < 0)
    {
        CGRect rect = self.headerBackView.frame;
        rect.size.height = _backImgHeight - contentOffsety;
        rect.size.width = _backImgWidth * (_backImgHeight - contentOffsety) / _backImgHeight;
        rect.origin.x =  - (rect.size.width - _backImgWidth) / 2;
        rect.origin.y = 0;
        _headerBackView.frame = rect;
        
    }else
    {
        CGRect rect = self.headerBackView.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = - contentOffsety;
        _headerBackView.frame = rect;
        
    }
}


#pragma mark - lazy
-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier: kCellIdentifier];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}
-(UIImageView *)headerBackView
{
    if (!_headerBackView) {
        
        _headerBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeaderViewIMG.size.height)];
        _headerBackView.image = kHeaderViewIMG;

        _backImgHeight = _headerBackView.bounds.size.height;
        _backImgWidth = _headerBackView.bounds.size.width;
        
    }
    return _headerBackView;
}
-(UIView *)headerView
{
    if (!_headerView) {
        
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, kHeaderViewIMG.size.height)];
        _headerView.backgroundColor = [UIColor clearColor];
        UIImageView *header = [[UIImageView alloc]initWithFrame:CGRectMake(27, kHeaderViewHeight - 22 - kHeaderIMG.size.height, kHeaderIMG.size.width, kHeaderIMG.size.height)];
        header.contentMode = UIViewContentModeScaleAspectFit;
        header.image = kHeaderIMG;
        
        [_headerView addSubview:header];
    }
    return _headerView;
}
-(NSArray *)sourceArray
{
    if (!_sourceArray) {
        
        _sourceArray = @[
                         @"了解会员特权",
                         @"钱包",
                         @"个性装扮",
                         @"我的收藏",
                         @"我的相册",
                         @"我的文件",
                         @"免流量特权"
                         ];
    }
    return _sourceArray;
}


@end
