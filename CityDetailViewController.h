//
//  CityDetailViewController.h
//  WeatherBasedMusic
//
//  Created by pavan krishnamurthy on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rdio/Rdio.h"

@interface CityDetailViewController : UITableViewController<RdioDelegate,RDPlayerDelegate>
{
    BOOL playing;
    BOOL loggedIn;
    double hotness;
}
- (IBAction)PlayButtonClicked:(id)sender;
@property(nonatomic,strong) NSMutableArray *artistsongarray;
@property (retain) RDPlayer *player;
@property(nonatomic,strong)NSOperationQueue *queue;
@property (weak, nonatomic) IBOutlet UITableView *SongTable;
@property(nonatomic,strong)NSMutableDictionary *songartistdict;
@property(nonatomic,strong)NSMutableDictionary *playlists;
-(RDPlayer*)getPlayer;
-(void)loadSongMetadata:(NSString *)songString atindex:(int)index;
@end
