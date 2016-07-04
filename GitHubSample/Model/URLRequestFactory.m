//
//  URLRequestFactory.m
//  GitHubSample
//
//  Created by 米岡毅 on 2016/07/04.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import "URLRequestFactory.h"
#import "ZipSearchAPI.h"

@implementation URLRequestFactory
+ (instancetype)sharedFactory {
    static dispatch_once_t predicate;
    static URLRequestFactory *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}

- (NSURLRequest *)addressRequestWithZipNumberPre:(NSString *)aZipNumberPre zipNumberPost:(NSString *)aZipNumberPost {
    NSURL *URL = [self requestURLWithPath:[NSString stringWithFormat:@"%@/%@.js", aZipNumberPre, aZipNumberPost]];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [mutableRequest setHTTPMethod:@"GET"];
    return [mutableRequest copy];
}

- (NSURLRequest *)stateListRequest {
    NSURL *URL = [self requestURLWithPath:@"J/state_index.js"];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [mutableRequest setHTTPMethod:@"GET"];
    return [mutableRequest copy];
}

- (NSURLRequest *)cityListRequestWithState:(NSString *)aStateName {
    NSURL *URL = [self requestURLWithPath:[NSString stringWithFormat:@"J/%@/city_index.js", [aStateName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]]];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [mutableRequest setHTTPMethod:@"GET"];
    return [mutableRequest copy];
}

- (NSURLRequest *)streetListRequestWithState:(NSString *)aStateName city:(NSString *)aCityName {
    NSURL *URL = [self requestURLWithPath:[NSString stringWithFormat:@"J/%@/%@/street_index.js", [aStateName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]], [aCityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]]];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [mutableRequest setHTTPMethod:@"GET"];
    return [mutableRequest copy];
}

- (NSURLRequest *)zipNumberRequestWithState:(NSString *)aStateName city:(NSString *)aCityName street:(NSString *)aStreetName {
    NSURL *URL = [self requestURLWithPath:[NSString stringWithFormat:@"J/%@/%@/%@.js", [aStateName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]], [aCityName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]], [aStreetName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]]];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:URL];
    [mutableRequest setHTTPMethod:@"GET"];
    return [mutableRequest copy];
}


#pragma mark - @private
- (NSURL *)requestURLWithPath:(NSString *)aPath {
    return [NSURL URLWithString:aPath relativeToURL:[self baseURL]];
}

- (NSURL *)baseURL {
    return [NSURL URLWithString:@"http://api.thni.net/jzip/X0401/JSON/"];
}

@end
