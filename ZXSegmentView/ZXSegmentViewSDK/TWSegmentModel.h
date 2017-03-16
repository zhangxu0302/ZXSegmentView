//
//  TWSegmentModel.h
//  XiaoLuobo
//
//  Created by 张惠杰 on 15/8/6.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWSegmentModel : NSObject

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) BOOL isShowLine;  // 是否显示分隔线, 顶部和底部线条(非移动的下划线)
@property (nonatomic, assign) BOOL isCalculateByTitle;   // 宽度是否根据title长度来计算, 否则平均分配

@property (nonatomic, assign) float space;               // 按钮之间的间距
@property (nonatomic, assign) float fromFrontDistance;   //第一个按钮距离左导航按钮的距离

@property (nonatomic, assign) BOOL sliderWidthByTitle;   //滑动条的长度是否根据title长度来计算
@property (nonatomic, assign) BOOL isCreateRedDot; // 是否显示小红点
- (id)initWithTitles:(NSArray *)titleArray LineColor:(UIColor *)lineColor TitleColor:(UIColor *)titleColor TitleFont:(UIFont *)titleFont IsShowLine:(BOOL)isShowLine IsCalculateByTitle:(BOOL)isCalculateByTitle Space:(float)space FromFrontDistance:(float)fromFrontDistance SliderWidthByTitle:(BOOL)sliderWidthByTitle IsCreateRedDot:(BOOL)isCreateRedDot;

@end
