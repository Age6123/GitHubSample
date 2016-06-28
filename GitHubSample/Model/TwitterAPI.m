//
//  TwitterAPI.m
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/27.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import "OAuthConsumer.h"
#import "TwitterAPI.h"

// API ConsumerKey & ConsumerSecret
NSString *const CONSUMER_KEY = @"MAseOnDCRl3NAxKZRHxiMLUMA";
NSString *const CONSUMER_SERCRET = @"gSkEC3H0BHIc71ranABCb46TOc0CpjQAHVk94wPbT0lqlzxIvE";

// API AccessToken & AccessTokenSecret
NSString *const ACCESS_TOKEN = @"732038184889024512-VEZQkkIh370XXiXgVmS1dIz20I2SLXn";
NSString *const ACCESS_TOKEN_SECRET = @"1GRLct6J0zLyKxcYHB4Sil0O7DOuIHzJegc2wUVyqCExy";

// API URL
NSString *const API_URL = @"https://api.twitter.com/1.1/search/tweets.json?q=tokyo&count=1";


@implementation TwitterAPI

- (OAConsumer *)OAConsumer{
    return [[OAConsumer alloc] initWithKey:CONSUMER_KEY secret:CONSUMER_SERCRET];
}

- (OAToken *)OAToaken{
    return [[OAToken alloc] initWithKey:ACCESS_TOKEN secret:ACCESS_TOKEN_SECRET];
}

@end
