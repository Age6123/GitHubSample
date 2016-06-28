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
//#import "TwitterAPI.h"
#import "SearchTweetsAPI.h"
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
    
    // サーバーとの通信を行う
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *json, NSError *error) {
                              
                               if (error) {
                                   // エラー処理を行う。
                                   NSLog(@"Request Error:%@", error);
//                                   if (error.code == -1003) {
//                                       NSLog(@"not found hostname. targetURL=%@", [zipSearchApi searchZipNumberToAddress]);
//                                   } else if (-1019) {
//                                       NSLog(@"auth error. reason=%@", error);
//                                   } else {
//                                       NSLog(@"unknown error occurred. reason = %@", error);
//                                   }
                                   
                               } else {
                                   NSLog(@"Request OK");
                                   
                                   NSInteger httpStatusCode = ((NSHTTPURLResponse *)response).statusCode;
                                   if (httpStatusCode == 404) {
                                       NSLog(@"404 NOT FOUND ERROR. targetURL=%@", [zipSearchApi searchZipNumberToAddress]);
                                   } else {
                                       NSLog(@"success request!!");
                                       NSLog(@"statusCode = %ld", ((NSHTTPURLResponse *)response).statusCode);
                                       NSLog(@"responseText = %@", [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding]);
                                       
                                       // JSONをパース
                                       NSArray *array = [NSJSONSerialization JSONObjectWithData:json
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:nil];
                                       // 郵便番号検索APIに取得した情報を格納
                                       zipSearchApi.state     = [array valueForKeyPath:@"state"];
                                       zipSearchApi.stateName = [array valueForKeyPath:@"stateName"];
                                       zipSearchApi.city      = [array valueForKeyPath:@"city"];
                                       zipSearchApi.street    = [array valueForKeyPath:@"street"];
                                       
                                       
                                       // メインスレッドでの処理
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           // NSURLからNSURLRequestを作る
                                           NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[zipSearchApi searchAddressToZipNumber]]];
                                           
                                           // サーバーとの通信を行う
                                           NSError *error;
                                           NSData *json2 = [NSURLConnection sendSynchronousRequest:request2
                                                                                 returningResponse:nil
                                                                                             error:&error];
                                           if(error){
                                               NSLog(@"%@", error);
                                           }
                                           
                                           // JSONをパース
                                           NSArray *array2 = [NSJSONSerialization JSONObjectWithData:json2
                                                                                             options:NSJSONReadingAllowFragments
                                                                                               error:nil];
                                           // 取得した郵便番号を表示
                                           NSLog(@"zipcode:%@", [array2 valueForKey:@"zipcode"]);
                                       });
                                   }
                               }
                           }];
    
    
//    NSData *json = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:nil
//                                                     error:nil];
//    // JSONをパース
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:json
//                                                     options:NSJSONReadingAllowFragments
//                                                       error:nil];
//    
//    // 郵便番号検索APIに取得した情報を格納
//    zipSearchApi.state     = [array valueForKeyPath:@"state"];
//    zipSearchApi.stateName = [array valueForKeyPath:@"stateName"];
//    zipSearchApi.city      = [array valueForKeyPath:@"city"];
//    zipSearchApi.street    = [array valueForKeyPath:@"street"];
//    
//    NSLog(@"state:%@",     zipSearchApi.state);
//    NSLog(@"stateName:%@", zipSearchApi.stateName);
//    NSLog(@"city:%@",      zipSearchApi.city);
//    NSLog(@"street:%@",    zipSearchApi.street);
//    
//    
//    // NSURLからNSURLRequestを作る
//    NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[zipSearchApi searchAddressToZipNumber]]];
//    
//    // サーバーとの通信を行う
//    NSError *error;
//    NSData *json2 = [NSURLConnection sendSynchronousRequest:request2
//                                         returningResponse:nil
//                                                     error:&error];
//    if( error != nil ){
//        NSLog(@"%@", error);
//    }
//    
//    // JSONをパース
//    NSArray *array2 = [NSJSONSerialization JSONObjectWithData:json2
//                                                     options:NSJSONReadingAllowFragments
//                                                       error:nil];
//    // 取得した郵便番号を表示
//    NSLog(@"zipcode:%@", [array2 valueForKey:@"zipcode"]);
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket
        didFinishWithError:(NSError *)error {
    NSLog(@"Error:%@", error);
}



@end
