//
//  TYPEID_View.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_Button_UIView.h"

#import "doInvokeResult.h"
#import "doIPage.h"
#import "doIScriptEngine.h"
#import "doUIModuleHelper.h"
#import "doScriptEngineHelper.h"
#import "doTextHelper.h"
#import "doUIContainer.h"
#import "doISourceFS.h"
#import "doIPage.h"
#import "doDefines.h"
#import "doIOHelper.h"

#define FONT_OBLIQUITY 15.0

@implementation do_Button_UIView
{
    NSString *_myFontStyle;
    
    int _intFontSize;
    NSString *_myFontFlag;
    NSString *_tmpFontColor;
}
#pragma mark - doIUIModuleView协议方法（必须）
//引用Model对象
- (void) LoadView: (doUIModule *) _doUIModule
{
    _model = (typeof(_model)) _doUIModule;
    
    [self addTarget:self action:@selector(fingerTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(fingerDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(fingerUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(fingerUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self change_enabled:[_model GetProperty:@"enabled"].DefaultValue];
    [self change_fontColor:[_model GetProperty:@"fontColor"].DefaultValue];
    [self change_fontStyle:[_model GetProperty:@"fontStyle"].DefaultValue];
    [self change_textFlag:[_model GetProperty:@"textFlag"].DefaultValue];
    [self change_radius:[_model GetProperty:@"radius"].DefaultValue];
    [self change_fontSize:[_model GetProperty:@"fontSize"].DefaultValue];
}
//销毁所有的全局对象
- (void) OnDispose
{
    _myFontStyle = nil;
    _myFontFlag = nil;
    //自定义的全局属性
}
//实现布局
- (void) OnRedraw
{
    //实现布局相关的修改
    
    //重新调整视图的x,y,w,h
    [doUIModuleHelper OnRedraw:_model];
}

#pragma mark - TYPEID_IView协议方法（必须）
#pragma mark - Changed_属性
/*
 如果在Model及父类中注册过 "属性"，可用这种方法获取
 NSString *属性名 = [(doUIModule *)_model GetPropertyValue:@"属性名"];
 
 获取属性最初的默认值
 NSString *属性名 = [(doUIModule *)_model GetProperty:@"属性名"].DefaultValue;
 */

//修改listview 的cell被选中的时候，背景色自动变为白色问题
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    UIColor *bgColor = [doUIModuleHelper GetColorFromString:[_model GetPropertyValue:@"bgColor"] : [UIColor clearColor]];
    if (CGColorEqualToColor(bgColor.CGColor,backgroundColor.CGColor)) {
        [super setBackgroundColor:bgColor];
    }
}
- (void)change_text:(NSString *)newValue{
    NSRange range = NSMakeRange(0, self.currentAttributedTitle.length);
    if (self.currentAttributedTitle.length==0) {
        [self setAttributedTitle:[[NSAttributedString alloc]initWithString:newValue] forState:UIControlStateNormal];
    }
    else
    {
        NSDictionary *arrDict = [self.currentAttributedTitle attributesAtIndex:0 effectiveRange:&range];
        [self setAttributedTitle:[[NSAttributedString alloc]initWithString:newValue attributes:arrDict] forState:UIControlStateNormal];
    }
    if(_myFontStyle)
        [self change_fontStyle:_myFontStyle];
    if (_myFontFlag)
        [self change_textFlag:_myFontFlag];
    [self change_fontColor:_tmpFontColor];
}
- (void)change_enabled:(NSString *)newValue
{
    if (!newValue || [newValue isEqualToString:@""]) {
        self.userInteractionEnabled = YES;
    }else
        self.userInteractionEnabled = [newValue boolValue];
}

- (void)change_fontColor:(NSString *)newValue{
    UIColor* fontColor = [doUIModuleHelper GetColorFromString:newValue :[UIColor blackColor]] ;
    _tmpFontColor = newValue;
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithAttributedString:self.currentAttributedTitle];
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:fontColor
                        range:NSMakeRange(0, self.currentAttributedTitle.length)];
    
    [self setAttributedTitle:attriString forState:UIControlStateNormal];
}
- (void)change_fontSize:(NSString *)newValue{
    UIFont *font = [UIFont systemFontOfSize:[newValue intValue]];
    _intFontSize = [doUIModuleHelper GetDeviceFontSize:[[doTextHelper Instance] StrToInt:newValue :[[_model GetProperty:@"fontSize"].DefaultValue intValue]] :_model.XZoom :_model.YZoom];
    self.titleLabel.font = [font fontWithSize:_intFontSize];
    self.titleLabel.numberOfLines = 0;
    if(_myFontStyle)
        [self change_fontStyle:_myFontStyle];
    if (_myFontFlag)
        [self change_textFlag:_myFontFlag];
}

- (void)change_fontStyle:(NSString *)newValue
{
    //自己的代码实现
    _myFontStyle = [NSString stringWithFormat:@"%@",newValue];
    if (self.titleLabel.text==nil || [self.titleLabel.text isEqualToString:@""]) return;
    
    float fontSize = self.titleLabel.font.pointSize;
    if([newValue isEqualToString:@"normal"])
        [self.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    else if([newValue isEqualToString:@"bold"])
    {
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    }
    else if([newValue isEqualToString:@"italic"])
    {
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(FONT_OBLIQUITY * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :fontSize ]. fontName matrix :matrix];
        [self.titleLabel setFont:[ UIFont fontWithDescriptor :desc size :fontSize]];
    }
    else if([newValue isEqualToString:@"bold_italic"]){}
    self.titleLabel.numberOfLines = 0;
}

- (void)change_textFlag:(NSString *)newValue
{
    //自己的代码实现
    _myFontFlag = [NSString stringWithFormat:@"%@",newValue];
    if (self.titleLabel.text==nil || [self.titleLabel.text isEqualToString:@""]) return;
    
    NSMutableAttributedString *content = [self.currentAttributedTitle mutableCopy];
    [content beginEditing];
    NSRange contentRange = {0,[content length]};
    if ([newValue isEqualToString:@"normal" ]) {
        [content removeAttribute:NSUnderlineStyleAttributeName range:contentRange];
        [content removeAttribute:NSStrikethroughStyleAttributeName range:contentRange];
    }else if ([newValue isEqualToString:@"underline" ]) {
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    }else if ([newValue isEqualToString:@"strikethrough" ]) {
        [content addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    }
    [self setAttributedTitle:content forState:UIControlStateNormal];
    [content endEditing];
    self.titleLabel.numberOfLines = 0;
}

- (void)change_radius:(NSString *)newValue{
    
    self.layer.cornerRadius = [[doTextHelper Instance] StrToInt:newValue :0] * _model.CurrentUIContainer.InnerXZoom;
    self.layer.masksToBounds = YES;
    
}
- (void)change_bgImage:(NSString *)newValue{
    
    NSString * imgPath = [doIOHelper GetLocalFileFullPath:_model.CurrentPage.CurrentApp :newValue];
    UIImage * img = [UIImage imageWithContentsOfFile:imgPath];
    [self setBackgroundImage:img forState:UIControlStateNormal];
}

#pragma mark - event
-(void)fingerTouch:(do_Button_UIView *) _doButtonView
{
    doInvokeResult* _invokeResult = [[doInvokeResult alloc]init:_model.UniqueKey];
    [_model.EventCenter FireEvent:@"touch":_invokeResult];
}
-(void)fingerDown:(do_Button_UIView *) _doButtonView
{
    doInvokeResult* _invokeResult = [[doInvokeResult alloc]init:_model.UniqueKey];
    [_model.EventCenter FireEvent:@"touchDown":_invokeResult];
}

-(void)fingerUp:(do_Button_UIView *) _doButtonView
{
    doInvokeResult* _invokeResult = [[doInvokeResult alloc]init:_model.UniqueKey];
    [_model.EventCenter FireEvent:@"touchUp":_invokeResult];
}

#pragma mark - doIUIModuleView协议方法（必须）<大部分情况不需修改>
- (BOOL) OnPropertiesChanging: (NSMutableDictionary *) _changedValues
{
    //属性改变时,返回NO，将不会执行Changed方法
    return YES;
}
- (void) OnPropertiesChanged: (NSMutableDictionary*) _changedValues
{
    //_model的属性进行修改，同时调用self的对应的属性方法，修改视图
    [doUIModuleHelper HandleViewProperChanged: self :_model : _changedValues ];
}
- (BOOL)InvokeSyncMethod:(NSString *)_methodName :(NSDictionary *)_dictParas :(id<doIScriptEngine>) _scriptEngine :(doInvokeResult *)_invokeResult
{
    return [doScriptEngineHelper InvokeSyncSelector:self : _methodName :_dictParas :_scriptEngine :_invokeResult];
}

- (BOOL) InvokeAsyncMethod: (NSString *) _methodName : (NSDictionary *) _dicParas :(id<doIScriptEngine>) _scriptEngine : (NSString *) _callbackFuncName
{
    return [doScriptEngineHelper InvokeASyncSelector:self : _methodName :_dicParas :_scriptEngine: _callbackFuncName];
}
- (doUIModule *) GetModel
{
    //获取model对象
    return _model;
}
#pragma mark - 重写该方法，动态选择事件的施行或无效
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    //这里的BOOL值，可以设置为int的标记。从model里获取。
    if([_model.EventCenter GetEventCount:@"touch"]+[_model.EventCenter GetEventCount:@"touchdown"]+[_model.EventCenter GetEventCount:@"touchup"] <= 0)
        if(view == self)
            view = nil;
    return view;
}
@end
