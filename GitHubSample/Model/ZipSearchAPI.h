//
//  ZipSearchAPI.h
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/28.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipSearchAPI : NSObject
extern NSString *const ZIP_API_URL;

@property NSString *state;
@property NSString *stateName;
@property NSString *city;
@property NSString *street;

@end
