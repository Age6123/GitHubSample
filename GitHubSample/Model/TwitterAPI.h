//
//  TwitterAPI.h
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/27.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterAPI : NSObject
extern NSString *const CONSUMER_KEY;
extern NSString *const CONSUMER_SERCRET;
extern NSString *const ACCESS_TOKEN;
extern NSString *const ACCESS_TOKEN_SECRET;
extern NSString *const API_URL;

- (OAConsumer *)OAConsumer;
- (OAToken *)OAToaken;
@end
