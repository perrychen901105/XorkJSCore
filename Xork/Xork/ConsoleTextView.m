//
//  ConsoleTextView.m
//  Xork
//
//  Created by Pietro Rea on 8/4/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "ConsoleTextView.h"

@interface ConsoleTextView() <UITextViewDelegate>


@end

@implementation ConsoleTextView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //Initialization code
        self.delegate = self;
        [self configureTextView];
    }
    
    return self;
}

- (void)configureTextView {
    self.textContainerInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont fontWithName:@"Courier" size:20];
}

- (void)setText:(NSString *)text
    concatenate:(BOOL)concatenate {
    
    if (concatenate) {
        text = [NSString stringWithFormat:@"\n%@", text];
        self.text = [self.text stringByAppendingString:text];
    }
    else {
        self.text = text;
    }
    
    self.scrollEnabled = NO;
    [self.delegate textViewDidChange:self];
}

- (void)clear {
    self.text = @"";
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    self.scrollEnabled = YES;
  
    float margin = 150;
    if (self.contentSize.height + margin > self.frame.size.height) {
        CGPoint offset = CGPointMake(0, self.contentSize.height - self.frame.size.height+ margin);
        [self setContentOffset:offset animated:YES];
    }
}

@end
