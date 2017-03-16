//
//  ZXScrollView.m
//  ZXSegmentView
//
//  Created by 张旭 on 17/3/16.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import "ZXScrollView.h"

#define currentDeviceHeight ([UIScreen mainScreen].bounds.size.height)
#define currentDeviceWidth  ([UIScreen mainScreen].bounds.size.width)

@interface ZXScrollView ()<UIScrollViewDelegate> {
    CGFloat currentScrollViewOffsetX;
}

@end

@implementation ZXScrollView
@synthesize viewsMap, currentIndex;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        viewsMap = [NSMutableDictionary dictionary];
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.bouncesZoom = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        
        currentScrollViewOffsetX = 0.f;
        currentIndex = 0;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)currentScrollView {
    
    int current_index = currentScrollViewOffsetX / currentDeviceWidth;
    CGFloat drag_offset_x = currentScrollView.contentOffset.x;
    CGFloat next_page_offset_x = 0;
    
    if (drag_offset_x > currentScrollViewOffsetX) {
        // 如果还未创建先创建
        if (![viewsMap objectForKey:@(current_index+1)]) {
            if (_myDelegate && [_myDelegate respondsToSelector:@selector(createViewByIndex:)]) {
                [_myDelegate createViewByIndex:current_index+1];
            }
        }
        next_page_offset_x = currentScrollViewOffsetX + currentDeviceWidth/2;
        if (drag_offset_x >= next_page_offset_x) {
            
            current_index++;
            
            currentScrollViewOffsetX += currentDeviceWidth;
            currentIndex = current_index;
            /* 调用主页跳转下个页面 */
            if (_myDelegate && [_myDelegate respondsToSelector:@selector(ChangeSegmentViewMenuWithIndex:)]) {
                [_myDelegate ChangeSegmentViewMenuWithIndex:current_index];
            }
            return;
        }
    }else{
        // 如果还未创建先创建
        if (![viewsMap objectForKey:@(current_index+1)]) {
            if (_myDelegate && [_myDelegate respondsToSelector:@selector(createViewByIndex:)]) {
                [_myDelegate createViewByIndex:current_index-1];
            }
        }
        if (drag_offset_x > 0) {
            next_page_offset_x = currentScrollViewOffsetX - currentDeviceWidth/2;
            if (drag_offset_x < next_page_offset_x) {
                
                current_index--;
                
                currentScrollViewOffsetX -= currentDeviceWidth;
                currentIndex = current_index;
                /* 调用主页跳转上个页面 */
                if (_myDelegate && [_myDelegate respondsToSelector:@selector(ChangeSegmentViewMenuWithIndex:)]) {
                    [_myDelegate ChangeSegmentViewMenuWithIndex:current_index];
                }
                return;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)currentScrollView {
    currentScrollViewOffsetX = currentIndex * currentDeviceWidth;
}

@end
