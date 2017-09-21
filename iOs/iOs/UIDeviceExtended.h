//
//  UIDevice.h
//  iOs
//
//  Created by Bernardo Breder on 06/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice (MyUIExtendedDevice)

+ (BOOL) is7_0Version;
+ (BOOL) is6_1Version;
+ (BOOL) is6_0Version;
+ (BOOL) is5_0Version;

@end
