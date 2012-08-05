//
//  AppDelegate.h
//  WeatherBasedMusic
//
//  Created by pavan krishnamurthy on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
     Rdio *rdio;
}

+(Rdio *)rdioInstance;

@property (strong, nonatomic) UIWindow *window;
@property (readonly) Rdio *rdio;

@end
