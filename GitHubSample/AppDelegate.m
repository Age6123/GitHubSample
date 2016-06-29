//
//  AppDelegate.m
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/24.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import "AppDelegate.h"
#import "ZipSearchAPI.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSButtonCell *helloButton;
@property (weak) IBOutlet NSButton *trendSearchButton;
@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *zipNumber;

typedef void (^SecondHandler)(NSData *data, NSURLResponse *response, NSError *error);
typedef void (^FirstHandler)(NSData *data, NSURLResponse *response, NSError *error);

@end



@implementation AppDelegate

SecondHandler secondHandler = ^(NSData *data, NSURLResponse *response, NSError *error){
    NSString *returnMessage;
    
    if(error){
        // エラー処理
        returnMessage = [NSString stringWithFormat:@"Request Error:%@", error];
    }else{
        // 正常処理
        
        // HTTPステータスの判定
        switch(((NSHTTPURLResponse *)response).statusCode){
            case 404:
                // 404エラー処理
                returnMessage = [NSString stringWithFormat:@"HTTP Status Error:404 NOT FOUND ERROR"];
                break;
                
            default:{
                // 正常処理
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
                returnMessage = [NSString stringWithFormat:@"Request OK: ZipCode=%@", [array valueForKey:@"zipcode"]];
                break;
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Second Http Request : %@", returnMessage);
    });
};

FirstHandler firstHandler = ^(NSData *data, NSURLResponse *response, NSError *error){
    NSString *returnMessage;
    
    if(error){
        // エラー処理
        returnMessage = [NSString stringWithFormat:@"Request Error:%@", error];
    }else{
        // 正常処理
        
        // HTTPステータスの判定
        switch(((NSHTTPURLResponse *)response).statusCode){
            case 404:
                // 404エラー処理
                returnMessage = [NSString stringWithFormat:@"HTTP Status Error:404 NOT FOUND ERROR"];
                break;
                
            default:{
                // 正常処理
                // JSONをパース
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
                // 郵便番号検索APIに取得した情報を格納
                ZipSearchAPI *zipSearchApi = [[ZipSearchAPI alloc] init];
                zipSearchApi.state     = [array valueForKeyPath:@"state"];
                zipSearchApi.stateName = [array valueForKeyPath:@"stateName"];
                zipSearchApi.city      = [array valueForKeyPath:@"city"];
                zipSearchApi.street    = [array valueForKeyPath:@"street"];
                
                returnMessage = [NSString stringWithFormat:@"Request OK: Address=%@%@%@", zipSearchApi.stateName, zipSearchApi.city, zipSearchApi.street];
                
                
                // NSURLからNSURLRequestを生成
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[zipSearchApi createUrlWithAddress]]];
                
                NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
                [[session dataTaskWithRequest:request
                            completionHandler:secondHandler] resume];
                break;
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"First Http Request : %@", returnMessage);
    });
};


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
    
    // NSURLからNSURLRequestを生成
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[zipSearchApi createUrlWithZipNumber]]];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    [[session dataTaskWithRequest:request
                completionHandler:firstHandler] resume];
}
@end
