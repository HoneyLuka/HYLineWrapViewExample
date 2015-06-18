//
//  HYLineWrapView.h
//  HYLineWrapView
//
//  Created by Shadow on 15/5/26.
//  Copyright (c) 2015年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WRAP_VIEW_SELECT_NONE -1

@class HYLineWrapView;
@protocol HYLineWrapViewDelegate <NSObject>

- (void)wrapViewDidChangedSelect:(HYLineWrapView *)sender;

@optional
//当禁用的项恰好是正在选择的项时, 会将selectIndex重置为WRAP_VIEW_SELECT_NONE
- (void)wrapView:(HYLineWrapView *)sender didResetSelectBecauseDisableIndex:(NSInteger)index;

@end

@interface HYLineWrapView : UIView

@property (nonatomic, weak) id<HYLineWrapViewDelegate> delegate;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) CGFloat itemMargin;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemMiniWidth;

//边线宽
@property (nonatomic, assign) CGFloat itemLineWidth;
//圆角
@property (nonatomic, assign) CGFloat itemCornerRadius;

//只有左右可用
@property (nonatomic, assign) UIEdgeInsets itemContentInsets;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *deselectBgColor;
@property (nonatomic, strong) UIColor *deselectLineColor;
@property (nonatomic, strong) UIColor *deselectTitleColor;

@property (nonatomic, strong) UIColor *selectBgColor;
@property (nonatomic, strong) UIColor *selectLineColor;
@property (nonatomic, strong) UIColor *selectTitleColor;

@property (nonatomic, strong) UIColor *disableBgColor;
@property (nonatomic, strong) UIColor *disableLineColor;
@property (nonatomic, strong) UIColor *disableTitleColor;

//item的名字, NSString
@property (nonatomic, strong) NSArray *itemArray;

//禁用的item的index
@property (nonatomic, strong, readonly) NSIndexSet *disableIndexSet;

//保存item的View, UIButton
@property (nonatomic, readonly, strong) NSMutableArray *itemViewArray;

//未选中为 WRAP_VIEW_SELECT_NONE
@property (nonatomic, readonly, assign) NSInteger selectedIndex;

//构建View
- (void)make;

- (void)selectIndex:(NSInteger)index;
- (void)disableIndex:(NSIndexSet *)indexSet;

//使用这个初始化
- (instancetype)initWithWidth:(CGFloat)width;

@end
