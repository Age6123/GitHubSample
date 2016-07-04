//
//  HTTPManager.m
//  GitHubSample
//
//  Created by 米岡毅 on 2016/07/04.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import "HTTPManager.h"
#import "URLRequestFactory.h"

@interface HTTPManager(){
@private ZipSearchAPI *_zipSearchApi;
@private NSURLSession *_session;
}
typedef void (^SecondHandler)(NSData*, NSURLResponse*, NSError*);
@end

@implementation HTTPManager

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


- (instancetype)initWithZipSearchApi:(ZipSearchAPI *)aZipSearchApi {
    if ((self = [super init])){
        _zipSearchApi = aZipSearchApi;
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (BOOL)requestZipSearchApiWithZipNumber {
    NSURLRequest *request = [[URLRequestFactory sharedFactory] addressRequestWithZipNumberPre:_zipSearchApi.zipNumberPre zipNumberPost:_zipSearchApi.zipNumberPost];
    
    
    __block NSString *message = nil;
    
    
    [[_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error){
            // エラー処理
            message = [NSString stringWithFormat:@"Request Error:%@", error];
        }else{
            // 正常処理
            // HTTPステータスの判定
            switch(((NSHTTPURLResponse *)response).statusCode){
                case 404:
                    // 404エラー処理
                    message = [NSString stringWithFormat:@"HTTP Status Error:404 NOT FOUND ERROR"];
                    break;
                default:{
                    // 正常処理
                    // JSONをパース
                    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    
                    // 郵便番号検索APIに取得した情報を格納
                    ZipSearchAPI *zipSearchApi = [[ZipSearchAPI alloc] initWithArray:array];
                    
                    message = [NSString stringWithFormat:@"Request OK: Address=%@%@%@", zipSearchApi.stateName, zipSearchApi.city, zipSearchApi.street];
                    
                    // NSURLからNSURLRequestを生成
                    NSURLRequest *request = [[URLRequestFactory sharedFactory] zipNumberRequestWithState:zipSearchApi.stateName city:zipSearchApi.city street:zipSearchApi.street];
                    
                    [[_session dataTaskWithRequest:request completionHandler:secondHandler] resume];
                    break;
                }
            }
        }
    }] resume];
    
    while( message == nil ){
        sleep(1);
    }
    NSLog(@"Message : %@", message);

    return YES;
}

@end
