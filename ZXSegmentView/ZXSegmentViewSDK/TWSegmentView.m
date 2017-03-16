//
//  TWSegmentView.m
//  XiaoLuobo
//
//  Created by 张惠杰 on 15/7/6.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "TWSegmentView.h"
#import "TWSingleLine.h"

#define SEGMENT_LINE_HEIGHT 2.f
#define SEGMENT_VERTICALLINE_WEITH 0.5f

@interface TWSegmentView(){
    NSMutableArray *buttons;
    NSMutableArray *verticalLabels;
    NSMutableArray *redDots;
    UIView *slider;
    TWSingleLine *bottomLine;
    NSArray *titleArr;
    float oneTitleLength;
    //字体之间的间距
    float space;
    //总距离
    float fromFrontDistance;
    CGSize tagSize;
}

@end

@implementation TWSegmentView

@synthesize buttonTitles = buttonTitles;

- (instancetype)initWithFrame:(CGRect)frame withModel:(TWSegmentModel *)model{

    if (self = [super initWithFrame:frame]) {
#ifdef DEBUG
        [RefManager addRef:self];
        NSLog(@"TWSegmentView retainCount = %lu",[RefManager getRefCount]);
#endif
        _segmentModel = [[TWSegmentModel alloc] init];
        _segmentModel = model;
        [self createNavTagView:frame withModel:model];
    }
    
    return self;
}

/* 创建navTagView */
- (void)createNavTagView:(CGRect)frame withModel:(TWSegmentModel *)model
{
    if (!model) {
        return;
    }
    
    NSArray *array = model.titleArray;
    if (!array || array.count == 0) {
        return;
    }
    
    titleArr = [[NSArray alloc] init];
    UIColor *lineColor = model.lineColor;
    UIColor *titleColor = model.titleColor;
    space = model.space;
    fromFrontDistance = model.fromFrontDistance;
    if (array) {
      titleArr = array;
    }
    if(_scrollView)
    {
        [_scrollView removeFromSuperview];
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    //创建菜单按钮
    [self createMenuBtnWithTitleColor:titleColor TitleFont:model.titleFont];
    //创建底部线条
    [self createBottomLabel];
    //创建滑动条
    [self createSliderWithLineColor:lineColor];
    
    if (model.isCalculateByTitle == NO) {
        [self setBtnAndSliderFrameNotByTitle];
    }
    
    if (model.isShowLine == YES){
        bottomLine.hidden = NO;
        for(UILabel *verticalLabel in verticalLabels){
            verticalLabel.hidden = NO;
        }
    }
}

//根据是否按照字体的长度来设置按钮和滑动条大小
- (void)setBtnAndSliderFrameNotByTitle{
    CGSize size;
    for (int i=0; i<titleArr.count; i++) {
        if (i==0) {
            NSString *title = [titleArr objectAtIndex:0];
            size = [QSTool getLabelSizeWithString:title withFont:FONT(14)];
        }
        UIButton *button = [self getItemFromArray:buttons atIndex:i];
        UILabel *verticalLine = [verticalLabels objectAtIndex:i];
        
        if (button) {
            button.frame = CGRectMake(CGRectGetWidth(self.frame)/titleArr.count*i, 0, CGRectGetWidth(self.frame)/titleArr.count, _scrollView.frame.size.height);
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            
        }
          verticalLine.frame = CGRectMake(CGRectGetWidth(self.frame)/titleArr.count*i-SEGMENT_VERTICALLINE_WEITH, 0, SEGMENT_VERTICALLINE_WEITH, CGRectGetHeight(self.frame));
        if (redDots && redDots.count>0) {
            TWNotifcationRedDot *redDot = [redDots objectAtIndex:i];
            redDot.frame =CGRectMake(CGRectGetMaxX(button.frame)-CGRectGetWidth(button.frame)/2+15.f, 10.f, DOT_SIZE, DOT_SIZE);
        }
    }
    slider.frame = CGRectMake(0, self.frame.size.height - SEGMENT_LINE_HEIGHT, CGRectGetWidth(self.frame)/titleArr.count, SEGMENT_LINE_HEIGHT);
    if (_segmentModel.sliderWidthByTitle) {
        slider.frame = CGRectMake((CGRectGetWidth(self.frame)/titleArr.count - size.width-5)/2, self.frame.size.height - SEGMENT_LINE_HEIGHT-5, size.width+5, SEGMENT_LINE_HEIGHT);
    }
}

//创建菜单按钮
-(void)createMenuBtnWithTitleColor:(UIColor *)titleColor TitleFont:(UIFont *)titleFont{
    buttons = [[NSMutableArray alloc] initWithCapacity:0];
    verticalLabels = [[NSMutableArray alloc] initWithCapacity:0];
    redDots = [[NSMutableArray alloc] initWithCapacity:0];

    for (int i=0; i<titleArr.count; i++) {
        [self createMenuBtnWithIndex:i withTitleColor:titleColor withTitleFont:titleFont withMenuSpace:space];
        //创建小竖条，默认是隐藏,创建数组的长度－1个
        if(i!=titleArr.count){
            [self createVerticalLineWithIndex:i];
        }
        if (_segmentModel.isCreateRedDot == YES) {
            [self createRedDotWithIndex:i];
        }
    }
    _scrollView.contentSize = CGSizeMake(fromFrontDistance - space/2, 0);
}

//创建菜单按钮
-(void)createMenuBtnWithIndex:(NSInteger)index withTitleColor:(UIColor *)titleColor withTitleFont:titleFont withMenuSpace:(float)menuSpace{
   UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *tag_name = [titleArr objectAtIndex:index];
    btn.titleLabel.font = FONT(14.f);
    if (titleFont) {
        [btn.titleLabel setFont:titleFont];
    }
    btn.tag = index;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleColor:[ZXUIColor themeBlueColor] forState:UIControlStateSelected];
    if (index == 0) {
        [btn setTitleColor:[ZXUIColor themeBlueColor] forState:UIControlStateNormal];
    }
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    CGSize size = [QSTool getLabelSizeWithString:tag_name withFont:btn.titleLabel.font];
    if (index==0) {
        oneTitleLength = size.width;
    }
    if (index==titleArr.count) {
        oneTitleLength = size.width;
    }
    btn.frame = CGRectMake(fromFrontDistance, 0, size.width+5, self.frame.size.height);
    fromFrontDistance = fromFrontDistance+size.width+menuSpace;
    [btn setTitle:tag_name forState:UIControlStateNormal];
    [buttons addObject:btn];
    [_scrollView addSubview:btn];
}

