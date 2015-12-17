//
//  MTDropDownView.m
//
//  Created by mt on 15/12/12.
//  Copyright © 2015年 mt. All rights reserved.
//

#import "MTDropDownView.h"
#import <Masonry.h>
#import "UIView+MTBlock.h"
static UIView *MTDropDownStackView = nil;
static MTDropDownDirectionFrom StackDirection = MTDropDownDirectionFromBottom;

@interface MTDropDownView ()
{
    UIView *_maskView;
}
@end
@implementation MTDropDownView
+(id)instance{
    static MTDropDownView *singleInstance = nil;
    static dispatch_once_t onceTokenDropDown;
    if (!singleInstance) {
        dispatch_once(&onceTokenDropDown, ^{
            singleInstance = [[MTDropDownView alloc]init];
        });
    }
    return singleInstance;
}

-(id)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    _maskView = [UIView new];
    [self addSubview:_maskView];
    
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0;
    
    [_maskView addTapGesture:^{
        if ([[UIApplication sharedApplication] keyWindow].isFirstResponder) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        }else{
            [MTDropDownView hideProcessResult:^BOOL(id respondObject) {
                return YES;
            } FinishBlock:^(BOOL finished) {
                
            }];
        }
    }];
}

-(void)showViewAt:(UIView *)parent{
    parent = parent ?  : [UIApplication sharedApplication].keyWindow;
    self.frame = parent.bounds;
    _maskView.frame = self.bounds;
    
    [parent addSubview:self];
    [UIView animateWithDuration:ConstantAnimationTime300mm animations:^{
        _maskView.alpha = 0.5f;
    }];
}

+(void)showViewAtView:(UIView *)superView Direction:(MTDropDownDirectionFrom)from WithHandler:(UIView *(^)(UIView *parentView))handler{
    if (MTDropDownStackView) {
        [MTDropDownView hideProcessResult:^BOOL(id respondObject) {
            return YES;
        } FinishBlock:^(BOOL finished) {
            
        }];
        return ;
    }
    [[MTDropDownView instance] showViewAt:superView];
    
    StackDirection = from;
    MTDropDownView *dropDownView = [MTDropDownView instance];
    
    UIView *childView =  handler(nil);
    
    MTDropDownStackView = childView;
    
    [dropDownView addSubview:childView];
    
    if (dropDownView.MTDropDownShouldFade) {
        childView.alpha = 0;
    }
    
    [childView mas_makeConstraints:^(MASConstraintMaker *make) {
        switch (from) {
            case MTDropDownDirectionFromBottom:
                make.top.mas_equalTo(dropDownView.mas_bottom);
                make.left.right.mas_equalTo(0).priorityLow();
                break;
                
            case MTDropDownDirectionFromTop:
                make.bottom.mas_equalTo(dropDownView.mas_top);
                make.left.right.mas_equalTo(0).priorityLow();
                break;
                
            case MTDropDownDirectionFromLeft:
                make.right.mas_equalTo(dropDownView.mas_left);
                make.top.bottom.mas_equalTo(0).priorityLow();
                break;
                
            case MTDropDownDirectionFromRight:
                make.left.mas_equalTo(dropDownView.mas_right);
                make.top.bottom.mas_equalTo(0).priorityLow();
                break;
                
            default:
                break;
        }
    }];
    
    [childView layoutIfNeeded];
    [childView mas_updateConstraints:^(MASConstraintMaker *make) {
        switch (from) {
            case MTDropDownDirectionFromBottom:
                make.top.mas_equalTo(dropDownView.mas_bottom).with.offset(-CGRectGetHeight(childView.frame));
                break;
                
            case MTDropDownDirectionFromTop:
                make.bottom.mas_equalTo(dropDownView.mas_top).with.offset(CGRectGetHeight(childView.frame));
                break;
                
            case MTDropDownDirectionFromLeft:
                make.right.mas_equalTo(dropDownView.mas_left).with.offset(CGRectGetHeight(childView.frame));
                break;
                
            case MTDropDownDirectionFromRight:
                make.left.mas_equalTo(dropDownView.mas_right).with.offset(-CGRectGetHeight(childView.frame));
                break;
                
            default:
                break;
        }
    }];
    [UIView animateWithDuration:ConstantAnimationTime300mm animations:^{
        childView.alpha = 1.0f;
        [childView layoutIfNeeded];
    }];
}
+(void)hideProcessResult:(BOOL(^)(id respondObject))result FinishBlock:(void(^)(BOOL finished))finishBlock{
    BOOL shouldHide = result(MTDropDownStackView);
    if (!shouldHide) {
        return ;
    }
    __block MTDropDownView * dropDownView = [MTDropDownView instance];
    [MTDropDownStackView mas_updateConstraints:^(MASConstraintMaker *make) {
        switch (StackDirection) {
            case MTDropDownDirectionFromBottom:
                make.top.mas_equalTo(dropDownView.mas_bottom);
                break;
                
            case MTDropDownDirectionFromTop:
                make.bottom.mas_equalTo(dropDownView.mas_top);
                break;
                
            case MTDropDownDirectionFromLeft:
                make.right.mas_equalTo(dropDownView.mas_left);
                break;
                
            case MTDropDownDirectionFromRight:
                make.left.mas_equalTo(dropDownView.mas_right);
                break;
                
            default:
                break;
        }
    }];
    [UIView animateWithDuration:ConstantAnimationTime300mm animations:^{
        UIView *mask = dropDownView.subviews[0];
        mask.alpha = 0;
        if (dropDownView.MTDropDownShouldFade) {
            MTDropDownStackView.alpha = 0;
        }
        [MTDropDownStackView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [dropDownView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                return ;
            }
            [obj removeFromSuperview];
        }];
        [dropDownView removeFromSuperview];
        finishBlock(finished);
        MTDropDownStackView = nil;
//        StackDirection = MTDropDownDirectionFromBottom;
    }];
}

-(void)setMTDropDownShouldFade:(BOOL)MTDropDownShouldFade{
    _MTDropDownShouldFade = MTDropDownShouldFade;
}

-(void)setMaskColor:(UIColor *)maskColor{
    _maskView.backgroundColor = maskColor;
}

@end
