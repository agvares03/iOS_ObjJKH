//
//  ASDKTestSettings.m
//  ASDKSampleApp
//
//  Created by Вячеслав Владимирович Будников on 12.10.16.
//  Copyright © 2016 TCS Bank. All rights reserved.
//

#import "ASDKTestSettings.h"
#import "ASDKTestKeys.h"

#define kActiveTerminal @"activeTerminal"
#define kSettingCustomButtonCancel @"SettingCustomButtonCancel"
#define kSettingCustomButtonPay @"SettingCustomButtonPay"
#define kSettingCustomNavBarColor @"SettingCustomNavBarColor"
#define kSettingMakeCharge @"MakeCharge"
#define kSettingMakeNewCard @"MakeNewCard"

@implementation ASDKTestSettings

+ (NSArray *)testTerminals
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"targetName"];
    if ([savedValue  isEqual: @"Klimovsk12"]){
        return @[kASDKTestTerminalKeyKlimovsk];
    }
	return @[kASDKTestTerminalKey];
}

+ (NSString *)testActiveTerminal
{
	NSString *result = [ASDKTestSettings valueForKey:kActiveTerminal];
	if (result == nil)
	{
        result = kASDKTestTerminalKey;
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"targetName"];
        if ([savedValue  isEqual: @"Klimovsk12"]){
            result = kASDKTestTerminalKeyKlimovsk;
        }
	}
	
	return result;
}

+ (void)setActiveTestTerminal:(NSString *)value
{
	[ASDKTestSettings saveValue:value forKey:kActiveTerminal];
}

+ (NSString *)testTerminalPassword
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"targetName"];
    if ([savedValue  isEqual: @"Klimovsk12"]){
        return kASDKTestPasswordKlimovsk;
    }
	return kASDKTestPassword;
}

+ (NSString *)testPublicKey
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"targetName"];
    if ([savedValue  isEqual: @"Klimovsk12"]){
        return kASDKTestPublicKeyKlimovsk;
    }
    return kASDKTestPublicKey;
}

+ (void)setCustomButtonCancel:(BOOL)value
{
	[ASDKTestSettings saveValue:@(value) forKey:kSettingCustomButtonCancel];
}

+ (BOOL)customButtonCancel
{
	return [[ASDKTestSettings valueForKey:kSettingCustomButtonCancel] boolValue];
}

+ (void)setCustomButtonPay:(BOOL)value
{
	[ASDKTestSettings saveValue:@(value) forKey:kSettingCustomButtonPay];
}

+ (BOOL)customButtonPay
{
	return [[ASDKTestSettings valueForKey:kSettingCustomButtonPay] boolValue];
}

+ (void)setCustomNavBarColor:(BOOL)value
{
	[ASDKTestSettings saveValue:@(value) forKey:kSettingCustomNavBarColor];
}

+ (BOOL)customNavBarColor
{
	return [[ASDKTestSettings valueForKey:kSettingCustomNavBarColor] boolValue];
}

+ (void)setMakeCharge:(BOOL)value
{
	[ASDKTestSettings saveValue:@(value) forKey:kSettingMakeCharge];
}

+ (BOOL)makeCharge
{
	return [[ASDKTestSettings valueForKey:kSettingMakeCharge] boolValue];
}

+ (void)setMakeNewCard:(BOOL)value
{
	[ASDKTestSettings saveValue:@(value) forKey:kSettingMakeNewCard];
}

+ (BOOL)makeNewCard
{
	return [[ASDKTestSettings valueForKey:kSettingMakeNewCard] boolValue];
}

+ (void)saveValue:(id)value forKey:(NSString *)key
{
	if (value)
	{
		[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)valueForKey:(NSString *)key
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