//创建小竖条
-(void)createVerticalLineWithIndex:(NSInteger)index{
    UILabel *verticalLine = [[UILabel alloc] init];
    verticalLine.tag = index;
    verticalLine.backgroundColor = [ZXUIColor themeBlueColor];
    verticalLine.hidden = YES;
    [_scrollView addSubview:verticalLine];
    [verticalLabels addObject:verticalLine];
}

//创建红点
-(void)createRedDotWithIndex:(NSInteger)index{
    UIButton *btn = buttons[index];
    CGSize size = [QSTool getLabelSizeWithString:btn.titleLabel.text withFont:FONT(14)];
    TWNotifcationRedDot *redDot = [[TWNotifcationRedDot alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)-((CGRectGetWidth(btn.frame)-size.width)/2), 10.f, DOT_SIZE, DOT_SIZE)];
    redDot.hidden = YES;
    [self addSubview:redDot];
    [redDots addObject:redDot];
}

//创建滑动条
-(void)createSliderWithLineColor:(UIColor *)lineColor{
    UIButton *button = [buttons objectAtIndex:0];
    slider = [[UIView alloc] init];
    slider.backgroundColor = lineColor;
    slider.center = CGPointMake(button.center.x, self.frame.size.height- SEGMENT_LINE_HEIGHT*3.5);
    slider.bounds = CGRectMake(0, 0, button.frame.size.width, SEGMENT_LINE_HEIGHT);
    [_scrollView addSubview:slider];
}

//创建最下面的灰色线条，默认隐藏
-(void)createBottomLabel{
    bottomLine = [[TWSingleLine alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-.5f, currentDeviceWidth, .5f) WithColor:[ZXUIColor themeBlueColor]];
    bottomLine.hidden = YES;
    [_scrollView addSubview:bottomLine];
}


