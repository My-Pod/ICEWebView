//
//  ViewController.m
//  ICEWebView
//
//  Created by WLY on 16/7/27.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import "ViewController.h"
#import "ICEWebView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ICEWebView *webView = [[ICEWebView alloc] initWithFrame:self.view.bounds];
    [webView loadURLString:@"https://www.baidu.com/"];
    
    [webView title:^(NSString *title) {
        self.navigationController.title = title;
    }];
    
    [self.view addSubview:webView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
