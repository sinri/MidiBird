//
//  HelpViewController.m
//  MidiBird
//
//  Created by Sinri Edogawa on 2020/5/14.
//  Copyright © 2020 Sinri Edogawa. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *mainTextView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    NSString * path=[[NSBundle mainBundle]pathForResource:@"help" ofType:@"rtf"];
    NSLog(@"path: %@",path);
    
    [_mainTextView readRTFDFromFile:path];
}

@end
