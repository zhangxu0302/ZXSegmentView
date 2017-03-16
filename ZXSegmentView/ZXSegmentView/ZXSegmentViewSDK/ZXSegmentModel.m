//
//  TWSegmentModel.m
//  XiaoLuobo
//
//  Created by 张旭 on 15/8/6.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "ZXSegmentModel.h"

@implementation ZXSegmentModel

- (id)initWithTitles:(NSArray *)titleArray LineColor:(UIColor *)lineColor TitleColor:(UIColor *)titleColor TitleFont:(UIFont *)titleFont IsShowLine:(BOOL)isShowLine IsCalculateByTitle:(BOOL)isCalculateByTitle Space:(float)space FromFrontDistance:(float)fromFrontDistance SliderWidthByTitle:(BOOL)sliderWidthByTitle IsCreateRedDot:(BOOL)isCreateRedDot
{
    if (self=[super init]) {
        self.titleArray = titleArray;
        self.lineColor = lineColor;
        self.titleColor = titleColor;
        self.titleFont = titleFont;
        self.isShowLine = isShowLine;
        self.isCalculateByTitle = isCalculateByTitle;
        self.space = space;
        self.fromFrontDistance = fromFrontDistance;
        self.sliderWidthByTitle = sliderWidthByTitle;
        self.isCreateRedDot = isCreateRedDot;
    }
    
    return self;
}

@end
