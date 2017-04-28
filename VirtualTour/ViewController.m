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

NSString *databasePath;// = [[NSBundle mainBundle] pathForResource:@"VirtualTourIOSDB" ofType:@"db"];
FMDatabase *db;// = [FMDatabase databaseWithPath:databasePath];
GMSMapView *mapView;
NSArray *majorArray;
NSMutableArray *majorsToDisplay;
NSMutableArray *listOfMarkers;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupElements];
    
    //BUILD PHASES -> BUNDLE RESOURCES(!!!)
    databasePath = [[NSBundle mainBundle] pathForResource:@"VirtualTourIOSDB" ofType:@"db"];
    db = [FMDatabase databaseWithPath:databasePath];
    
    if (![db open]) {
        // [db release];   // uncomment this line in manual referencing code; in ARC, this is not necessary/permitted
        db = nil;
        NSLog(@"Couldn't find db");
        return;
    }
    
    NSString *query = [NSString stringWithFormat: @"SELECT * FROM VirtualTourIOSDatabase"];
    
    //This query works for specific majors. For now, we will just use everything.
    //NSString *query = [NSString stringWithFormat: @"SELECT * FROM VirtualTourIOSDatabase WHERE major = '%@'", requestedMajor];
    FMResultSet *s = [db executeQuery:query];
    
    while([s next]) {
        
        //int id = [s intForColumn:@"id"];
        NSString *title = [s stringForColumn:@"title"];
        NSString *major = [s stringForColumn:@"major"];
        
        NSString *latitude = [s stringForColumn:@"latitude"];
        NSString *longitude = [s stringForColumn:@"longitude"];
        
        double lat = [latitude doubleValue];
        double lon = [longitude doubleValue];
        CLLocationCoordinate2D position =
        CLLocationCoordinate2DMake(lat, lon);
        
        UIColor *markerColor = [self getMarkerColor:major];
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = title;
        marker.icon = [GMSMarker markerImageWithColor:markerColor];
        marker.map = mapView;
    }
    
    //[self generateMarkersFromDatabaseUsingMajor:@"ReplaceWithRealMajorLater"];

}
    
- (void) setupElements {
    //databasePath = [[NSBundle mainBundle] pathForResource:@"VirtualTourIOSDB" ofType:@"db"];
    //db = [FMDatabase databaseWithPath:databasePath];
    

    
    majorArray = @[@"Graduate Division", @"Computer Science", @"CS: Game Design",
                   @"Computer Engineering", @"Electrical Engineering",
                   @"Technology Information Management", @"Bioengineering", @"Organizations"];
    
}


- (void)loadView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.000225
                                                            longitude:-122.063148
                                                                 zoom:18];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Test";
    marker.snippet = @"Test2";
    marker.map = mapView;
    
}

- (void) generateMarkersFromDatabaseUsingMajor:(NSString*) requestedMajor{
    //FMResultSet *s = [db executeQuery:@"SELECT * FROM VirtualTourIOSDatabase WHERE major = " + requestedMajor];
    
    NSString *query = [NSString stringWithFormat: @"SELECT * FROM VirtualTourIOSDatabase"];
    
    //This query works for specific majors. For now, we will just use everything.
    //NSString *query = [NSString stringWithFormat: @"SELECT * FROM VirtualTourIOSDatabase WHERE major = '%@'", requestedMajor];
    FMResultSet *s = [db executeQuery:query];
    while([s next]) {
        
        //int id = [s intForColumn:@"id"];
        NSString *title = [s stringForColumn:@"title"];
        NSString *major = [s stringForColumn:@"major"];
        
        NSString *latitude = [s stringForColumn:@"latitude"];
        NSString *longitude = [s stringForColumn:@"longitude"];
        
        double lat = [latitude doubleValue];
        double lon = [longitude doubleValue];
        CLLocationCoordinate2D position =
        CLLocationCoordinate2DMake(lat, lon);
        
        UIColor *markerColor = [self getMarkerColor:major];
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = title;
        marker.icon = [GMSMarker markerImageWithColor:markerColor];
        marker.map = mapView;
     }
}

//Obj-C does not switch on Strings
- (UIColor*) getMarkerColor: (NSString*) major {
    if([major isEqualToString:@"Computer Science"]) {
        NSLog(@"Computer Science");
        return [UIColor blackColor];
    } else if([major isEqualToString:@"Computer Engineering"]){
        NSLog(@"Computer Engineering");
        return [UIColor blueColor];

    } else if([major isEqualToString:@"Electrical Engineering"]){
        NSLog(@"Electrical Engineering");
        return [UIColor brownColor];

    } else if([major isEqualToString:@"CS: Game Design"]){
        NSLog(@"Computer Science: Game Design");
        return [UIColor orangeColor];

    } else if([major isEqualToString:@"Graduate Division"]){
        NSLog(@"Graduate Division");
        return [UIColor yellowColor];

    } else if([major isEqualToString:@"Bioengineering"]){
        NSLog(@"Bioengineering");
        return [UIColor purpleColor];
    }
    NSLog(@"Default");
    return [UIColor clearColor];
}

/*
 
 
 private float getMarkerColor(String major) {
 switch(major) {
 case "Computer Science":
 System.out.println("HUE_BLUE: " + BitmapDescriptorFactory.HUE_BLUE);
 return BitmapDescriptorFactory.HUE_GREEN;
 case "Computer Engineering":
 System.out.println("HUE_AZURE: " + BitmapDescriptorFactory.HUE_AZURE);
 return BitmapDescriptorFactory.HUE_ORANGE;
 case "Electrical Engineering":
 return BitmapDescriptorFactory.HUE_BLUE;
 case "CS: Game Design":
 return BitmapDescriptorFactory.HUE_MAGENTA;
 case "Graduate Division":
 return BitmapDescriptorFactory.HUE_YELLOW;
 case "Bioengineering":
 return BitmapDescriptorFactory.HUE_ROSE;
 default:
 return BitmapDescriptorFactory.HUE_RED;
 }
 }
 
 
 public void generateMarkersFromDatabaseUsingMajor(String requestedMajor) {
 Cursor c = myDB.rawQuery("SELECT * FROM " + TableName + " WHERE  major = " + "'"+requestedMajor+"'", null);
 
 float colorOfMarker;
 while (c.moveToNext()) {
 int idIndex = c.getColumnIndex("id");
 int titleIndex = c.getColumnIndex("title");
 int latitudeIndex = c.getColumnIndex("latitude");
 int longitudeIndex = c.getColumnIndex("longitude");
 int majorIndex = c.getColumnIndex("major");
 
 String id = c.getString(idIndex);
 String title = c.getString(titleIndex);
 String latitude = c.getString(latitudeIndex);
 String longitude = c.getString(longitudeIndex);
 String major = c.getString(majorIndex);
 colorOfMarker = getMarkerColor(major);
 
 int tag = Integer.parseInt(id);
 double lat = Double.parseDouble(latitude);
 double lon = Double.parseDouble(longitude);
 LatLng latLong = new LatLng(lat, lon);
 
 
 Marker marker = mMap.addMarker(new MarkerOptions().position(latLong).title(title).icon(BitmapDescriptorFactory.defaultMarker(colorOfMarker)));
 marker.setTag(tag);
 
 listOfMarkers.add(marker);
 }
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
