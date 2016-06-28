//
//  ZipSearchAPI.h
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/28.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipSearchAPI : NSObject

@property NSString *zipNumberPre;
@property NSString *zipNumberPost;
@property NSString *state;
@property NSString *stateName;
@property NSString *city;
@property NSString *street;

- (id)initWithZipNumber:(NSString *)aZipNumber;
- (NSString *)searchZipNumberToAddress;
- (NSString *)searchAddressToZipNumber;

@end
