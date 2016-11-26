//
//  DdWebViewController.m
//  Dilidili
//
//  Created by iMac on 16/9/2.
//  Copyright © 2016年 BoxingWoo. All rights reserved.
//

#import "DdWebViewController.h"

@interface DdWebViewController () <UIWebViewDelegate>

/** 网页视图 */
@property (nonatomic, weak) UIWebView *webView;
/** 左导航按钮 */
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;

@end

@implementation DdWebViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.originUrl]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization

- (UIWebView *)webView
{
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView = webView;
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        webView.delegate = self;
        webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:webView];
    }
    return _webView;
}

- (void)configureNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(handleBack)];
    [leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    _leftBarButtonItem = leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

#pragma mark - HandleAction
#pragma mark 返回
- (void)handleBack
{
    if (self.webView.canGoBack) {  // 返回上一级网页
        [self.webView goBack];
        UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(handleClose)];
        [closeBarButtonItem setTitleTextAttributes:[self.leftBarButtonItem titleTextAttributesForState:UIControlStateNormal] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItems = @[self.leftBarButtonItem, closeBarButtonItem];
        [self performSelector:@selector(hideCloseBarButtonItem) withObject:nil afterDelay:3.0];
    }else {
        [self handleClose];  // 返回上一层视图控制器
    }
}

#pragma mark 关闭
- (void)handleClose
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Utility
#pragma mark 隐藏关闭按钮
- (void)hideCloseBarButtonItem
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideCloseBarButtonItem) object:nil];
    self.navigationItem.leftBarButtonItems = @[self.leftBarButtonItem];
}

#pragma mark - WebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    DDLogInfo(@"%@", urlString);
    self.navigationItem.title = urlString;
    if ([request.URL.scheme isEqualToString:@"itms-appss"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }else if ([request.URL.scheme isEqualToString:@"bilibili"]) {
        NSString *js = @"document.getElementById('share_pic').alt";
        NSString *title = [webView stringByEvaluatingJavaScriptFromString:js];
        js = @"document.getElementById('share_pic').src";
        NSString *cover = [webView stringByEvaluatingJavaScriptFromString:js];
        [DCURLRouter pushURLString:urlString query:@{@"title":title, @"cover":cover} animated:YES];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"document.title";
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:js];
    if ([webView.request.URL.absoluteString hasPrefix:[NSString stringWithFormat:@"%@/mobile/video", DdServer_Bilibili]]) {
        NSString *js = @"document.getElementsByClassName('launch-app')[0].click()";
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DDLogError(@"%@", error);
}

#pragma mark - Others

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
