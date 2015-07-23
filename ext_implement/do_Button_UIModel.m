//
//  do_Button_Model.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Button_UIModel.h"
#import "doProperty.h"

@implementation do_Button_UIModel

#pragma mark - 注册属性（--属性定义--）
-(void)OnInit
{
    [super OnInit];
    //属性声明
    [self RegistProperty:[[doProperty alloc]init:@"bgImage" :String :@"" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"enabled" :Bool :@"true" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"fontColor" :String :@"000000FF" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"fontSize" :Number :@"17" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"fontStyle" :String :@"normal" :NO]];
    [self RegistProperty:[[doProperty alloc]init:@"textFlag" :String :@"normal" :NO]];    
    [self RegistProperty:[[doProperty alloc]init:@"radius" :Number :@"0" :YES]];
    [self RegistProperty:[[doProperty alloc]init:@"text" :String :@"" :NO]];
    
}

@end