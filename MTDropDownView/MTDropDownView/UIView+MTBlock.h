//
//  UIView+MTBlock.h
//  mimizhushou
//
//  Created by jiaying on 15/11/13.
//  Copyright © 2015年 lechuangzaixian. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^TapGestureBlock)();
@interface UIView (MTBlock)
-(void)addTapGesture:(TapGestureBlock)block;
@end
