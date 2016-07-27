//
//  WLYWebView.m
//  WLYWebView
//
//  Created by WLY on 16/7/26.
//  Copyright © 2016年 WLY. All rights reserved.
//

#import "ICEWebView.h"
#import <WebKit/WKWebView.h>

static void *ICEWebBrowserContext = &ICEWebBrowserContext;


@interface ICEWebView ()<WKNavigationDelegate , WKUIDelegate, UIWebViewDelegate>
@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, assign) BOOL uiWebViewIsLoading;
@property (nonatomic, strong) NSURL *uiWebViewCurrentURL;
@property (nonatomic, strong) NSURL *URLToLaunchWithPermission;
// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy) void (^title) (NSString *title);

@end

@implementation ICEWebView


- (instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            _wkWebView = [[WKWebView alloc] init];
        }else{
            _uiWebView = [[UIWebView alloc] init];
        }
        
        if(_wkWebView) {
            [self.wkWebView setFrame:frame];
            [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [self.wkWebView setNavigationDelegate:self];
            [self.wkWebView setUIDelegate:self];
            [self.wkWebView setMultipleTouchEnabled:YES];
            [self.wkWebView setAutoresizesSubviews:YES];
            [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
            
            [self addSubview:self.wkWebView];
            self.wkWebView.scrollView.bounces = NO;
            [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:ICEWebBrowserContext];
        }
        else  {
            
            [self.uiWebView setFrame:frame];
            [self.uiWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
            [self.uiWebView setDelegate:self];
            [self.uiWebView setMultipleTouchEnabled:YES];
            [self.uiWebView setAutoresizesSubviews:YES];
            [self.uiWebView setScalesPageToFit:YES];
            [self.uiWebView.scrollView setAlwaysBounceVertical:NO];
            self.uiWebView.scrollView.bounces = NO;
            [self addSubview:self.uiWebView];
        }
        
        
        _progress_y = 64;
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        [self.progressView setFrame:CGRectMake(0, _progress_y, self.frame.size.width, self.progressView.frame.size.height)];
        
        //设置进度条颜色
        [self setTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
        [self addSubview:self.progressView];

    }
    return self;
}

- (void)dealloc{
    _title = nil;
}

#pragma mark - Public Interface
- (void)loadRequest:(NSURLRequest *)request {
    if(self.wkWebView) {
        [self.wkWebView loadRequest:request];
    }
    else  {
        [self.uiWebView loadRequest:request];
    }
    
    for (int i = 0 ; i ; i ++) {
        
    }
}

- (void)loadURL:(NSURL *)URL {
    [self loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    if(self.wkWebView) {
        [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
    }
    else if(self.uiWebView) {
        [self.uiWebView loadHTMLString:HTMLString baseURL:nil];
    }
}

- (void)setProgress_y:(CGFloat)progress_y{
    _progress_y = progress_y;
    CGRect frame = self.progressView.frame;
    frame.origin.y = progress_y;
    self.progressView.frame = frame;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.progressView setTintColor:tintColor];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
}


- (void)title:(void (^)(NSString *))title{
    self.title = title;
}

#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKWebView

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    if (webView == _wkWebView) {
        if ([self.delegate respondsToSelector:@selector(ice_WebViewDidStartLoad:)]) {
            [self.delegate ice_WebViewDidStartLoad:self];
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (webView == _wkWebView) {
        if ([self.delegate respondsToSelector:@selector(ice_webView:didFinishLoadingURL:)]) {
            [self.delegate ice_webView:self didFinishLoadingURL:_wkWebView.URL];
        }
    }
    if (self.title) {
        self.title(webView.title);
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if (webView == _wkWebView) {
        if ([self.delegate respondsToSelector:@selector(ice_webView:didFailToLoadURL:error:)]) {
            [self.delegate ice_webView:self didFailToLoadURL:_wkWebView.URL error:error];
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if (webView == _wkWebView) {
        if ([self.delegate respondsToSelector:@selector(ice_webView:didFailToLoadURL:error:)]) {
            [self.delegate ice_webView:self didFailToLoadURL:_wkWebView.URL error:error];
        }
    }
}





#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (webView == _uiWebView) {
        if ([self.delegate respondsToSelector:@selector(ice_WebViewDidStartLoad:)]) {
            [self.delegate ice_WebViewDidStartLoad:self];
        }
    }
    [self fakeProgressViewStartLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (webView == _uiWebView) {
        if ([self.delegate respondsToSelector:@selector(ice_webView:didFinishLoadingURL:)]) {
            [self.delegate ice_webView:self didFinishLoadingURL:webView.request.URL];
        }
    }
    
    [self fakeProgressBarStopLoading];
    
    if (self.title) {
        self.title([webView stringByEvaluatingJavaScriptFromString:@"document.title"]);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (webView == _uiWebView) {
        if ([self.delegate respondsToSelector:@selector(ice_webView:didFailToLoadURL:error:)]) {
            [self.delegate ice_webView:self didFailToLoadURL:webView.request.URL error:error];
        }
    }
    [self fakeProgressBarStopLoading];
}

#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
    
}

- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.uiWebView isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}



@end
