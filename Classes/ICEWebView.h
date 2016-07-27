//
//  WLYWebView.h
//  WLYWebView
//
//  Created by WLY on 16/7/26.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@class ICEWebView;
@protocol ICEWebViewDelegate <NSObject>
@optional
- (void)ice_webView:(ICEWebView *)webView didFinishLoadingURL:(NSURL *)URL;

- (void)ice_webView:(ICEWebView *)webView didFailToLoadURL:(NSURL *)URL error:(NSError *)error;

- (void)ice_WebViewDidStartLoad:(ICEWebView *)webView;


@end

@interface ICEWebView : UIView

@property (nonatomic, strong, readonly) WKWebView *wkWebView;
@property (nonatomic, strong, readonly) UIWebView *uiWebView;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, weak)     id<ICEWebViewDelegate> delegate;
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
