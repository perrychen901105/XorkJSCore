//
//  ConsoleTextView.h
//  Xork
//
//  Created by Pietro Rea on 8/4/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsoleTextView : UITextView

- (void)setText:(NSString *)text
    concatenate:(BOOL)concatenate;

- (void)clear;


@end
