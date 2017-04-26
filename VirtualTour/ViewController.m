//
//  ViewController.m
//  VirtualTour
//
//  Created by Dylan Tieu on 4/25/17.
//  Copyright © 2017 rwpham. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "FMDB.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"VirtualTourIOSDB" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
   
    if (![db open]) {
        // [db release];   // uncomment this line in manual referencing code; in ARC, this is not necessary/permitted
        db = nil;
        NSLog(@"Couldn't find db");
        return;
    }
    
    

    FMResultSet *s = [db executeQuery:@"SELECT * FROM VirtualTourIOSDatabase"];
    
   while([s next]) {
        NSLog(@"Point with id: %d has title: %@ and major: %@.",
              [s intForColumn:@"id"],
              [s stringForColumn:@"title"],
              [s stringForColumn:@"major"]);
    }
    
}


- (void)loadView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
