//
//  URLRequestFactory.h
//  GitHubSample
//
//  Created by 米岡毅 on 2016/07/04.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLRequestFactory : NSObject

+ (instancetype)sharedFactory;

- (NSURLRequest *)addressRequestWithZipNumberPre:(NSString *)aZipNumberPre zipNumberPost:(NSString *)aZipNumberPost;
- (NSURLRequest *)stateListRequest;
- (NSURLRequest *)cityListRequestWithState:(NSString *)aStateName;
- (NSURLRequest *)streetListRequestWithState:(NSString *)aStateName city:(NSString *)aCityName;
- (NSURLRequest *)zipNumberRequestWithState:(NSString *)aStateName city:(NSString *)aCityName street:(NSString *)aStreetName;

@end
