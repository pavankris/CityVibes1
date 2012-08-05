//
//  CityDetailViewController.m
//  WeatherBasedMusic
//
//  Created by pavan krishnamurthy on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityDetailViewController.h"
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"
#import "MoodViewController.h"
//#import "CFURL.h"

@implementation CityDetailViewController
@synthesize artistsongarray=_artistsongarray;
@synthesize player=_player;
@synthesize queue=_queue;
@synthesize SongTable = _SongTable;
@synthesize songartistdict=_songartistdict;
@synthesize playlists=_playlists;

int currentsongindx;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
    currentsongindx=0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    Rdio *rdio = [AppDelegate rdioInstance];
    hotness=0;
    playing=false;
    self.queue = [[NSOperationQueue alloc] init];
    if(rdio)
    {
        [[rdio player] setDelegate:self];
    }
    NSLog(@"number of songs = %i",self.artistsongarray.count);
    
    for (int i =0; i<self.artistsongarray.count; i++) {
        NSScanner *scanner = [NSScanner scannerWithString:[self.artistsongarray objectAtIndex:i]];
        NSString *songString=nil;
        NSString *artistString=nil;
        //NSLog(@"%@",[self.artistsongarray objectAtIndex:i]);
        NSRange textRange;
        textRange =[[self.artistsongarray objectAtIndex:i] rangeOfString:@"#Shazam"];
        if(textRange.location == NSNotFound)
        {
            [scanner scanUpToString:@" by" intoString:&songString];        
            [scanner scanString:@"by" intoString:nil];
            [scanner scanUpToString:@"#" intoString:&artistString];
            if(!self.songartistdict)
                self.songartistdict = [[NSMutableDictionary alloc]init];
            if(artistString)
            {
                [self.songartistdict setObject:artistString forKey:songString];                
                [self loadSongMetadata:songString atindex:i];
            }
        }
        
    }
}

-(void)loadSongMetadata:(NSString *)songString atindex:(int)index
{
    
    NSString *baseurlString = @"http://developer.echonest.com/api/v4/song/search?api_key=FYYCJQBOVIKIH6FR8&format=json&results=1&bucket=song_hotttnesss&artist=";
    NSString *artist = [self.songartistdict objectForKey:songString];
    NSString *songtemp = [songString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *artisttemp = [artist stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@&title=%@&bucket=tracks&bucket=id:rdio-us-streaming",baseurlString,artisttemp,songtemp];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    void (^successBlock)(NSURLRequest *,NSHTTPURLResponse *,id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        //NSLog(@"%@",JSON);
        NSMutableDictionary *responsedict = [JSON objectForKey:@"response"];
        NSMutableArray *playlist = [[NSMutableArray alloc]init];
        
        
        NSMutableArray *songsarray = [responsedict objectForKey:@"songs"];
        for (int i=0; i<songsarray.count; i++) {
            NSMutableArray *foreign_ids= [[songsarray objectAtIndex:i]objectForKey:@"foreign_ids"];
            for(int j =0;j<foreign_ids.count;j++)
            {
                double echohotness = [[[songsarray objectAtIndex:i]objectForKey:@"song_hotttnesss"]doubleValue];
                hotness = (hotness * (index+1)) + echohotness;
                hotness = hotness / (index+1);
                NSString *foreign_id = [[foreign_ids objectAtIndex:j]objectForKey:@"foreign_id"];
                NSScanner *rdioidscanner = [NSScanner scannerWithString:foreign_id];
                NSString *trackString=nil;
                [rdioidscanner scanUpToString:@"song:" intoString:nil];
                [rdioidscanner scanString:@"song:" intoString:nil];
                [rdioidscanner scanUpToString:@"#" intoString:&trackString];
                [playlist addObject:trackString];
                NSLog(@"track=%@",trackString);
            }            
        }        
        if(playlist.count > 0)
        {
            if(!playing) {
                [self.getPlayer playSources:playlist];
                playing = true;
            }
            if(!self.playlists)
                self.playlists = [[NSMutableDictionary alloc]init];
            [self.playlists setObject :playlist forKey:songString];
            [self.SongTable reloadData];
        }
        //[self.playlist addObjectsFromArray:[responsedict objectForKey:@"songs"]];            
        
    };
    void (^failureBlock)(NSURLRequest *,NSHTTPURLResponse *,NSError *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //[self hideActivityIndicator];
        
        //NSURL *url = [request URL];
        
        
        
        
        
        NSLog(@"error: %@", error);
        
    };
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:successBlock failure:failureBlock];
    
    [operation start];
    
}
#pragma mark -
#pragma mark RdioDelegate

- (void) rdioDidAuthorizeUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken {
    //[self setLoggedIn:YES];
}

- (void) rdioAuthorizationFailed:(NSString *)error {
    //[self setLoggedIn:NO];
}

- (void) rdioAuthorizationCancelled {
    //[self setLoggedIn:NO];
}

- (void) rdioDidLogout {
    //[self setLoggedIn:NO];
}

