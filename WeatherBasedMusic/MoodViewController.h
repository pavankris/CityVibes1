//
//  MoodViewController.h
//  WeatherBasedMusic
//
//  Created by pavan krishnamurthy on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoodViewController : UIViewController {
    double mood;
    
}
@property (weak, nonatomic) IBOutlet UITextField *moodValue;
@property (weak, nonatomic) IBOutlet UIImageView *moodImage;
-(void)setMood:(double)moodval;
@end
