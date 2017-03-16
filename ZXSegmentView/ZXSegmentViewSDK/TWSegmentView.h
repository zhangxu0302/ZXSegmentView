//
//  TWSegmentView.h
//  XiaoLuobo
//
//  Created by 张惠杰 on 15/7/6.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWNotifcationRedDot.h"
#import "TWSegmentModel.h"

#define SegmentViewHeight           50.f

typedef NS_ENUM(NSInteger, TWNavSelectedTrigger) {
    TWNavSelectedTrigger_None   = -1,
    TWNavSelectedTrigger_Click  = 0,
    TWNavSelectedTrigger_Scroll = 1,
};

@protocol TWSegmentViewDelegate <NSObject>

- (void)didSelectAction:(NSInteger)tag;

@end

@interface TWSegmentView : UIView

@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<TWSegmentViewDelegate> delegate;
@property (nonatomic, strong) TWNotifcationRedDot *redDot;
@property (nonatomic, assign) TWNavSelectedTrigger selectedTrigger;     // 标记是手动scroll触发, 还是click触发
@property (nonatomic, retain) TWSegmentModel *segmentModel;

- (instancetype)initWithFrame:(CGRect)frame withModel:(TWSegmentModel *)model;

- (void)createNavTagView:(CGRect)frame withModel:(TWSegmentModel *)model;



//左右滑动首页tableView，滑动条滑动到相应菜单
-(void)slideToMenuByIndex:(NSUInteger)index;

/* 仅仅是滑动segment 不触发点击事件 */
-(void)slideToMenuByIndexOnly:(NSUInteger)index;    // 只是滑动, 不触发点击

//可删除某个按钮
- (void)resetMoveSegmentWithTitle:(NSInteger)index WithNewArray:(NSArray *)newArray;

//添加某个按钮
- (void)resetAddSegmentWithTitle:(NSInteger)index WithNewArray:(NSArray *)newArray;

/*可重新设置按钮标题，根据index*/
- (void)resetSegmentTitle:(NSString *)title atIndex:(NSUInteger )index;

/* 是否显示下红点 */
- (void)showRedDot:(BOOL)isShow atIndex:(NSInteger)index;

-(void)invokeSelectItem:(NSUInteger)index;

//控件顶部加上一条灰色线条
-(void)addTopLine:(CGRect)frame withColor:(UIColor *)color;


@end


