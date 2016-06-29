//
//  ZipSearchAPI.m
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/28.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import "ZipSearchAPI.h"

// API URL
NSString *const API_URL_ZIP = @"http://api.thni.net/jzip/X0401/JSON/%@/%@.js";
NSString *const API_URL_ADDRESS = @"http://api.thni.net/jzip/X0401/JSON/J/%@/%@/%@.js";

@implementation ZipSearchAPI : NSObject

- (id)initWithZipNumber:(NSString *)aZipNumber {
    if(aZipNumber == nil){
        NSLog(@"Error");
    }else{
        NSLog(@"%@", aZipNumber);
    }
    _zipNumberPre = [aZipNumber substringToIndex:3];
    _zipNumberPost = [aZipNumber substringFromIndex:3];
    
    return self;
}

- (NSString *)createUrlWithZipNumber{
    if(_zipNumberPre==nil || _zipNumberPost==nil){
        return nil;
    }
    
    return [NSString stringWithFormat:API_URL_ZIP, _zipNumberPre, _zipNumberPost];
}

- (NSString *)createUrlWithAddress{
    if(_stateName==nil || _stateName==nil || _street==nil){
        return nil;
    }
    return [NSString stringWithFormat:API_URL_ADDRESS,
            [_stateName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]],
            [_city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]],
            [_street stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
}

@end