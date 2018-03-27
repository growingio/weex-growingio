//
//  GrowingIOWeexPlugin.m
//  WeexGrowingIO
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 weexplugin. All rights reserved.
//

#import "GrowingIOWeexPlugin.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
//#import "Growing.h"

@implementation GrowingIOWeexPlugin

@synthesize weexInstance;

WX_PlUGIN_EXPORT_MODULE(GrowingIO, GrowingIOWeexPlugin)

WX_EXPORT_METHOD(@selector(track:callback:))
WX_EXPORT_METHOD(@selector(page:callback:))
WX_EXPORT_METHOD(@selector(setPageVariable:pageLevelVariables:callback:))
WX_EXPORT_METHOD(@selector(setEvar:callback:))
WX_EXPORT_METHOD(@selector(setPeopleVariable:callback:))
WX_EXPORT_METHOD(@selector(setUserId:callback:))
WX_EXPORT_METHOD(@selector(clearUserId:))

NS_INLINE NSString *GROWGetTimestampFromTimeInterval(NSTimeInterval timeInterval) {
    return [NSNumber numberWithUnsignedLongLong:timeInterval * 1000.0].stringValue;
}

NS_INLINE NSString *GROWGetTimestamp() {
    return GROWGetTimestampFromTimeInterval([[NSDate date] timeIntervalSince1970]);
}

- (void)track:(NSDictionary *)event callback:(WXModuleKeepAliveCallback)callback
{
    if (![event isKindOfClass:[NSDictionary class]]) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument event must be object type"], NO);
        }
        return;
    }
    
    if (event.count == 0) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument event can not be empty"], NO);
        }
        return;
    }
    
    NSString *eventId = event[@"eventId"];
    
    if (![eventId isKindOfClass:[NSString class]]) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The eventId value must be string type"], NO);
        }
        return;
    }
    
    if (eventId.length == 0) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The eventId value can not be empty"], NO);
        }
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
            if (callback) {
                callback([self errorCallbackDictWithInfo:@"Argument error, The eventLevelVariable value must be object type"], NO);
            }
            return;
        }
        if (![number isKindOfClass:[NSNumber class]]) {
            if (callback) {
                callback([self errorCallbackDictWithInfo:@"Argument error, The number value must be number type"], NO);
            }
            return;
        }
        [self dispatchInMainThread:^{
            [Growing track:eventId withNumber:number andVariable:eventLevelVariable];
        }];
        
    } else if (eventLevelVariable) {
        if (![eventLevelVariable isKindOfClass:[NSDictionary class]]) {
            if (callback) {
                callback([self errorCallbackDictWithInfo:@"Argument error, The eventLevelVariable value must be object type"], NO);
            }
            return;
        }
        [self dispatchInMainThread:^{
            [Growing track:eventId withVariable:eventLevelVariable];
        }];
    } else if (number) {
        if (![number isKindOfClass:[NSNumber class]]) {
            if (callback) {
                callback([self errorCallbackDictWithInfo:@"Argument error, The number value must be number type"], NO);
            }
            return;
        }
        [self dispatchInMainThread:^{
            [Growing track:eventId withNumber:number];
        }];
    }
    
    if (callback) {
        callback([self successCallbackDictWithInfo:@"track"], NO);
    }
}

- (void)page:(NSString *)page callback:(WXModuleKeepAliveCallback)callback
{
    if (![page isKindOfClass:[NSString class]]) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument page must be string type"], NO);
        }
        return;
    }
    
    if (page.length == 0) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument page can not be empty"], NO);
        }
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing trackPageWithPageName:page pageTime:GROWGetTimestamp()];
    }];
    
    if (callback) {
        callback([self successCallbackDictWithInfo:@"page"], NO);
    }
}

- (void)setPageVariable:(NSString *)page pageLevelVariables:(NSDictionary *)pageLevelVariables callback:(WXModuleKeepAliveCallback)callback
{
    if (![page isKindOfClass:[NSString class]]) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument page must be string type"], NO);
        }
        return;
    }
    
    if (![pageLevelVariables isKindOfClass:[NSDictionary class]]) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument pageLevelVariables must be string type"], NO);
        }
        return;
    }
    
    if (page.length == 0 || page.length > 1000) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument page length can not > 1000 or = 0"], NO);
        }
        return;
    }
    
    if (pageLevelVariables.count == 0) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument pageLevelVariables can not be empty"], NO);
        }
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing setPageVariable:pageLevelVariables toPage:page];
    }];
    
    if (callback) {
        callback([self successCallbackDictWithInfo:@"setPageVariable"], NO);
    }
}

- (void)setEvar:(NSDictionary *)conversionVariables callback:(WXModuleKeepAliveCallback)callback
{
    if (![conversionVariables isKindOfClass:[NSDictionary class]]) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument conversionVariables must be object type"], NO);
        }
        return;
    }
    
    if (conversionVariables.count == 0) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument conversionVariables can not be empty"], NO);
        }
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing setEvar:conversionVariables];
    }];
    
    if (callback) {
        callback([self successCallbackDictWithInfo:@"setEvar"], NO);
    }
}

- (void)setPeopleVariable:(NSDictionary *)peopleVariables callback:(WXModuleKeepAliveCallback)callback
{
    if (![peopleVariables isKindOfClass:[NSDictionary class]]) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument peopleVariables must be object type"], NO);
        }
        return;
    }
    
    if (peopleVariables.count == 0) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument peopleVariables can not be empty"], NO);
        }
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing setPeopleVariable:peopleVariables];
    }];
    
    if (callback) {
        callback([self successCallbackDictWithInfo:@"setPeopleVariable"], NO);
    }
}

- (void)setUserId:(NSString *)userId callback:(WXModuleKeepAliveCallback)callback
{
    if (![userId isKindOfClass:[NSString class]] && ![userId isKindOfClass:[NSNumber class]]) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument userId must be string type"], NO);
        }
        return;
    }
    
    if ([userId isKindOfClass:[NSNumber class]]) {
        userId = ((NSNumber *)userId).stringValue;
    }
    
    if (userId.length == 0 || userId.length > 1000) {
        if (callback) {
            callback([self errorCallbackDictWithInfo:@"Argument error, The Argument userId length can not > 1000 or = 0"], NO);
        }
        return;
    }
    
    [self dispatchInMainThread:^{
        [Growing setPluginUserId:userId];
    }];
    
    if (callback) {
        callback([self successCallbackDictWithInfo:@"setUserId"], NO);
    }
}

- (void)clearUserId:(WXModuleKeepAliveCallback)callback
{
    [self dispatchInMainThread:^{
        [Growing clearPluginUserId];
    }];
    
    if (callback) {
        callback([self successCallbackDictWithInfo:@"clearUserId"], NO);
    }
}

- (NSMutableDictionary *)successCallbackDictWithInfo:(NSString *)info
{
    NSMutableDictionary *callbackDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ success", info], @"info", @"success", @"result", nil];
    return callbackDict;
}

- (NSMutableDictionary *)errorCallbackDictWithInfo:(NSString *)info
{
    NSMutableDictionary *callbackDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:info, @"info", @"error", @"result", nil];
    return callbackDict;
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
