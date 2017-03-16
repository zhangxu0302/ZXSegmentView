//
//  TWSegmentView.h
//  XiaoLuobo
//
//  Created by 张旭 on 15/7/6.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXSegmentModel.h"

#define SegmentViewHeight           50.f

typedef NS_ENUM(NSInteger, TWNavSelectedTrigger) {
    TWNavSelectedTrigger_None   = -1,
    TWNavSelectedTrigger_Click  = 0,
    TWNavSelectedTrigger_Scroll = 1,
};

@protocol ZXSegmentViewDelegate <NSObject>

- (void)didSelectAction:(NSInteger)tag;

@end

@interface ZXSegmentView : UIView

@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<ZXSegmentViewDelegate> delegate;
@property (nonatomic, assign) TWNavSelectedTrigger selectedTrigger;  // 标记是手动scroll触发, 还是click触发

- (instancetype)initWithFrame:(CGRect)frame withModel:(ZXSegmentModel *)model;

- (void)createNavTagView:(CGRect)frame withModel:(ZXSegmentModel *)model;

/* 左右滑动，滑动条滑动到相应菜单 */
-(void)slideToMenuByIndex:(NSUInteger)index;

/* 仅仅是滑动segment 不触发点击事件 */
-(void)slideToMenuByIndexOnly:(NSUInteger)index;    // 只是滑动, 不触发点击

/* 可删除某个按钮 */
- (void)resetMoveSegmentWithTitle:(NSInteger)index WithNewArray:(NSArray *)newArray;

/* 添加某个按钮 */
- (void)resetAddSegmentWithTitle:(NSInteger)index WithNewArray:(NSArray *)newArray;

/* 可重新设置按钮标题，根据index */
- (void)resetSegmentTitle:(NSString *)title atIndex:(NSUInteger )index;

-(void)invokeSelectItem:(NSUInteger)index;

/* 控件顶部加上一条灰色线条 */
-(void)addTopLine:(CGRect)frame withColor:(UIColor *)color;


@end


