//
//  HTTPManager.h
//  GitHubSample
//
//  Created by 米岡毅 on 2016/07/04.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipSearchAPI.h"

@interface HTTPManager : NSObject

- (instancetype)initWithZipSearchApi:(ZipSearchAPI *)aZipSearchApi;
- (BOOL)requestZipSearchApiWithZipNumber;
@end
