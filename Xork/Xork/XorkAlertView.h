//
//  XorkAlertView.h
//  Xork
//
//  Created by Perry on 14-9-11.
//  Copyright (c) 2014年 Pietro Rea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface XorkAlertView : UIAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
            success:(JSValue *)successHandler
            failure:(JSValue *)failureHandler
            context:(JSContext *)context;

@end
