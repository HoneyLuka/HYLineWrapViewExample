//
//  HYLineWrapView.m
//  HYLineWrapView
//
//  Created by Shadow on 15/5/26.
//  Copyright (c) 2015年 Shadow. All rights reserved.
//

#import "HYLineWrapView.h"

#define ITEM_MINI_WIDTH 60.f
#define ITEM_HEIGHT 25.f
#define ITEM_MARGIN 10.f
#define ITEM_CONTENT_INSET UIEdgeInsetsMake(0, 10, 0, 10)
#define ITEM_FONT [UIFont systemFontOfSize:13]

#define ITEM_LINE_WIDTH 1.f
#define ITEM_CORNER_RADIUS 3.f

#define ITEM_DESELECT_LINE_COLOR [UIColor colorWithRed:0.561 green:0.561 blue:0.561 alpha:1.0]
#define ITEM_SELECT_LINE_COLOR [UIColor colorWithRed:0.949 green:0.373 blue:0.169 alpha:1.0]
#define ITEM_DISABLE_LINE_COLOR [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0]

#define ITEM_DESELECT_TITLE_COLOR [UIColor colorWithRed:0.561 green:0.561 blue:0.561 alpha:1.0]
#define ITEM_SELECT_TITLE_COLOR [UIColor whiteColor]
#define ITEM_DISABLE_TITLE_COLOR [UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.0]

#define ITEM_DESELECT_BG_COLOR [UIColor whiteColor]
#define ITEM_SELECT_BG_COLOR [UIColor colorWithRed:0.949 green:0.373 blue:0.169 alpha:1.0]
#define ITEM_DISABLE_BG_COLOR [UIColor whiteColor]


@interface HYLineWrapView ()

@property (nonatomic, assign) CGFloat maxWidth;

//先算出来总共需要几行
@property (nonatomic, assign) NSInteger lines;

@property (nonatomic, readwrite, assign) NSInteger selectedIndex;

@property (nonatomic, readwrite, strong) NSMutableArray *itemViewArray;

@property (nonatomic, readwrite, strong) NSIndexSet *disableIndexSet;

@end

@implementation HYLineWrapView

- (instancetype)initWithWidth:(CGFloat)width
{
    self = [self init];
    if (self) {
        self.maxWidth = width;
        [self initDefaultValueIfNeeded];
    }
    return self;
}

- (void)removeAllSubview
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

//重置
- (void)reset
{
    [self removeAllSubview];
    self.selectedIndex = WRAP_VIEW_SELECT_NONE;
    self.itemViewArray = [NSMutableArray array];
}

//使用默认选项填充属性
- (void)initDefaultValueIfNeeded
{
    self.itemMiniWidth = ITEM_MINI_WIDTH;
    self.itemMargin = ITEM_MARGIN;
    self.itemHeight = ITEM_HEIGHT;
    self.itemLineWidth = ITEM_LINE_WIDTH;
    self.itemCornerRadius = ITEM_CORNER_RADIUS;
    self.font = ITEM_FONT;
    
    self.deselectBgColor = ITEM_DESELECT_BG_COLOR;
    self.deselectLineColor = ITEM_DESELECT_LINE_COLOR;
    self.deselectTitleColor = ITEM_DESELECT_TITLE_COLOR;
    
    self.selectBgColor = ITEM_SELECT_BG_COLOR;
    self.selectLineColor = ITEM_SELECT_LINE_COLOR;
    self.selectTitleColor = ITEM_SELECT_TITLE_COLOR;
    
    self.disableBgColor = ITEM_DISABLE_BG_COLOR;
    self.disableLineColor = ITEM_DISABLE_LINE_COLOR;
    self.disableTitleColor = ITEM_DISABLE_TITLE_COLOR;
    
    self.itemContentInsets = ITEM_CONTENT_INSET;
}

