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
    
    // 1
    /*
     *  Get the input string from the text view and convert it to a lower case string. This means that the commands "go north", "Go North" and "gO NoRtH" are all interpreted as the same command.
     */
    NSString *inputString = textField.text;
    [inputString lowercaseString];
    
    // 2
    /*
     *  If the command is clear, erase the contents of the console. This is useful when the game's text has filled the screen and becomes uncomfortable to read.
     */
    if ([inputString isEqualToString:@"clear"]) {
        [self.outputTextView clear];
    }
    
    // 3
    /*
     *  For all other inputs, simply print the string to ConsloleTextView. Notice that you're using SetText:concatenate instead of setting the UITextView's text property directly.By default, the text view overwrites everything when you set its text property. Passing YES into setText:concatenate: preserves the text that was showing before.
     */
    else {
        [self.outputTextView setText:inputString concatenate:YES];
    }
    
    [self.inputTextField setText:@""];
    
    return YES;
}



@end
