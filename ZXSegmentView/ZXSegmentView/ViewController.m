//
//  ViewController.m
//  ZXSegmentView
//
//  Created by 张旭 on 17/3/16.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "ViewController.h"
#import "ZXSegmentView.h"
#import "ZXSegmentModel.h"
#import "ZXScrollView.h"

#define currentDeviceHeight ([UIScreen mainScreen].bounds.size.height)
#define currentDeviceWidth  ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()<ZXSegmentViewDelegate, ZXScrollViewDelegate> {
    ZXSegmentView *segmentView;
    ZXScrollView *scrollView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"选项一", @"选项二", @"选项三"];
    
    // 第一种样式
    ZXSegmentModel *segment_model = [[ZXSegmentModel alloc] initWithTitles:titles LineColor:[UIColor blueColor] TitleColor:[UIColor redColor] TitleFont:[UIFont systemFontOfSize:14] IsShowLine:NO IsCalculateByTitle:NO Space:0 FromFrontDistance:0 SliderWidthByTitle:YES IsCreateRedDot:NO];
    
    // 第二种样式
//    CGFloat space = ([UIScreen mainScreen].bounds.size.width/3-14*3);
//    ZXSegmentModel *segment_model = [[ZXSegmentModel alloc] initWithTitles:titles LineColor:[UIColor blueColor] TitleColor:[UIColor grayColor] TitleFont:[UIFont systemFontOfSize:14] IsShowLine:YES IsCalculateByTitle:NO Space:space FromFrontDistance:0 SliderWidthByTitle:NO IsCreateRedDot:NO];
    
    
    segmentView = [[ZXSegmentView alloc] initWithFrame:CGRectMake(0, 64, currentDeviceWidth, SegmentViewHeight) withModel:segment_model];
    segmentView.backgroundColor = [UIColor whiteColor];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    
    // 如果顶部加一条分割线，调此方法
    [segmentView addTopLine:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, .5f) withColor:[UIColor blueColor]];
    
    CGRect rect = CGRectMake(0, SegmentViewHeight+64, currentDeviceWidth, currentDeviceHeight-64-SegmentViewHeight);
    scrollView = [[ZXScrollView alloc] initWithFrame:rect];
    scrollView.contentSize = CGSizeMake(currentDeviceWidth * titles.count, currentDeviceHeight-64-SegmentViewHeight);
    scrollView.myDelegate = self;
    [self.view addSubview:scrollView];
    
    [self createViewIndex:0];
}

- (void)createViewIndex:(NSInteger)index {
    CGFloat orgin_x = index * currentDeviceWidth;
    CGRect rect = CGRectMake(orgin_x, 0, currentDeviceWidth, currentDeviceHeight-64-SegmentViewHeight);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    if (index == 0) {
        view.backgroundColor = [UIColor redColor];
    } else if (index == 1) {
        view.backgroundColor = [UIColor greenColor];
    } else if (index == 2) {
        view.backgroundColor = [UIColor blueColor];
    }
    [scrollView addSubview:view];
    [scrollView.viewsMap setObject:[NSString stringWithFormat:@"%zd", index] forKey:@(index)];
}

#pragma mark - ZXSegmentViewDelegate
- (void)didSelectAction:(NSInteger)tag {
    scrollView.currentIndex = tag;
    [scrollView setContentOffset:CGPointMake(tag * currentDeviceWidth, 0) animated:YES];
}

#pragma mark - ZXScrollViewDelegate
- (void)createViewByIndex:(NSInteger)index {
    [self createViewIndex:index];
}

- (void)ChangeSegmentViewMenuWithIndex:(NSInteger)index {
    [segmentView slideToMenuByIndexOnly:index];
}


@end