- (void)make
{
    [self reset];
    
    CGFloat height = [self calculateViewHeight];
    self.frame = CGRectMake(0, 0,  self.maxWidth, height);
    
    [self addSubview:self.headerView];
    [self setupItemList];
    
    self.footerView.frame = CGRectMake(0,
                                       CGRectGetHeight(self.frame) - CGRectGetHeight(self.footerView.frame),
                                       CGRectGetWidth(self.footerView.frame),
                                       CGRectGetHeight(self.footerView.frame));
    [self addSubview:self.footerView];
}

//添加button到视图上
- (void)setupItemList
{
    int currentLines = 1;
    CGFloat currentLineLeftPos = 0.f;
    
    for (int i = 0; i < self.itemArray.count; i++) {
        CGFloat itemWidth = [self itemWidthWithText:self.itemArray[i]];
        
        UIButton *item = [self itemButtonWithText:self.itemArray[i]];
        item.tag = i;
        
        //当前这一行剩下的宽度
        CGFloat currentLineHaveMaxWidth = self.maxWidth - currentLineLeftPos - self.itemMargin;
        
        CGFloat x;
        CGFloat y;
        
        //当前行能放下
        if (currentLineHaveMaxWidth >= itemWidth) {
            x = currentLineLeftPos + self.itemMargin;
            
            currentLineLeftPos += itemWidth;
        } else { //当前行放不下
            currentLines++; //换行
            currentLineLeftPos = 0.f; //归零
            
            x = currentLineLeftPos + self.itemMargin;
            
            currentLineLeftPos = itemWidth;
        }
        
        y = self.itemMargin * currentLines + (currentLines - 1) * self.itemHeight + CGRectGetHeight(self.headerView.frame);
        item.frame = CGRectMake(x, y, CGRectGetWidth(item.frame), self.itemHeight);
        [self addSubview:item];
        
        [self.itemViewArray addObject:item];
    }
}

//计算总共需要几行
- (void)calculateLines
{
    self.lines = 1;
    CGFloat currentLineLeftPos = 0.f;
    
    for (int i = 0; i < self.itemArray.count; i++) {
        CGFloat itemWidth = [self itemWidthWithText:self.itemArray[i]];
        
        //当前这一行剩下的宽度
        CGFloat currentLineHaveMaxWidth = self.maxWidth - currentLineLeftPos - self.itemMargin;
        
        //当前行能放下
        if (currentLineHaveMaxWidth >= itemWidth) {
            currentLineLeftPos += itemWidth;
        } else { //当前行放不下
            self.lines++; //换行
            currentLineLeftPos = 0.f; //归零
            
            currentLineLeftPos = itemWidth;
        }
    }
}

