//
//  UIDevice.m
//  iOs
//
//  Created by Bernardo Breder on 06/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "UIDeviceExtended.h"

@implementation UIDevice (MyUIExtendedDevice)

+ (BOOL) is7_0Version
{
    return [[UIDevice currentDevice].systemVersion floatValue] + 0.01 >= 7.0;
}

+ (BOOL) is6_1Version
{
    return [[UIDevice currentDevice].systemVersion floatValue] + 0.01 >= 6.1;
}

+ (BOOL) is6_0Version
{
    return [[UIDevice currentDevice].systemVersion floatValue] + 0.01 >= 6.0;
}

+ (BOOL) is5_0Version
{
    return [[UIDevice currentDevice].systemVersion floatValue] + 0.01 >= 5.0;
}

@end
