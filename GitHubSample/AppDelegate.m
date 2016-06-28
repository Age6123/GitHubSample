//
//  AppDelegate.m
//  GitHubSample
//
//  Created by 米岡毅 on 2016/06/24.
//  Copyright © 2016年 SSL. All rights reserved.
//

#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import "OAuthConsumer.h"
//#import "TwitterAPI.h"
#import "SearchTweetsAPI.h"
#import "ZipSearchAPI.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSButtonCell *helloButton;
@property (weak) IBOutlet NSButton *trendSearchButton;

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic) ACAccountStore *accountStore;

@property (weak) IBOutlet NSTextField *zipNumber;




@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"Hello GitHub ADD");
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (IBAction)pushHello:(id)sender {
    NSLog(@"%s", __func__);
    NSLog(@"Hello World");
}
- (IBAction)pushTrendSearch:(id)sender {
    NSLog(@"%s", __func__);
    
//    NSLog(@"%@", self.zipNumber.intValue);
    
    //NSURLからNSURLRequestを作る
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ZIP_API_URL]];
    
    //サーバーとの通信を行う
    NSData *json = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    //JSONをパース
    NSArray *array = [NSJSONSerialization JSONObjectWithData:json
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];
    
    ZipSearchAPI *zipSearchApi = [[ZipSearchAPI alloc] init];
    zipSearchApi.state = [array valueForKeyPath:@"state"];
    zipSearchApi.stateName = [array valueForKeyPath:@"stateName"];
    zipSearchApi.city = [array valueForKeyPath:@"city"];
    zipSearchApi.street = [array valueForKeyPath:@"street"];
    
    NSLog(@"state:%@", zipSearchApi.state);
    NSLog(@"stateName:%@", zipSearchApi.stateName);
    NSLog(@"city:%@", zipSearchApi.city);
    NSLog(@"street:%@", zipSearchApi.street);
    
    
    //NSURLからNSURLRequestを作る
    NSString *URL2 = [NSString stringWithFormat:@"http://api.thni.net/jzip/X0401/JSON/J/%@/%@/%@.js",
                      [zipSearchApi.stateName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]],
                      [zipSearchApi.city stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]],
                      [zipSearchApi.street stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];

//    NSLog(@"URL2 : %@", URL2);
    NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:URL2]];
    
    //サーバーとの通信を行う
    NSError *error;
    NSData *json2 = [NSURLConnection sendSynchronousRequest:request2
                                         returningResponse:nil
                                                     error:&error];
    if( error != nil ){
        NSLog(@"%@", error);
    }
    
    //JSONをパース
    NSArray *array2 = [NSJSONSerialization JSONObjectWithData:json2
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];

    NSLog(@"zipcode:%@", [array2 valueForKey:@"zipcode"]);

    
    
//    TwitterAPI *twitterApi = [[TwitterAPI alloc] init];
//    
//    // Create Consumer & Token
//    OAConsumer *consumer = [twitterApi OAConsumer];
//    OAToken    *token = [twitterApi OAToaken];
//    
////    SearchTweetsAPI *searchTweetsApi = [[SearchTweetsAPI alloc] initWithQuery:@"Tokyo"];
//    
//    // Create Request
//    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:API_URL]
//                                                                   consumer:consumer
//                                                                      token:token
//                                                                      realm:nil
//                                                          signatureProvider:nil];
//    // Send Request
//    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
//    [fetcher fetchDataWithRequest:request
//                         delegate:self
//                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
//                  didFailSelector:@selector(requestTokenTicket:didFinishWithError:)];
//}
//
//- (void)requestTokenTicket:(OAServiceTicket *) ticket
//         didFinishWithData:(NSData *)data {
//    
////    NSLog(@"Data:%@", data);
//    
//    NSError *error;
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:data
//                                                     options:NSJSONReadingAllowFragments
//                                                       error:&error];
//    if (error != nil){
//        NSLog(@"%@", error);
//    }else{
//        NSLog(@"%@", array);
//    }
//    
//    NSString *str = [[[array valueForKey:@"statuses"] valueForKey:@"user"] valueForKey:@"time_zone"];
//    
////    NSString *str2 = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    NSLog(@"%@", str);
//    
//    if( str == nil ){
//        NSLog(@"nil");
//    }else if ( [str  isEqual: @"\"<null>\""] ){
//        NSLog(@"<nill>");
//    }else if ( [str  isEqual: @""] ){
//        NSLog(@"-----");
//    }else {
//        NSLog(@"Else");
//    }
//    
//    
//    
//    NSString *escapedString = [self decodeJSONString:str];
//    
//    // Data to String
//    NSString *response = [[NSString alloc] initWithData:data
//                                               encoding:NSShiftJISStringEncoding];
//    NSLog(@"Response:%@", response);
    
//    // Unicode to String
//    NSData *jsonData = [response dataUsingEncoding:NSShiftJISStringEncoding
//                              allowLossyConversion:YES];
//    NSLog(@"jsonData:%@", jsonData);
//    
//    // Data to String
//    response = [[NSString alloc] initWithData:jsonData
//                                               encoding:NSUTF8StringEncoding];
//    NSLog(@"Response:%@", response);
//    
//    
//    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                     options:NSJSONReadingAllowFragments
//                                                       error:nil];
//    
//    NSLog(@"Array:%@", [[array valueForKeyPath:@"statuses"] valueForKeyPath:@"text"]);
    
//    NSString *response = [[NSString alloc] initWithData:data
//                                               encoding:NSUTF8StringEncoding];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket
        didFinishWithError:(NSError *)error {
    NSLog(@"Error:%@", error);
}


@end
