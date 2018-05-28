//
//  ViewController.m
//  TestImage
//
//  Created by dqf on 2017/9/4.
//  Copyright © 2017年 dqfStudio. All rights reserved.
//

#import "ViewController.h"
#import "QFFileHelper.h"
#import "NSString+QFUtil.h"
#import "Utility.h"
#import "QFGetImage.h"
#import "QFTranslate.h"
#import "QFGetOneImage.h"
#import "QFGetOneImage2.h"
#import "QFSpeechView.h"
#import "QFTextField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [[QFGetImage share] getImageWithKeywords:@"美女" toFolderPath:[QFFileHelper homePath].append(@"iamges222222/")];
    
//    [[QFGetImage share] getImageWithKeywords:@"girl" toFolderPath:[QFFileHelper homePath].append(@"iamges222222/")];
    
//    [[QFGetOneImage share] getImageWithKeywords:@"美女" toFolderPath:[QFFileHelper homePath].append(@"iamges222222/")];
    
    
//    NSString *str = [[QFTranslate share] translateToEnglish:@"你好"];
    
//    NSURL *urll = [NSURL URLWithString:sfsf.append(fff)];
//    NSString *str222 = [[NSString alloc] initWithContentsOfURL:urll encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"%@",str222);
    
    QFSpeechView *speechView = [[QFSpeechView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:speechView];
    
//    QFTextField *textField = [[QFTextField alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:textField];
}

- (void)dfs {
    NSString *sfsf = @"https://s.taobao.com/search?initiative_id=staobaoz_20120803&style=grid&q=";
    NSString *fff = [@"手机" encode];
    
    
    
    NSURL *urll = [NSURL URLWithString:sfsf.append(fff)];
    NSString *str222 = [[NSString alloc] initWithContentsOfURL:urll encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",str222);
}

@end
