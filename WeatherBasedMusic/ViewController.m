//
//  ViewController.m
//  WeatherBasedMusic
//
//  Created by pavan krishnamurthy on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AFJSONRequestOperation.h"
//#import "CLLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLGeocoder.h>
#import "CityDetailViewController.h"
@implementation ViewController
@synthesize cityTableView = _cityTableView;

@synthesize dataSource = _dataSource;
@synthesize locationManager=_locationManager;
@synthesize cityDict = _cityDict;
@synthesize artistsongarray = _artistsongarray;
@synthesize listofCities=_listofCities;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.listofCities = [NSArray arrayWithObjects:@"San Francisco",@"Manhattan",@"Los Angeles",@"Miami",@"Chicago", nil];
	// Do any additional setup after loading the view, typically from a nib.
   self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    NSString *currentLatitude = [[NSString alloc] 
                                 initWithFormat:@"%g", 
                                 newLocation.coordinate.latitude];
    
    NSString *currentLongitude = [[NSString alloc] 
                                  initWithFormat:@"%g",
                                  newLocation.coordinate.longitude];
    
    //NSLog(@"%@ %@",currentLatitude,currentLongitude);
    // this creates a MKReverseGeocoder to find a placemark using the found coordinates
    void (^geoLocationFound)(NSArray *placemarks, NSError *error) = ^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark* aPlacemark in placemarks)
        {
            NSLog(@"Got Placemark : %@", aPlacemark);  
        }
        /*if(placemarks && placemarks.count > 0)
        {
            CLPlacemark* placemark = [placemarks objectAtIndex:0];           
            //Using blocks, get zip code
            NSString* cityName = [placemark name];
            NSLog(@"Current City=%@",cityName);
        }*/
    };
    
    CLGeocoder* reverseGeocoder = [[CLGeocoder alloc] init];
    if (reverseGeocoder) {
        [reverseGeocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if(placemarks && placemarks.count > 0)
            {
                
            CLPlacemark* placemark = [placemarks objectAtIndex:0];           
                //Using blocks, get zip code
                NSString* cityName = [placemark name];
                NSLog(@"Current City=%@",cityName);
                if(!self.cityDict)
                    self.cityDict = [[NSMutableDictionary alloc]init];
                //[self.cityDict setObject:newLocation forKey:cityName];
                [self.locationManager stopUpdatingLocation];
                
                for (int i =0; i<self.listofCities.count; i++) {
                    CLLocation *location;
                    if ([self.listofCities objectAtIndex:i] == @"Chicago") {
                        location = [[CLLocation alloc]initWithLatitude:(CLLocationDegrees)41.79 longitude:(CLLocationDegrees)-87.75];
                        [self.cityDict setObject:location forKey:[self.listofCities objectAtIndex:i]];

                    }
                    else if([self.listofCities objectAtIndex:i] == @"Miami") {
                        location = [[CLLocation alloc]initWithLatitude:(CLLocationDegrees)25.82 longitude:(CLLocationDegrees)-80.28];
                        [self.cityDict setObject:location forKey:[self.listofCities objectAtIndex:i]];

                    }
                    else if([self.listofCities objectAtIndex:i] == @"San Francisco") {
                        location = [[CLLocation alloc]initWithLatitude:(CLLocationDegrees)37.62 longitude:(CLLocationDegrees)-122.38];
                        [self.cityDict setObject:location forKey:[self.listofCities objectAtIndex:i]];

                    }
                    else if([self.listofCities objectAtIndex:i] == @"Manhattan") {
                        location = [[CLLocation alloc]initWithLatitude:(CLLocationDegrees)40.77 longitude:(CLLocationDegrees)-73.98];
                        [self.cityDict setObject:location forKey:[self.listofCities objectAtIndex:i]];

                    }
                    else if([self.listofCities objectAtIndex:i] == @"Los Angeles") {
                        location = [[CLLocation alloc]initWithLatitude:(CLLocationDegrees)33.93 longitude:(CLLocationDegrees)-118.40];
                        [self.cityDict setObject:location forKey:[self.listofCities objectAtIndex:i]];
                        
                    }
                    
                    }
                [self.cityTableView reloadData];              
                
            }
            else
            {
                NSLog(@"Cannot get location");
            }
        }];   
   
    }
}
    

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

