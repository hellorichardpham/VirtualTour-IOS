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
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"VirtualTourIOSDB.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
   
    if (![db open]) {
        // [db release];   // uncomment this line in manual referencing code; in ARC, this is not necessary/permitted
        db = nil;
        return;
    }
    FMResultSet *s = [db executeQuery:@"SELECT COUNT(*) FROM myTable"];
    int totalCount = 0;
    if ([s next]) {
        totalCount = [s intForColumnIndex:0];
    }
    
    NSLog(@"index: %d\n", totalCount);
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
