//
//  AppDelegate.h
//  PhotoFrames
//
//  Created by Badal-PUB on 25/03/16.
//  Copyright © 2016 Badal-PUB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property () BOOL restrictRotation;

+ (AppDelegate *)mainDelegate;

@end

