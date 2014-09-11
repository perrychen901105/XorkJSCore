//
//  ViewController.m
//  Xork
//
//  Created by Pietro Rea on 8/4/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "XorkViewController.h"
#import "ConsoleTextView.h"
#import "Item.h"
#import "XorkAlertView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface XorkViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ConsoleTextView *outputTextView;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewShow;

@property (strong, nonatomic) JSContext *context;

@property (strong, nonatomic) JSManagedValue *inventory;
@end

@implementation XorkViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.inputTextField.delegate = self;
    [self.inputTextField becomeFirstResponder];
    
    UIFont *navBarFont = [UIFont fontWithName:@"Courier" size:23];
    NSDictionary *attributes = @{NSFontAttributeName : navBarFont};
    [self.navigationBar setTitleTextAttributes:attributes];
    
    [self.imgViewShow setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 1
    /*
     *
     */
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"xork" ofType:@"js"];
    NSString *scriptString = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:nil];
    
    // 2
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSString *dataString = [NSString stringWithContentsOfFile:dataPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    NSData *jsonData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:0 error:&error];
    
    if (error) {
        NSLog(@"%@", @"NSJSONSerialization error");
        return;
    }
    
    self.context = [[JSContext alloc] init];
    [self.context evaluateScript:scriptString];

    self.context[@"presentNativeAlert"] = ^(NSString *title,
                                            NSString *message,
                                            JSValue *success,
                                            JSValue *failure) {
        JSContext *context = [JSContext currentContext];
        XorkAlertView *alertView = [[XorkAlertView alloc] initWithTitle:title
                                                                message:message
                                                                success:success
                                                                failure:failure context:context];
        
        [alertView show];
    };
    
    

    // 1
    /*
     *  use subscript notation to get a JSValue reference to the inventory array used by the script. This is where you'll insert the pantry key.
     */
    JSValue *value = self.context[@"inventory"];
    
    // 2
    /*
     *
     */
    self.inventory = [JSManagedValue managedValueWithValue:value];
    [self.context.virtualMachine addManagedReference:self.inventory withOwner:self];
    
    // 3
    /*
     *  define the JavaScript function print() inside the JSContext.
     */
    __weak XorkViewController *weakSelf = self;
    self.context[@"print"] = ^(NSString *text) {
        text = [NSString stringWithFormat:@"%@\n",text];
        NSLog(@"text is %@", text);
        [weakSelf.outputTextView setText:text concatenate:YES];
    };
    
    // show image
    self.context[@"showImgFind"] = ^(NSString *imgPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imgViewShow.hidden = NO;
            NSLog(@"img path is %@",imgPath);
            [weakSelf.imgViewShow setImage:[UIImage imageNamed:imgPath]];
        });
    };
    
    self.context[@"getVersion"] = ^{
        NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        versionString = [@"Xork version " stringByAppendingString:versionString];
        
        
        /*
         *  using currentContext removes the extraneous strong reference to JSContext when the block is copied to the heap.
         */
        JSContext *context = [JSContext currentContext];
        JSValue *version = [JSValue valueWithObject:versionString inContext:context];
        return version;
    };
    
    // 4
    /*
     *  get a reference to the startGame function defined in hello.js, and then call it with an empty argument array since it doesnot take any arguments.
     */
    JSValue *function = self.context[@"startGame"];
    JSValue *dataValue = [JSValue valueWithObject:jsonArray inContext:self.context];
    [function callWithArguments:@[dataValue]];
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
    
    else if ([inputString isEqualToString:@"cheat"]) {
        [self addPantryKeyToInventory];
    }
    
    else if ([inputString isEqualToString:@"save"]) {
        JSValue *function = self.context[@"saveGame"];
        [function callWithArguments:@[]];
    }
    
    // 3
    /*
     *  For all other inputs, simply print the string to ConsloleTextView. Notice that you're using SetText:concatenate instead of setting the UITextView's text property directly.By default, the text view overwrites everything when you set its text property. Passing YES into setText:concatenate: preserves the text that was showing before.
     */
    else {
//        [self.outputTextView setText:inputString concatenate:YES];
        [self processUserInput:inputString];
    }
    
    [self.inputTextField setText:@""];
    
    return YES;
}

- (void)processUserInput:(NSString *)str
{
    JSValue *function = self.context[@"processUserInput"];
    JSValue *value = [JSValue valueWithObject:str inContext:self.context];
    [function callWithArguments:@[value]];
    
}

- (void)addPantryKeyToInventory
{
    // 1
    Item *pantryKey = [[Item alloc] init];
    pantryKey.name = @"pantry key";
    pantryKey.description = @"Looks like a normal key. Hehe.";
    
    // 2
    JSValue *inventory = [self.inventory value];
    JSValue *function = inventory[@"addItem"];
    [function callWithArguments:@[pantryKey]];
}

@end
