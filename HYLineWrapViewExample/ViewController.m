//
//  ViewController.m
//  HYLineWrapViewExample
//
//  Created by Haiyang Yu on 15/6/18.
//  Copyright (c) 2015年 Shadow. All rights reserved.
//

#import "ViewController.h"
#import "HYLineWrapView.h"

@interface ViewController () <HYLineWrapViewDelegate>

@property (nonatomic, strong) HYLineWrapView *wrapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self initWrapView];
    
    [self disableTest];
}

- (void)disableTest
{
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    [set addIndex:1];
    [set addIndex:3];
    [set addIndex:5];
    
    [self.wrapView disableIndex:set];
}

- (void)initWrapView
{
    self.wrapView = [[HYLineWrapView alloc]initWithWidth:CGRectGetWidth(self.view.bounds)];
    self.wrapView.backgroundColor = [UIColor whiteColor];
    self.wrapView.delegate = self;
    
    self.wrapView.headerView = [self wrapHeaderView];
    self.wrapView.itemArray = [self wrapArray];
    
    [self.wrapView make];
    
    CGRect frame = self.wrapView.frame;
    frame.origin.y = 20.f;
    self.wrapView.frame = frame;
    
    [self.view addSubview:self.wrapView];
}

- (NSArray *)wrapArray
{
    return @[@"S", @"M", @"L", @"XL", @"XXL", @"XXXXXXXXXXXL", @"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXL", @"MAX"];
}

- (UIView *)wrapHeaderView
{
    UILabel *headerView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.bounds), 40.f)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.text = @"尺码";
    
    return headerView;
}

#pragma mark - HYLineWrapViewDelegate

- (void)wrapViewDidChangedSelect:(HYLineWrapView *)sender
{
    if (sender.selectedIndex == WRAP_VIEW_SELECT_NONE) {
        NSLog(@"取消选中");
        
        return;
    }
    
    NSLog(@"选中第%ld项", sender.selectedIndex);
}

//当禁用的项恰好是正在选择的项时, 会将selectIndex重置为WRAP_VIEW_SELECT_NONE
- (void)wrapView:(HYLineWrapView *)sender didResetSelectBecauseDisableIndex:(NSInteger)index
{
    
}

@end
