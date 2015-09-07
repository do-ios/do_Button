//
//  do_Button_UI.h
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol do_Button_IView <NSObject>

@required
//属性方法
- (void)change_bgImage:(NSString *)newValue;
- (void)change_enabled:(NSString *)newValue;
- (void)change_fontColor:(NSString *)newValue;
- (void)change_fontSize:(NSString *)newValue;
- (void)change_fontStyle:(NSString *)newValue;
- (void)change_radius:(NSString *)newValue;
- (void)change_text:(NSString *)newValue;
- (void)change_textFlag:(NSString *)newValue;

//同步或异步方法


@end