/* button click, implement animation */
-(void)btnclick:(UIButton *)button{
    _selectedTrigger=TWNavSelectedTrigger_Click;
    [self setSelectBtn:button IsOnlySlide:NO];
}

-(void)setSelectBtn:(UIButton*)button IsOnlySlide:(BOOL)isOnlySlide
{
    for(id btn in _scrollView.subviews){
        if ([btn isKindOfClass:[UIButton class]]) {
            UIButton *tagBtn = (UIButton *)btn;
            if (tagBtn.tag == button.tag) {
                tagBtn.selected = YES;
            }else{
                tagBtn.selected = NO;
                if (tagBtn.tag == 0) {
                   [tagBtn setTitleColor:[ZXUIColor textGrayColor] forState:UIControlStateNormal];
                }
            }
        }
    }
    WS(weakSelf);
   
    BOOL autoSlide = _scrollView.contentSize.width>self.frame.size.width;
    tagSize = [QSTool getLabelSizeWithString:button.titleLabel.text withFont:FONT(14)];
    if (autoSlide) {
        float relative_distance=button.frame.origin.x-_scrollView.contentOffset.x;
        //点击移动的右区域
        BOOL rightTouchArea = relative_distance>=self.frame.size.width-tagSize.width-space-oneTitleLength;
        //点击移动的左区域
        BOOL leftTouchArea = relative_distance < oneTitleLength + space;
        if (rightTouchArea||leftTouchArea) {
            [UIView animateWithDuration:0.2 animations:^{
                if (!weakSelf) {
                    return;
                }
                //移动菜单
                [weakSelf autoMoveMenuView:button withRightTouchArea:rightTouchArea withLeftTouchArea:leftTouchArea];
            }];
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (!weakSelf) {
            return;
        }
        typeof(self) strongSelf = weakSelf;
        CGRect rectByBtn = CGRectMake(button.frame.origin.x, strongSelf->slider.center.y-strongSelf->slider.frame.size.height/2, button.frame.size.width, strongSelf->slider.frame.size.height);
        CGRect rectByTitle = CGRectMake((CGRectGetWidth(button.frame)-tagSize.width-5)/2+CGRectGetMinX(button.frame), strongSelf->slider.center.y-strongSelf->slider.frame.size.height/2, tagSize.width+5, strongSelf->slider.frame.size.height);
        strongSelf->slider.frame = _segmentModel.sliderWidthByTitle?rectByTitle:rectByBtn;
    }];
    /* button click, 委托出去处理 */
    
    if (!isOnlySlide) {
        [self invokeSelectItem:button.tag];
        _selectedTrigger=TWNavSelectedTrigger_None;
    }
}

//点击左右区域，_scrollView自动滑动
-(void)autoMoveMenuView:(UIButton *)button withRightTouchArea:(BOOL)rightTouchArea withLeftTouchArea:(BOOL)leftTouchArea{
    slider.frame  = CGRectMake(button.frame.origin.x, slider.center.y-slider.frame.size.height/2, button.frame.size.width, 2);
    if (rightTouchArea) {
        //如果点击的是倒数第二个按钮，则将scrollView的偏移量设为最大值
        NSInteger maxOffsetLimite = titleArr.count - 2;
        NSInteger last = titleArr.count - 1;
        if (button.tag==maxOffsetLimite||button.tag == last) {
            _scrollView.contentOffset = CGPointMake(_scrollView.contentSize.width-_scrollView.frame.size.width, _scrollView.contentOffset.y);
        }else{
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x+tagSize.width+space, _scrollView.contentOffset.y);
        }
    }else if(leftTouchArea){
        //如果点击的是正数第二个按钮，则将scrollview的偏移量设为0
        NSInteger minOffsetLimite = 1;
        NSInteger first = 0;
        if (button.tag==minOffsetLimite||button.tag == first) {
            _scrollView.contentOffset = CGPointMake(0,0);
        }else{
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x-(tagSize.width+space), _scrollView.contentOffset.y);
        }
    }

}

-(void)invokeSelectItem:(NSUInteger)index
{
    if (titleArr&&index<titleArr.count)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectAction:)]) {
//            [[TWToastManager manager] hideToast];
            [_delegate didSelectAction:index];
        }
    }
}