//创建button
- (UIButton *)itemButtonWithText:(NSString *)text
{
    CGFloat maxContentWidth = self.maxWidth - self.itemMargin * 2;
    CGSize size = [text sizeWithFont:self.font
                   constrainedToSize:CGSizeMake(maxContentWidth,self.itemHeight)];
    CGFloat itemPadding = self.itemContentInsets.left + self.itemContentInsets.right;
    CGFloat itemWidth = ceilf(MIN(maxContentWidth, MAX(size.width + itemPadding, ITEM_MINI_WIDTH)));
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, itemWidth, self.itemHeight);
    
    button.contentEdgeInsets = self.itemContentInsets;
    
    [button setTitle:text forState:UIControlStateNormal];
    [button.titleLabel setFont:self.font];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [button setTitleColor:self.deselectTitleColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectTitleColor forState:UIControlStateSelected];
    [button setTitleColor:self.disableTitleColor forState:UIControlStateDisabled];
    
    [button setBackgroundImage:[self imageByColor:self.deselectBgColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageByColor:self.selectBgColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[self imageByColor:self.disableBgColor] forState:UIControlStateDisabled];
    
    button.layer.borderWidth = self.itemLineWidth;
    button.layer.borderColor = self.deselectLineColor.CGColor;
    button.layer.cornerRadius = self.itemCornerRadius;
    button.layer.masksToBounds = YES;
    
    button.adjustsImageWhenHighlighted = NO;
    button.exclusiveTouch = YES;
    
    [button addTarget:self
               action:@selector(itemClick:)
     forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)itemClick:(UIButton *)button
{
    NSInteger tag = button.tag;
    [self selectIndex:tag];
}

- (void)selectIndex:(NSInteger)index
{
    for (UIButton *button in self.itemViewArray) {
        [self changeButtonSelect:button select:NO];
    }
    
    if (index == self.selectedIndex || index >= self.itemArray.count) { //反选
        self.selectedIndex = WRAP_VIEW_SELECT_NONE;
    } else { //选中
        UIButton *button = [self buttonAtIndex:index];
        
        //如果是禁用按钮的index, 则取消选择
        if (!button.isEnabled || [self.disableIndexSet containsIndex:index]) {
            self.selectedIndex = WRAP_VIEW_SELECT_NONE;
            
            [self notifyDelegateSelectChanged];
            return;
        }
        
        self.selectedIndex = index;
        [self changeButtonSelect:button select:YES];
    }
    
    [self notifyDelegateSelectChanged];
}

- (void)changeButtonSelect:(UIButton *)button select:(BOOL)select
{
    if (!button.isEnabled) {
        return;
    }
    
    [button setSelected:select];
    
    if (select) {
        button.layer.borderColor = self.selectLineColor.CGColor;
    } else {
        button.layer.borderColor = self.deselectLineColor.CGColor;
    }
}

- (void)disableIndex:(NSIndexSet *)indexSet
{
    self.disableIndexSet = indexSet;
    
    for (int i = 0; i < self.itemViewArray.count; i++) {
        UIButton *button = [self buttonAtIndex:i];
        
        if ([indexSet containsIndex:i]) {
            //恰好选择的项是需要禁用的项
            if (self.selectedIndex == i) {
                self.selectedIndex = WRAP_VIEW_SELECT_NONE;
                [self changeButtonSelect:button select:NO];
                
                [self notifyDelegateResetSelectAtIndex:i];
            }
            
            [self disableButton:button];
        } else {
            [button setEnabled:YES];
            [self changeButtonSelect:button select:button.isSelected];
        }
    }
}

- (void)disableButton:(UIButton *)button
{
    [button setEnabled:NO];
    button.layer.borderColor = self.disableLineColor.CGColor;
}

- (void)notifyDelegateSelectChanged
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wrapViewDidChangedSelect:)]) {
        [self.delegate wrapViewDidChangedSelect:self];
    }
}

- (void)notifyDelegateResetSelectAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wrapView:didResetSelectBecauseDisableIndex:)]) {
        [self.delegate wrapView:self didResetSelectBecauseDisableIndex:index];
    }
}

- (UIButton *)buttonAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.itemViewArray.count) {
        return nil;
    }
    
    return self.itemViewArray[index];
}

//计算button需要的宽度(包含一个itemMargin)
- (CGFloat)itemWidthWithText:(NSString *)text
{
    CGFloat maxContentWidth = self.maxWidth - self.itemMargin * 2;
    CGSize size = [text sizeWithFont:self.font
                   constrainedToSize:CGSizeMake(maxContentWidth, self.itemHeight)];
    
    CGFloat itemPadding = self.itemContentInsets.left + self.itemContentInsets.right;
    CGFloat itemWidth = ceilf(MIN(maxContentWidth, MAX(size.width + itemPadding, ITEM_MINI_WIDTH)));
    
    return itemWidth + self.itemMargin;
}

//计算整个View的高度
- (CGFloat)calculateViewHeight
{
    [self calculateLines];
    
    CGFloat contentHeight = (self.itemHeight + self.itemMargin) * self.lines + self.itemMargin;
    return contentHeight + CGRectGetHeight(self.headerView.bounds) + CGRectGetHeight(self.footerView.bounds);
}

//颜色转图片
- (UIImage *)imageByColor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

@end
