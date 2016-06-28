//
//  SearchTweetsAPI.h
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/27.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchTweetsAPI : NSObject
@property NSString *query;
@property NSString *geocode;
@property NSString *lang;
@property NSString *locale;
@property NSString *result_type;
@property NSString *count;
@property NSString *until;
@property NSString *since_id;
@property NSString *max_id;
@property NSString *include_entities;
@property NSString *callback;

- (id)initWithQuery:(NSString *)aQuery;

@end
