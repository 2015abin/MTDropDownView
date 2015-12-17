//
//  ViewController.m
//  MTDropDownView
//
//  Created by jiaying on 15/12/16.
//  Copyright © 2015年 MT. All rights reserved.
//

#import "ViewController.h"
#import "MTDropDownView.h"
#import <Masonry.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MTDropDownView showViewAtView:self.view Direction:MTDropDownDirectionFromBottom WithHandler:^UIView *(UIView *parentView) {
            UIView *customView = [UIView new];
            
            UIView *sonView = [UIView new];
            sonView.backgroundColor = [UIColor redColor];
            [customView addSubview:sonView];
            
            [sonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(300, 300));
                make.bottom.right.left.top.mas_equalTo(customView);
            }];
            
            return customView;
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
