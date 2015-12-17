//
//  MTDropDownView.h
//
//  Created by mt on 15/12/12.
//  Copyright © 2015年 mt. All rights reserved.
//
#define ConstantAnimationTime300mm 0.300f
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MTDropDownDirectionFrom) {
    MTDropDownDirectionFromBottom,
    MTDropDownDirectionFromTop,
    MTDropDownDirectionFromLeft,
    MTDropDownDirectionFromRight
};

@interface MTDropDownView : UIView
+(id)instance;
+(void)showViewAtView:(UIView *)superView Direction:(MTDropDownDirectionFrom)from WithHandler:(UIView *(^)(UIView *parentView))handler;
+(void)hideProcessResult:(BOOL(^)(id respondObject))result FinishBlock:(void(^)(BOOL finished))finishBlock;

@property (nonatomic ,assign) BOOL MTDropDownShouldFade;
@property (nonatomic ,assign) UIColor *maskColor;
@end
