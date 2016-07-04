//
//  AppDelegate.m
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/24.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import "AppDelegate.h"
#import "ZipSearchAPI.h"
#import "HTTPManager.h"

@interface AppDelegate (){
@private
    NSURLSessionDataTask *_task;
}

@property (weak) IBOutlet NSButtonCell *helloButton;
@property (weak) IBOutlet NSButton *trendSearchButton;
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *zipNumber;

@property NSString *message;



@end

//typedef void (^SecondHandler)(NSData*, NSURLResponse*, NSError*);
//typedef void (^FirstHandler)(NSData*, NSURLResponse*, NSError*);
void (^FirstHandler)(NSData*, NSURLResponse*, NSError*);

@implementation AppDelegate

//SecondHandler secondHandler = ^(NSData *data, NSURLResponse *response, NSError *error){
//    NSString *returnMessage;
//    
//    if(error){
//        // エラー処理
//        returnMessage = [NSString stringWithFormat:@"Request Error:%@", error];
//    }else{
//        // 正常処理
//        
//        // HTTPステータスの判定
//        switch(((NSHTTPURLResponse *)response).statusCode){
//            case 404:
//                // 404エラー処理
//                returnMessage = [NSString stringWithFormat:@"HTTP Status Error:404 NOT FOUND ERROR"];
//                break;
//                
//            default:{
//                // 正常処理
//                NSArray *array = [NSJSONSerialization JSONObjectWithData:data
//                                                                 options:NSJSONReadingAllowFragments
//                                                                   error:nil];
//                returnMessage = [NSString stringWithFormat:@"Request OK: ZipCode=%@", [array valueForKey:@"zipcode"]];
//                break;
//            }
//        }
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"Second Http Request : %@", returnMessage);
//    });
//};

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

- (IBAction)pushZipNumberSearch:(id)sender {
    NSLog(@"%s", __func__);
    
    // テキストフィールドから郵便番号の取得
    NSString *zipNumber = self.zipNumber.stringValue;
    if( zipNumber == nil ){
        return;
    }
    NSLog(@"Input:%@", zipNumber);
    
    // 郵便番号検索APIのモデルを生成
    ZipSearchAPI *zipSearchApi = [[ZipSearchAPI alloc] initWithZipNumber:zipNumber];
    
    // HTTPManagerの生成
    HTTPManager *httpManager = [[HTTPManager alloc] initWithZipSearchApi:zipSearchApi];
    if ([httpManager requestZipSearchApiWithZipNumber]){
        
    }
    
//    // NSURLからNSURLRequestを生成
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[zipSearchApi createUrlWithZipNumber]]];
//    
//    
//    
//    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
//    
//    
//    __block NSString *message = nil;
//    
//    
//    _task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
//        if(error){
//            // エラー処理
//            message = [NSString stringWithFormat:@"Request Error:%@", error];
//        }else{
//            // 正常処理
//            // HTTPステータスの判定
//            switch(((NSHTTPURLResponse *)response).statusCode){
//                case 404:
//                    // 404エラー処理
//                    message = [NSString stringWithFormat:@"HTTP Status Error:404 NOT FOUND ERROR"];
//                    break;
//                default:{
//                    // 正常処理
//                    // JSONをパース
//                    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                    
//                    // 郵便番号検索APIに取得した情報を格納
//                    ZipSearchAPI *zipSearchApi = [[ZipSearchAPI alloc] initWithArray:array];
//                    
//                    message = [NSString stringWithFormat:@"Request OK: Address=%@%@%@", zipSearchApi.stateName, zipSearchApi.city, zipSearchApi.street];
//                    
//                    // NSURLからNSURLRequestを生成
//                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[zipSearchApi createUrlWithAddress]]];
//                    
//                    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//                    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
//                    [[session dataTaskWithRequest:request completionHandler:secondHandler] resume];
//                    break;
//                }
//            }
//        }
//    }];
//
//    
//    [_task resume];
//    
//    while( message == nil ){
//        sleep(1);
//    }
//    NSLog(@"Message : %@", message);
    
    
}
@end
