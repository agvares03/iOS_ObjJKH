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
    NSLog(@"%@TARGET_NAME: ", savedValue);
    if ([savedValue  isEqual: @"MupRCMytishi"]){
        return @[kASDKTestTerminalKey];
    }
    if ([savedValue  isEqual: @"DOM24"]){
        return @[kASDKTestTerminalKeyDOM24];
    }
    if ([savedValue  isEqual: @"MUP_IRKC"]){
        return @[kASDKTestTerminalKeyMUP_IRKC];
    }
//    if ([savedValue  isEqual: @"UK_Upravdom_Che"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"ReutComfort"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"UK_Service_Comfort"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"Servicekom"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"UK_Garant"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"Parus"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"Teplovodoresources"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"StroimBud"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"UKParitetKhab"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"JKH_Pavlovskoe"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"ElectroSbitSaratov"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"RodnikMUP"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
//    if ([savedValue  isEqual: @"AFregat"]){
//        return @[kASDKTestTerminalKeyKlimovsk];
//    }
    return @[kASDKTestTerminalKeyKlimovsk];
}

+ (NSString *)testActiveTerminal
{
    NSString *result = [ASDKTestSettings valueForKey:kActiveTerminal];
    if (result == nil)
    {
        result = kASDKTestTerminalKeyKlimovsk;
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"targetName"];
        NSLog(@"%@TARGET_NAME: ", savedValue);
        if ([savedValue  isEqual: @"MupRCMytishi"]){
            result = kASDKTestTerminalKey;
        }
        if ([savedValue  isEqual: @"DOM24"]){
            result = kASDKTestTerminalKeyDOM24;
        }
        if ([savedValue  isEqual: @"MUP_IRKC"]){
            result = kASDKTestTerminalKeyMUP_IRKC;
        }
//        if ([savedValue  isEqual: @"UK_Upravdom_Che"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"ReutComfort"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"UK_Service_Comfort"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"Servicekom"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"UK_Garant"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"Parus"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"Teplovodoresources"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"StroimBud"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"UKParitetKhab"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"JKH_Pavlovskoe"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"ElectroSbitSaratov"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"RodnikMUP"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
//        if ([savedValue  isEqual: @"AFregat"]){
//            result = kASDKTestTerminalKeyKlimovsk;
//        }
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
    NSLog(@"%@TARGET_NAME: ", savedValue);
    if ([savedValue  isEqual: @"MupRCMytishi"]){
        return kASDKTestPassword;
    }
    if ([savedValue  isEqual: @"DOM24"]){
        return kASDKTestPasswordDOM24;
    }
    if ([savedValue  isEqual: @"MUP_IRKC"]){
        return kASDKTestPasswordMUP_IRKC;
    }
//    if ([savedValue  isEqual: @"UK_Upravdom_Che"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"ReutComfort"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"UK_Service_Comfort"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"Servicekom"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"UK_Garant"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"Parus"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"Teplovodoresources"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"StroimBud"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"UKParitetKhab"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"JKH_Pavlovskoe"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"ElectroSbitSaratov"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"RodnikMUP"]){
//        return kASDKTestPasswordKlimovsk;
//    }
//    if ([savedValue  isEqual: @"AFregat"]){
//        return kASDKTestPasswordKlimovsk;
//    }
    return kASDKTestPasswordKlimovsk;
}

+ (NSString *)testPublicKey
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"targetName"];
    NSLog(@"%@TARGET_NAME: ", savedValue);
    if ([savedValue  isEqual: @"MupRCMytishi"]){
        return kASDKTestPublicKey;
    }
    if ([savedValue  isEqual: @"DOM24"]){
        return kASDKTestPublicKeyDOM24;
    }
    if ([savedValue  isEqual: @"MUP_IRKC"]){
        return kASDKTestPublicKeyMUP_IRKC;
    }
//    if ([savedValue  isEqual: @"UK_Upravdom_Che"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"ReutComfort"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"UK_Service_Comfort"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"Servicekom"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"UK_Garant"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"Parus"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"Teplovodoresources"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"StroimBud"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"UKParitetKhab"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"JKH_Pavlovskoe"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"ElectroSbitSaratov"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"RodnikMUP"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
//    if ([savedValue  isEqual: @"AFregat"]){
//        return kASDKTestPublicKeyKlimovsk;
//    }
    return kASDKTestPublicKeyKlimovsk;
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
