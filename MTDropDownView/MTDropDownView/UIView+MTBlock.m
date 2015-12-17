//
//  UIView+MTBlock.m
//  mimizhushou
//
//  Created by jiaying on 15/11/13.
//  Copyright © 2015年 lechuangzaixian. All rights reserved.
//

#import "UIView+MTBlock.h"
#import <objc/runtime.h>
@interface UIView ()
@property (nonatomic, copy) TapGestureBlock tapBlock;
@end
static const void *TapGestureBlockKey = &TapGestureBlockKey;
@implementation UIView (MTBlock)
-(void)addTapGesture:(TapGestureBlock)block{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTap)];
    [self addGestureRecognizer:tap];
    self.tapBlock = block;
}
-(void)dealTap{
    if (self.tapBlock) {
        self.tapBlock();
    }
}

#pragma mark - 存取block

-(void)setTapBlock:(TapGestureBlock)tapBlock
{
    objc_setAssociatedObject(self, TapGestureBlockKey, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(TapGestureBlock)tapBlock
{
    return objc_getAssociatedObject(self, TapGestureBlockKey);
}
@end
