//
//  Item.h
//  Xork
//
//  Created by Perry on 14-9-11.
//  Copyright (c) 2014年 Pietro Rea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

// 1
/*
 use JSExport protocol to make your new class compatible with JavaScript.
 */
@protocol ItemExport <JSExport>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;

@end

// 2
@interface Item : NSObject <ItemExport>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *description;

@end
