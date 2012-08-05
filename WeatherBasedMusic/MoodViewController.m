//
//  MoodViewController.m
//  WeatherBasedMusic
//
//  Created by pavan krishnamurthy on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoodViewController.h"

@implementation MoodViewController
@synthesize moodValue;
@synthesize moodImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setMood:(double)moodval
{
    mood = moodval;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(mood < 0.2)
    {
        UIImage *img = [UIImage imageNamed:@"fixed0.png"];

        [moodImage setImage:img];       
    }
    else if(mood >= 0.2 && mood < 0.4)
    {
        UIImage *img = [UIImage imageNamed:@"fixed2.png"];
        
        [moodImage setImage:img];
    }
    else if(mood >= 0.4 && mood < 0.6)
    {
        UIImage *img = [UIImage imageNamed:@"fixed4.png"];
        
        [moodImage setImage:img];
    }
    else if(mood >= 0.6 && mood < 0.8)
    {
        UIImage *img = [UIImage imageNamed:@"fixed6.png"];
        
        [moodImage setImage:img];
    }
    else
    {
        UIImage *img = [UIImage imageNamed:@"hot8fixed.png"];        
        [moodImage setImage:img];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMoodValue:nil];
    [self setMoodImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
