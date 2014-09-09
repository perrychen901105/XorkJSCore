//
//  ViewController.m
//  Xork
//
//  Created by Pietro Rea on 8/4/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "XorkViewController.h"
#import "ConsoleTextView.h"

@interface XorkViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ConsoleTextView *outputTextView;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation XorkViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.inputTextField.delegate = self;
    [self.inputTextField becomeFirstResponder];
    
    UIFont *navBarFont = [UIFont fontWithName:@"Courier" size:23];
    NSDictionary *attributes = @{NSFontAttributeName : navBarFont};
    [self.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFielDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}



@end