- (void)viewDidUnload
{
    
    [self setCityTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)HappyButtonClicked:(id)sender {
    
}

#pragma TableView
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"City";
    
    UITableViewCell *cell = [self.cityTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //cell.textLabel.text = [[[dataSource objectAtIndex:0]allValues]objectAtIndex:indexPath.row];
    
    NSString *city = [[self.cityDict allKeys] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = city;
    CLLocation *newLocation =  [self.cityDict objectForKey:city];
    if(newLocation)
    {
        NSString *currentLatitude = [[NSString alloc] 
                                 initWithFormat:@"%g", 
                                 newLocation.coordinate.latitude];
    
        NSString *currentLongitude = [[NSString alloc] 
                                  initWithFormat:@"%g",
                                  newLocation.coordinate.longitude];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@",currentLatitude,currentLongitude];
    }                      
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return 38.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 0.0;
}

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    
    if(self.cityDict)
        return self.cityDict.count;
    return 0;
}


// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath  {
    return NO;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath  {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //NSString *currentLine = [[[dataSource objectAtIndex:0]allValues]objectAtIndex:indexPath.row];
     
    NSString *currentCity = [[self.cityDict allKeys]objectAtIndex:indexPath.row];
    CLLocation *newLocation = [self.cityDict objectForKey:currentCity];
    NSLog(@"Selected = %@",currentCity);
    
    
    if(newLocation)
    {
        NSString *currentLatitude = [[NSString alloc] 
                                     initWithFormat:@"%g", 
                                     newLocation.coordinate.latitude];
        
        NSString *currentLongitude = [[NSString alloc] 
                                      initWithFormat:@"%g",
                                      newLocation.coordinate.longitude];
        NSString *baseurlString = @"http://search.twitter.com/search.json?q=%23Shazam&rpp=100&result_type=recent&geocode=";
        NSString *urlString = [NSString stringWithFormat:@"%@%@,%@,100mi",baseurlString,currentLatitude,currentLongitude];
        NSLog(@"urlString=%@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
        void (^successBlock)(NSURLRequest *,NSHTTPURLResponse *,id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            //NSLog(@"%@",JSON);
            NSLog(@"%i",[[JSON objectForKey:@"results"]count]);        
            self.dataSource = [[NSMutableArray alloc] init ];        
            [self.dataSource addObjectsFromArray:[JSON objectForKey:@"results"]];
            NSError  *error  = NULL;         
            if(self.artistsongarray == nil)
                self.artistsongarray = [[NSMutableArray alloc]init];
            else
                [self.artistsongarray removeAllObjects];
            for (int i=0; i<self.dataSource.count; i++) {
                
                
                NSString * textstring = [[self.dataSource objectAtIndex:i]objectForKey:@"text"];
                
                NSScanner *scanner = [NSScanner scannerWithString:textstring];
                NSRange textRange;
                textRange =[textstring rangeOfString:@"#Shazam to discover"];
                if(textRange.location == NSNotFound)
                    [scanner scanString:@"I Just used #Shazam to tag " intoString:nil];
                else
                    [scanner scanString:@"I Just used #Shazam to discover " intoString:nil];
                    NSString *substring = nil;
                    if([scanner scanUpToString:@". http" intoString:&substring]) {
                        [self.artistsongarray addObject:substring];
                    }
                    
                
                
                //NSLog(@"SongName=%@",textstring);
                
                //NSLog(@"%@",[[self.dataSource objectAtIndex:i]objectForKey:@"text"]);
            }      
            [self performSegueWithIdentifier:@"CityDetail" sender:self];

        
        };
    
        void (^failureBlock)(NSURLRequest *,NSHTTPURLResponse *,NSError *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //[self hideActivityIndicator];
            NSLog(@"error: %@", error);
        
        };
    
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:successBlock failure:failureBlock];
    
        [operation start];
    }
        [self.cityTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CityDetail"])
    {
        CityDetailViewController *vc = [segue destinationViewController];
         NSLog(@"number of songs = %i",self.artistsongarray.count);
        vc.artistsongarray = [NSArray arrayWithArray:self.artistsongarray];
        //[vc.artistsongarray arrayByAddingObjectsFromArray:self.artistsongarray];
    }

}



@end
