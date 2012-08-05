//
//  ViewController.h
//  WeatherBasedMusic
//
//  Created by pavan krishnamurthy on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableDictionary *cityDict;
@property (nonatomic,strong)NSMutableArray *artistsongarray;
- (IBAction)HappyButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (nonatomic,strong) NSArray *listofCities;

@end
