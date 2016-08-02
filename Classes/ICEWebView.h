//
//  ZLCWebView.h
//  测试
//
//  Created by shining3d on 16/6/17.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class ICEWebView;
@protocol ICEWebViewDelegate <NSObject>
@optional
- (void)ice_webView:(ICEWebView *)webview didFinishLoadingURL:(NSURL *)URL;
- (void)ice_webView:(ICEWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
- (void)ice_webView:(ICEWebView *)webview shouldStartLoadWithURL:(NSURL *)URL;
- (void)ice_webViewDidStartLoad:(ICEWebView *)webview;
@end

@interface ICEWebView : UIView<WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate>









#pragma mark - Public Properties

//zlcdelegate
@property (nonatomic, weak) id <ICEWebViewDelegate> delegate;

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;
// The web views
// Depending on the version of iOS, one of these will be set
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIWebView *uiWebView;



#pragma mark - Initializers view
- (instancetype)initWithFrame:(CGRect)frame;


#pragma mark - Static Initializers
@property (nonatomic, strong) UIBarButtonItem *actionButton;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, assign) BOOL actionButtonHidden;
@property (nonatomic, assign) BOOL showsURLInNavigationBar;
@property (nonatomic, assign) BOOL showsPageTitleInNavigationBar;

//Allow for custom activities in the browser by populating this optional array
@property (nonatomic, strong) NSArray *customActivityItems;
@property (nonatomic, assign) CGFloat progress_y;


#pragma mark - Public Interface


// Load a NSURLURLRequest to web view
// Can be called any time after initialization
- (void)loadRequest:(NSURLRequest *)request;

// Load a NSURL to web view
// Can be called any time after initialization
- (void)loadURL:(NSURL *)URL;

// Loads a URL as NSString to web view
// Can be called any time after initialization
- (void)loadURLString:(NSString *)URLString;


// Loads an string containing HTML to web view
// Can be called any time after initialization
- (void)loadHTMLString:(NSString *)HTMLString;
/**
 *  当前请求的网页的标题, 当加载完成后回调
 */
- (void)title:(void (^)(NSString *title))title;


@end