//判断数组索引值为index的对象是否存在，避免数组越界问题
-(UIButton *)getItemFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    UIButton *button;
    if (array&&index < array.count) {
        button = array[index];
        return button;
    }else{
        return nil;
    }
    
}

//比如：分享－－－－》分享46；
- (void)resetSegmentTitle:(NSString *)title atIndex:(NSUInteger )index {
    UIButton *button = [self getItemFromArray:buttons atIndex:index];
    if (button) {
        [button setTitle:title forState:UIControlStateNormal];
    }
}

/* 是否显示下红点 */
- (void)showRedDot:(BOOL)isShow atIndex:(NSInteger)index
{
    if (redDots && redDots.count>index) {
        TWNotifcationRedDot *redDot = [redDots objectAtIndex:index];
        redDot.hidden = !isShow;
    }
}

-(void)slideToMenuByIndex:(NSUInteger)index{
    if (buttons && (index < buttons.count)) {
        UIButton *button = buttons[index];
        [self setSelectBtn:button IsOnlySlide:NO];
    }
}

-(void)slideToMenuByIndexOnly:(NSUInteger)index{
    if (buttons && (index < buttons.count)) {
        UIButton *button = buttons[index];
        [self setSelectBtn:button IsOnlySlide:YES];
    }
}

-(void)addTopLine:(CGRect)frame withColor:(UIColor *)color{
    UILabel *topLabel = [[UILabel alloc] initWithFrame:frame];
    topLabel.backgroundColor = color;
    [self addSubview:topLabel];
}

- (void)resetMoveSegmentWithTitle:(NSInteger)index WithNewArray:(NSArray *)newArray{
    //删除btn
    UIButton *button = [self getItemFromArray:buttons atIndex:index];
    if (button) {
        [button removeFromSuperview];
    }
    //改变小竖条位置
    for(int i=0; i<verticalLabels.count; i++){
        UILabel *label = [verticalLabels objectAtIndex:i];
        label.frame = CGRectMake(currentDeviceWidth/newArray.count*i-SEGMENT_VERTICALLINE_WEITH, 0, SEGMENT_VERTICALLINE_WEITH, CGRectGetHeight(self.frame));
    }
    //改变滑动条位置
    CGRect rect = slider.frame;
    rect.size.width = currentDeviceWidth/newArray.count;
    slider.frame = rect;
    //修改btn的frame
    for(int i=0; i<buttons.count;i++){
        if (i!=index) {
            UIButton *btn = [buttons objectAtIndex:i];
            if(i<index){
            btn.frame = CGRectMake(currentDeviceWidth/newArray.count*i, 0, currentDeviceWidth/newArray.count, CGRectGetHeight(btn.frame));
            }else{
                btn.frame = CGRectMake(currentDeviceWidth/newArray.count*(i-1), 0, currentDeviceWidth/newArray.count, CGRectGetHeight(btn.frame));
            }
        }
    }
}

- (void)resetAddSegmentWithTitle:(NSInteger)index WithNewArray:(NSArray *)newArray{
    //改变小竖条位置
    for(int i=0; i<verticalLabels.count; i++){
        UILabel *label = [verticalLabels objectAtIndex:i];
        label.frame = CGRectMake(currentDeviceWidth/newArray.count*i-SEGMENT_VERTICALLINE_WEITH, 0, SEGMENT_VERTICALLINE_WEITH, CGRectGetHeight(self.frame));
    }
    //改变滑动条位置
    CGRect rect = slider.frame;
    rect.size.width = currentDeviceWidth/newArray.count;
    slider.frame = rect;
    //修改btn的frame
    for(int i=0; i<buttons.count;i++){
        UIButton *btn = [buttons objectAtIndex:i];
        btn.frame = CGRectMake(currentDeviceWidth/newArray.count*i, 0, currentDeviceWidth/newArray.count, CGRectGetHeight(btn.frame));
        if (i==index) {
            btn.titleLabel.text = [newArray objectAtIndex:index];
        }
        [_scrollView addSubview:btn];
    }
}

- (void)dealloc {
#ifdef DEBUG
    [RefManager removeRef:self];
    NSLog(@"TWSegmentView retainCount = %lu",[RefManager getRefCount]);
    NSLog(@"TWSegmentView isDealloc:%@",[RefManager isDeallocByRef:self]?@"YES":@"NO");
#endif
}

@end
