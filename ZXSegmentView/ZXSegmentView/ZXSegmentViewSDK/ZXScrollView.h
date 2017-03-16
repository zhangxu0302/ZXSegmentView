//
//  ZXScrollView.h
//  ZXSegmentView
//
//  Created by 张旭 on 17/3/16.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXScrollViewDelegate <NSObject>

/* 根据index创建控件 */
- (void)createViewByIndex:(NSInteger)index;

/* SegmentView更新索引值 */
- (void)ChangeSegmentViewMenuWithIndex:(NSInteger)index;

@end

@interface ZXScrollView : UIScrollView

@property (nonatomic, assign) id<ZXScrollViewDelegate> myDelegate;

/* 存储以创建控件标示 */
@property (nonatomic, strong) NSMutableDictionary *viewsMap;

/* 当前 SegmentView 的索引值 */
@property (nonatomic, assign) NSInteger currentIndex;

@end
