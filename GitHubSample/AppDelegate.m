//
//  AppDelegate.m
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/24.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import "OAuthConsumer.h"
#import "ZipSearchAPI.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSButtonCell *helloButton;
@property (weak) IBOutlet NSButton *trendSearchButton;
@property (weak) IBOutlet NSWindow *window;

@property (nonatomic) ACAccountStore *accountStore;

@property (weak) IBOutlet NSTextField *zipNumber;

@end



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"Hello World");
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)pushHello:(id)sender {
    NSLog(@"%s", __func__);
    NSLog(@"Hello Button");
}
- (IBAction)pushTrendSearch:(id)sender {
    NSLog(@"%s", __func__);
    
    // テキストフィールドから郵便番号の取得
    NSString *zipNumber = self.zipNumber.stringValue;
    if( zipNumber == nil ){
        return;
    }
    NSLog(@"Input:%@", zipNumber);
    
    // 郵便番号検索APIのモデルを生成
    ZipSearchAPI *zipSearchApi = [[ZipSearchAPI alloc] initWithZipNumber:zipNumber];
    
    // NSURLからNSURLRequestを生成
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[zipSearchApi searchZipNumberToAddress]]];
    
    
    // ハンドラの定義
    void (^secondHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error){
        if(error){
            // エラー処理
            NSLog(@"Request Error:%@", error);
        }else{
            // 正常処理
            NSLog(@"Request OK");
            
            // HTTPステータスの判定
            NSInteger httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
            if( httpStatusCode == 404 ){
                // 404エラー処理
                NSLog(@"404 NOT FOUND ERROR. targetURL=%@", [zipSearchApi searchZipNumberToAddress]);
            }else{
                // 正常処理
                // JSONをパース
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
                NSLog(@"zipcode:%@", [array valueForKey:@"zipcode"]);
                
            }
        }
    };
    
    void (^dispachMain)(void) = ^{
        // NSURLからNSURLRequestを作る
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[zipSearchApi searchAddressToZipNumber]]];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        [[session dataTaskWithRequest:request
                     completionHandler:secondHandler] resume];
    };
    
    void (^firstHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error){
        if(error){
            // エラー処理
            NSLog(@"Request Error:%@", error);
        }else{
            // 正常処理
            NSLog(@"Request OK");
            
            // HTTPステータスの判定
            NSInteger httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
            if( httpStatusCode == 404 ){
                // 404エラー処理
                NSLog(@"404 NOT FOUND ERROR. targetURL=%@", [zipSearchApi searchZipNumberToAddress]);
            }else{
                // 正常処理
                // JSONをパース
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
                // 郵便番号検索APIに取得した情報を格納
                zipSearchApi.state     = [array valueForKeyPath:@"state"];
                zipSearchApi.stateName = [array valueForKeyPath:@"stateName"];
                zipSearchApi.city      = [array valueForKeyPath:@"city"];
                zipSearchApi.street    = [array valueForKeyPath:@"street"];
                
                // メインスレッドでの処理
                dispatch_async(dispatch_get_main_queue(), dispachMain);
                
            }
        }
    };
    
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    [[session dataTaskWithRequest:request
                completionHandler:firstHandler] resume];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket
        didFinishWithError:(NSError *)error {
    NSLog(@"Error:%@", error);
}
@end
