//
//  XorkAlertView.m
//  Xork
//
//  Created by Perry on 14-9-11.
//  Copyright (c) 2014年 Pietro Rea. All rights reserved.
//

#import "XorkAlertView.h"

@interface XorkAlertView() <UIAlertViewDelegate>

// 1
@property (strong ,nonatomic) JSContext *ctxt;
@property (strong, nonatomic) JSManagedValue *successHandler;
@property (strong, nonatomic) JSManagedValue *failureHandler;

@end

@implementation XorkAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message success:(JSValue *)successHandler failure:(JSValue *)failureHandler context:(JSContext *)context
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    if (self) {
        _ctxt = context;
        
        _successHandler = [JSManagedValue managedValueWithValue:successHandler];
        [context.virtualMachine addManagedReference:_successHandler withOwner:self];
        
        _failureHandler = [JSManagedValue managedValueWithValue:failureHandler];
        [context.virtualMachine addManagedReference:_failureHandler withOwner:self];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == self.cancelButtonIndex) {
        JSValue *function = [self.failureHandler value];
        [function callWithArguments:@[]];
    } else {
        JSValue *function = [self.successHandler value];
        [function callWithArguments:@[]];
    }
    
    [self.ctxt.virtualMachine removeManagedReference:_failureHandler withOwner:self];
    [self.ctxt.virtualMachine removeManagedReference:_successHandler withOwner:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
