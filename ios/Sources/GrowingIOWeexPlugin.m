//
//  GrowingIOWeexPlugin.m
//  WeexGrowingIO
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 weexplugin. All rights reserved.
//

#import "GrowingIOWeexPlugin.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import "Growing.h"

@implementation GrowingIOWeexPlugin

@synthesize weexInstance;

WX_PlUGIN_EXPORT_MODULE(GrowingIO, GrowingIOWeexPlugin)

WX_EXPORT_METHOD(@selector(track:))
WX_EXPORT_METHOD(@selector(page:))
WX_EXPORT_METHOD(@selector(setPageVariable:pageLevelVariables:))
WX_EXPORT_METHOD(@selector(setEvar:))
WX_EXPORT_METHOD(@selector(setPeopleVariable:))
WX_EXPORT_METHOD(@selector(setUserId:))
WX_EXPORT_METHOD(@selector(clearUserId))

NS_INLINE NSString *GROWGetTimestampFromTimeInterval(NSTimeInterval timeInterval) {
    return [NSNumber numberWithUnsignedLongLong:timeInterval * 1000.0].stringValue;
}

NS_INLINE NSString *GROWGetTimestamp() {
    return GROWGetTimestampFromTimeInterval([[NSDate date] timeIntervalSince1970]);
}

- (void)track:(NSDictionary *)event
{
    if (![event isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Method(track) Argument error, The Argument event must be object type");
        return;
    }
    
    if (event.count == 0) {
        NSLog(@"Method(track) Argument error, The Argument event can not be empty");
        return;
    }
    
    NSString *eventId = event[@"eventId"];
    
    if (![eventId isKindOfClass:[NSString class]]) {
        NSLog(@"Method(track) Argument error, The eventId value must be string type");
        return;
    }
    
    if (eventId.length == 0) {
        NSLog(@"Method(track) Argument error, The eventId value can not be empty");
        return;
    }
    
    NSDictionary *eventLevelVariable = event[@"eventLevelVariable"];
    NSNumber *number = event[@"number"];
    
    if (!eventLevelVariable && !number) {
        [self dispatchInMainThread:^{
            [Growing track:eventId];
        }];
        
    } else if (eventLevelVariable && number) {
        if (![eventLevelVariable isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Method(track) Argument error, The eventLevelVariable value must be object type");
            return;
        }
        if (![number isKindOfClass:[NSNumber class]]) {
            NSLog(@"Method(track) Argument error, The number value must be number type");
            return;
        }
        [self dispatchInMainThread:^{
            [Growing track:eventId withNumber:number andVariable:eventLevelVariable];
        }];
        
    } else if (eventLevelVariable) {
        if (![eventLevelVariable isKindOfClass:[NSDictionary class]]) {
            NSLog(@"Method(track) Argument error, The eventLevelVariable value must be object type");
            return;
        }
        [self dispatchInMainThread:^{
            [Growing track:eventId withVariable:eventLevelVariable];
        }];
    } else if (number) {
        if (![number isKindOfClass:[NSNumber class]]) {
            NSLog(@"Method(track) Argument error, The number value must be number type");
            return;
        }
        [self dispatchInMainThread:^{
            [Growing track:eventId withNumber:number];
        }];
    }
}

- (void)page:(NSString *)page
{
    if (![page isKindOfClass:[NSString class]]) {
        NSLog(@"Method(page) Argument error, The Argument page must be string type");
        return;
    }
    
    if (page.length == 0) {
        NSLog(@"Method(page) Argument error, The Argument page can not be empty");
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing trackPageWithPageName:page pageTime:GROWGetTimestamp()];
    }];
}

- (void)setPageVariable:(NSString *)page pageLevelVariables:(NSDictionary *)pageLevelVariables
{
    if (![page isKindOfClass:[NSString class]]) {
        NSLog(@"Method(setPageVariable) Argument error, The Argument page must be string type");
        return;
    }
    
    if (![pageLevelVariables isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Method(setPageVariable) Argument error, The Argument pageLevelVariables must be objct type");
        return;
    }
    
    if (page.length == 0 || page.length > 1000) {
        NSLog(@"Method(setPageVariable) Argument error, The Argument page length can not > 1000 or = 0");
        return;
    }
    
    if (pageLevelVariables.count == 0) {
        NSLog(@"Method(setPageVariable) Argument error, The Argument pageLevelVariables can not be empty");
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing setPageVariable:pageLevelVariables toPage:page];
    }];
}

- (void)setEvar:(NSDictionary *)conversionVariables
{
    if (![conversionVariables isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Method(setEvar) Argument error, The Argument conversionVariables must be object type");
        return;
    }
    
    if (conversionVariables.count == 0) {
        NSLog(@"Method(setEvar) Argument error, The Argument conversionVariables can not be empty");
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing setEvar:conversionVariables];
    }];
}

- (void)setPeopleVariable:(NSDictionary *)peopleVariables
{
    if (![peopleVariables isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Method(setPeopleVariable) Argument error, The Argument peopleVariables must be object type");
        return;
    }
    
    if (peopleVariables.count == 0) {
        NSLog(@"Method(setPeopleVariable) Argument error, The Argument peopleVariables can not be empty");
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing setPeopleVariable:peopleVariables];
    }];
}

- (void)setUserId:(NSString *)userId
{
    if (![userId isKindOfClass:[NSString class]] && ![userId isKindOfClass:[NSNumber class]]) {
        NSLog(@"Method(setUserId) Argument error, The Argument userId must be string type");
        return;
    }
    
    if ([userId isKindOfClass:[NSNumber class]]) {
        userId = ((NSNumber *)userId).stringValue;
    }
    
    if (userId.length == 0 || userId.length > 1000) {
        NSLog(@"Method(setUserId) Argument error, The Argument userId length can not > 1000 or = 0");
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing setPluginUserId:userId];
    }];
}

- (void)clearUserId
{
    [self dispatchInMainThread:^{
        [Growing clearPluginUserId];
    }];
}


- (void)dispatchInMainThread:(void (^)(void))block
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

    

@end
