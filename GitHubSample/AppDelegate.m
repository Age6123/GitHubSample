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
#import "TwitterAPI.h"

NSString *const API_URL = @"https://api.twitter.com/1.1/trends/available.json";

@interface AppDelegate ()
@property (weak) IBOutlet NSButtonCell *helloButton;
@property (weak) IBOutlet NSButton *trendSearchButton;

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic) ACAccountStore *accountStore;
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
    
    // API ConsumerKey & ConsumerSecret
    NSString *consumerKey = CONSUMER_KEY;
    NSString *consumerSecret = CONSUMER_SERCRET;
    
    // API AccessToken & AccessTokenSecret
    NSString *accessToken = ACCESS_TOKEN;
    NSString *accessTokenSecret = ACCESS_TOKEN_SECRET;
    
    // Create Consumer & Token
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:consumerKey secret:consumerSecret];
    OAToken    *token = accessToken ? [[OAToken alloc] initWithKey:accessToken
                                                            secret:accessTokenSecret] : nil;
    
    // Create Request
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:API_URL]
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:nil
                                                          signatureProvider:nil];
    // Send Request
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFinishWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *) ticket
         didFinishWithData:(NSData *)data {
    NSString *response = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
    NSLog(@"Response:%@", response);
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket
        didFinishWithError:(NSError *)error {
    NSLog(@"Error:%@", error);
}

@end