-(RDPlayer*)getPlayer
{
    if (self.player == nil) {
        self.player = [AppDelegate rdioInstance].player;
    }
    return self.player;
}




- (void)viewDidUnload
{
    [self setSongTable:nil];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark -
#pragma mark RDPlayerDelegate

- (BOOL) rdioIsPlayingElsewhere {
    // let the Rdio framework tell the user.
    return NO;
}

- (void) rdioPlayerChangedFromState:(RDPlayerState)fromState toState:(RDPlayerState)state {
    NSLog(@"State Changed");
    if(playing && state == RDPlayerStateStopped)
    {
    int count = self.playlists.count;
    int value = arc4random() % count;
    
     NSString *song =    [[self.playlists allKeys]objectAtIndex:value];
     NSArray *playlist = [self.playlists objectForKey:song];
    
    int subcount = playlist.count;
    int trackval = arc4random() % subcount;
    
    //[self.getPlayer stop];
    [self.getPlayer playSource:[playlist objectAtIndex:trackval]];
    }
    /*playing = (state != RDPlayerStateInitializing && state != RDPlayerStateStopped);
    paused = (state == RDPlayerStatePaused);
    if (paused || !playing) {
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }*/
}


- (IBAction)PlayButtonClicked:(id)sender {
    
    //[self performSegueWithIdentifier:@"ShowMood" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowMood"]) {
        MoodViewController *mvc = [segue destinationViewController];
        [mvc setMood:hotness];
         
    }
}
#pragma TableView
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SongCell";
    
    UITableViewCell *cell = [self.SongTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *song= [[self.playlists allKeys]objectAtIndex:indexPath.row];
    cell.textLabel.text = song;
    NSString *artist = [self.songartistdict objectForKey:song];
    cell.detailTextLabel.text=artist;
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
    /*if(self.songartistdict)
        return self.songartistdict.count;
    return 0;*/
    NSLog(@"%@",self.playlists);
    if(self.playlists)
        return self.playlists.count;
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath  {
    return NO;
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath  {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    
    NSString *song = [[self.playlists allKeys]objectAtIndex:indexPath.row];
    NSArray *playlist = [self.playlists objectForKey:song];
    if(playlist != nil && [playlist count] > 0)
    {
        [self.getPlayer stop];
        [self.getPlayer playSources:playlist];
        NSLog(@"will play...%@",playlist);
    }
    [self.SongTable deselectRowAtIndexPath:indexPath animated:YES];
    /*NSString *baseurlString = @"http://developer.echonest.com/api/v4/song/search?api_key=FYYCJQBOVIKIH6FR8&format=json&results=5&artist=";
    NSString *song = [[self.songartistdict allKeys]objectAtIndex:indexPath.row];
    NSString *artist = [self.songartistdict objectForKey:song];
    NSString *songtemp = [song stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *artisttemp = [artist stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSString *songtemp = [song stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    /*NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                            NULL,
                            (CFStringRef)unencodedString,
                            NULL,
                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                            kCFStringEncodingUTF8 );*/
    /*NSString *urlString = [NSString stringWithFormat:@"%@%@&title=%@&bucket=tracks&bucket=id:rdio-us-streaming",baseurlString,artisttemp,songtemp];
    //NSString *urlStringencoded = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSLog(@"url=%@",urlString);
     NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"The url is: >>>>>%@<<<<<", url);
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     void (^successBlock)(NSURLRequest *,NSHTTPURLResponse *,id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
     
     //NSLog(@"%@",JSON);
     NSMutableDictionary *responsedict = [JSON objectForKey:@"response"];
     NSMutableArray *playlist = [[NSMutableArray alloc]init];
         
     NSMutableArray *songsarray = [responsedict objectForKey:@"songs"];
     for (int i=0; i<songsarray.count; i++) {
         NSMutableArray *foreign_ids= [[songsarray objectAtIndex:i]objectForKey:@"foreign_ids"];
     for(int j =0;j<foreign_ids.count;j++)
     {
         NSString *foreign_id = [[foreign_ids objectAtIndex:j]objectForKey:@"foreign_id"];
         NSScanner *rdioidscanner = [NSScanner scannerWithString:foreign_id];
         NSString *trackString=nil;
         [rdioidscanner scanUpToString:@"song:" intoString:nil];
         [rdioidscanner scanString:@"song:" intoString:nil];
         [rdioidscanner scanUpToString:@"#" intoString:&trackString];
         [playlist addObject:trackString];
         NSLog(@"track=%@",trackString);
     }
     //[self.getPlayer playSources:playlist];
     }
     //[self.playlist addObjectsFromArray:[responsedict objectForKey:@"songs"]];            
     
     };
     void (^failureBlock)(NSURLRequest *,NSHTTPURLResponse *,NSError *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
     //[self hideActivityIndicator];
     
     //NSURL *url = [request URL];
     
     
     
     
     
     NSLog(@"error: %@", error);
     
     };
     AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:successBlock failure:failureBlock];
     
     [operation start];
     */
}
@end
