//
//  ViewController.m
//  ICEWebView
//
//  Created by WLY on 16/7/27.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import "ViewController.h"
#import "ICEWebView.h"
@interface ViewController ()<ICEWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;
@property (nonatomic, strong) ICEWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[ICEWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadURLString:@"http://image.baidu.com/"];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor redColor];
    [_webView title:^(NSString *title) {
        self.navigationController.title = title;
    }];
    
    [self.view addSubview:_webView];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)reload:(id)sender {
    [_webView loadURLString:@"http://image.baidu.com/"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)ice_webView:(ICEWebView *)webView didFailToLoadURL:(NSURL *)URL error:(NSError *)error{
//    NSLog(@"失败");
//}
//- (void)ice_webView:(ICEWebView *)webView didFinishLoadingURL:(NSURL *)URL{
//    NSLog(@"结束");
//}

@end
