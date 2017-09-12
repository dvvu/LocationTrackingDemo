//
//  ViewController.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/6/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "DirectionCustomViewDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "DetailCustomViewDelegate.h"
#import "DirectionDetailEntity.h"
#import "GoogleMaps/GoogleMaps.h"
#import "SearchPlacesCustomView.h"
#import "DirectionCustomView.h"
#import "GoogleMapManager.h"
#import "SearchNearbyEntity.h"
#import "DetailCustomView.h"
#import "ViewController.h"
#import "SupportManager.h"
#import "Masonry.h"

@interface ViewController () <GMSMapViewDelegate, DirectionCustomViewDelegate, DetailCustomViewDelegate, CompoboxCustomViewHeightDelegate>

@property (nonatomic) SearchPlacesCustomView* searchPlacesCustomView;
@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) DirectionCustomView* directionView;
@property (nonatomic) DetailCustomView* detailCustomView;
@property (nonatomic) GoogleMapManager* googleMapManager;
@property (nonatomic) GMSPolyline* currentPolyline;
@property (nonatomic) GMSMarker* myloactionMarker;
@property (nonatomic) CLLocation* currentLocation;
@property (nonatomic) UIView* containMapView;
@property (nonatomic) GMSMapView* mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupMapView];
    [self setupBarButton];
    [self setUpDirectionView];
}

#pragma mark - setupMapView

- (void)setupMapView {
    
    _containMapView = [[UIView alloc] initWithFrame:CGRectZero];
    _locationManager = [[CLLocationManager alloc] init];
    _mapView = [[GMSMapView alloc] init];
    _mapView.delegate = self;
    [self.view addSubview:_containMapView];
    [_containMapView addSubview:_mapView];
    
    [_containMapView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.edges.equalTo(_containMapView);
    }];
    
    _googleMapManager = [[GoogleMapManager alloc] initWithMapView:_mapView andLocationManager:_locationManager];
}

#pragma mark - setupBarButton

- (void)setupBarButton {
    
    UIButton* directionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [directionButton addTarget:self action:@selector(direction:) forControlEvents:UIControlEventTouchUpInside];
    [directionButton setShowsTouchWhenHighlighted:YES];
    [directionButton setImage:[UIImage imageNamed:@"ic_direction"] forState:UIControlStateNormal];
    UIBarButtonItem* directionBarButton = [[UIBarButtonItem alloc] initWithCustomView:directionButton];
    self.navigationItem.rightBarButtonItem = directionBarButton;
    
    UIButton* searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setShowsTouchWhenHighlighted:YES];
    [searchButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    UIBarButtonItem* searchBarButton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.leftBarButtonItem = searchBarButton;
}

#pragma mark - setUpDirectionView

- (void)setUpDirectionView {
    
    // direction CustomView
    _directionView = [[DirectionCustomView alloc] init];
    _directionView.delegate = self;
    [self.view addSubview:_directionView];
    
    [_directionView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_containMapView.mas_top).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(@150);
    }];
    
    [_directionView setHidden:YES];
    
    // detail CustomView
    _detailCustomView = [[DetailCustomView alloc] init];
    _detailCustomView.delegate = self;
    [self.view addSubview:_detailCustomView];
    
    [_detailCustomView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.bottom.equalTo(_containMapView.mas_bottom).offset(0);
        make.right.equalTo(_containMapView.mas_right).offset(0);
        make.width.equalTo(@200);
        make.height.equalTo(@70);
    }];
    
    [_detailCustomView setHidden:YES];
    
    // search CustomView
    _searchPlacesCustomView = [[SearchPlacesCustomView alloc] init];
    _searchPlacesCustomView.delegate = self;
    [self.view addSubview:_searchPlacesCustomView];
    
    [_searchPlacesCustomView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.top.equalTo(_containMapView.mas_top).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(@70);
    }];
    
    [_searchPlacesCustomView setHidden:YES];
}

#pragma mark - direction

- (IBAction)direction:(id)sender {
    
    [UIView transitionWithView:_directionView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        [_searchPlacesCustomView setHidden:YES];
        [_directionView setHidden:NO];
    } completion:nil];
}

#pragma mark - search

- (IBAction)search:(id)sender {
    
    [UIView transitionWithView:_directionView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        [_searchPlacesCustomView setHidden:NO];
        [_directionView setHidden:YES];
    } completion:nil];
}

#pragma mark - drawDestination Deleagte

- (void)drawDestinationWithPlaceName:(NSString *)startPlaceName andDestinationPlaceName:(NSString *)destinationPlaceName {

    [_mapView clear];
    
    [UIView transitionWithView:_directionView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        [_directionView setHidden:YES];
        [_googleMapManager drawDiectionWithPlaceName:startPlaceName andDestinationName:destinationPlaceName completion:^(DirectionDetailEntity* directionDetailEntity) {
         
            if (directionDetailEntity) {
                
                directionDetailEntity.polyline.strokeWidth = 3;
                directionDetailEntity.polyline.strokeColor = [UIColor redColor];
                directionDetailEntity.polyline.map = _mapView;
                
                // update zoom and point
                GMSCoordinateBounds* bounds = [[GMSCoordinateBounds alloc] initWithPath:directionDetailEntity.path];
                GMSCameraUpdate* update = [GMSCameraUpdate fitBounds:bounds];
                [_mapView moveCamera:update];
                [_detailCustomView setupWithData:directionDetailEntity];
                [_detailCustomView setHidden:NO];
                
                 //show marker
                _myloactionMarker = [GMSMarker markerWithPosition:directionDetailEntity.startLocation.coordinate];
                _myloactionMarker.title = @"I'm Here";
                _myloactionMarker.map = _mapView;
                [_mapView setSelectedMarker:_myloactionMarker];
                
                GMSMarker* endnMarker = [GMSMarker markerWithPosition:directionDetailEntity.endLocation.coordinate];
                endnMarker.title = @"end Here";
                endnMarker.appearAnimation = YES;
                endnMarker.map = _mapView;
                [_mapView setSelectedMarker:endnMarker];
            }
        }];
    } completion:nil];
}

#pragma mark - getCurrentLocation

- (void)getCurrentLocation:(CGPoint)currentPoint {
    
    [_mapView clear];

    _currentLocation = [_googleMapManager getCurrentLocation];
    
    [_googleMapManager getAddressFromLocation:_currentLocation withCompletion:^(NSString* placeName, NSError* error) {
        
        if (!error) {
            
            _directionView.startTextField.text = placeName;
        }
    }];

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentPoint.x, currentPoint.y, 25.0f, 25.0f)];
    imageView.image = [SupportManager resizeImage:[UIImage imageNamed:@"ic_blueUser"] scaledToSize:CGSizeMake(25.0f, 25.0f)];
    [self.view addSubview: imageView];

    // animation
    [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        imageView.frame = CGRectMake(_containMapView.center.x - 12.5f, _containMapView.center.y - 25, 25.0f, 25.0f);
        GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude zoom:15];
        [_mapView animateToCameraPosition:camera];
    } completion:nil];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        imageView.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2.0 animations:^{
            
            imageView.transform = CGAffineTransformMakeScale(1, 1);
            
        } completion:^(BOOL finished) {
        
            _myloactionMarker = [GMSMarker markerWithPosition:_currentLocation.coordinate];
            _myloactionMarker.title = @"I'm Here";
            _myloactionMarker.icon = imageView.image;
            _myloactionMarker.map = _mapView;
            [_mapView setSelectedMarker:_myloactionMarker];
            [imageView removeFromSuperview];
        }];
    }];
}

#pragma mark - searchCompleteWithText

- (void)searchCompleteWithText:(NSString *)searchString resultsType:(SearchResultTableType)type forTable:(UITableView *)tableView {
    
    NSLog(@"%@",searchString);
    
    if (searchString.length > 0) {
        
        [_googleMapManager autoCompleteSearchWithKey:searchString withCompletion:^(NSArray* results, NSError* error) {
            
            if (!error) {
                
                NSInteger resultCount = results.count;
                
                [_directionView setSearchResultsForTable:results with:type];
                
                if (resultCount == 0) {
                    
                    // cell not result -> 1 cell
                    [tableView mas_updateConstraints:^(MASConstraintMaker* make) {
                        
                        make.height.equalTo(@30);
                    }];
                    
                    [_directionView mas_updateConstraints:^(MASConstraintMaker* make) {
                        
                        make.height.equalTo(@180);
                    }];
                } else if (resultCount > 3) {
                    
                    [tableView mas_updateConstraints:^(MASConstraintMaker* make) {
                        
                        make.height.equalTo(@90);
                    }];
                    
                    [_directionView mas_updateConstraints:^(MASConstraintMaker* make) {
                        
                        make.height.equalTo(@240);
                    }];
                } else {
                    
                    [tableView mas_updateConstraints:^(MASConstraintMaker* make) {
                        
                        make.height.mas_equalTo(resultCount * 30);
                    }];
                    
                    [_directionView mas_updateConstraints:^(MASConstraintMaker* make) {
                        
                        make.height.mas_equalTo(150 + resultCount * 30);
                    }];
                }
            } else {
                
                [_directionView setSearchResultsForTable:results with:type];
                
                // cell not result -> 1 cell
                [tableView mas_updateConstraints:^(MASConstraintMaker* make) {
                    
                    make.height.equalTo(@30);
                }];
                
                [_directionView mas_updateConstraints:^(MASConstraintMaker* make) {
                    
                    make.height.equalTo(@180);
                }];
            }
        }];
    } else {
        
        [tableView mas_updateConstraints:^(MASConstraintMaker* make) {
            
            make.height.equalTo(@0);
        }];
        
        [_directionView mas_updateConstraints:^(MASConstraintMaker* make) {
            
            make.height.equalTo(@150);
        }];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - closeDetailCustomView Delegate

- (void)closeDetailCustomView {
    
    [_detailCustomView setHidden:YES];
}

#pragma mark - updateCompoboxCustomViewHeight

- (void)updateCompoboxCustomViewHeight {
    
    [_searchPlacesCustomView mas_updateConstraints:^(MASConstraintMaker* make) {
        
        make.height.equalTo(@170);
    }];
}

#pragma mark - resetCompoboxCustomViewHeight

- (void)resetCompoboxCustomViewHeight {
    
    [_searchPlacesCustomView mas_updateConstraints:^(MASConstraintMaker* make) {
        
        make.height.equalTo(@70);
    }];
}

#pragma mark - searchWithPlace

- (void)searchWithPlace:(NSString *)placeName andRadius:(NSString *)radius {
    
    if (!_currentLocation) {
        
        _currentLocation = [_googleMapManager getCurrentLocation];
    }
    
    if (!_myloactionMarker) {
        
        _myloactionMarker = [GMSMarker markerWithPosition:_currentLocation.coordinate];
        _myloactionMarker.title = @"I'm Here";
        _myloactionMarker.icon = [SupportManager resizeImage:[UIImage imageNamed:@"ic_blueUser"] scaledToSize:CGSizeMake(25.0f, 25.0f)];
        _myloactionMarker.map = _mapView;
        [_mapView setSelectedMarker:_myloactionMarker];
    }
    
    GMSCameraPosition* camera = [GMSCameraPosition cameraWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude zoom:15];
    [_mapView animateToCameraPosition:camera];
    
    [_googleMapManager searchAtLocation:_currentLocation withPlaceName:placeName andRadius:radius completion:^(ThreadSafeForMutableArray*threadSafeForMutableArray) {
        
        [threadSafeForMutableArray enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL* stop) {
            
            if (idx < 20) {
                
                SearchNearbyEntity* entity = object;
                GMSMarker* endnMarker = [GMSMarker markerWithPosition:entity.location.coordinate];
                endnMarker.appearAnimation = YES;
                
                [_googleMapManager getAddressFromLocation:entity.location withCompletion:^(NSString* placeName, NSError* error) {
                    
                    if (!error) {
                        
                        endnMarker.title = placeName;
                        endnMarker.map = _mapView;
                    }
                }];
            }
        }];
    }];
}

#pragma mark - mapViewDelegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    [_mapView setSelectedMarker:marker];
  
    // clear polyline
    if(_currentPolyline) {
        
        [_currentPolyline setMap:nil];
    }
    
    [UIView transitionWithView:_directionView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        CLLocation* destinationLocation = [[CLLocation alloc] initWithLatitude:marker.position.latitude longitude:marker.position.longitude];
        [_directionView setHidden:YES];
        
        [_googleMapManager drawDiectionWithStartLocation:_currentLocation andDestinationLocation:destinationLocation completion:^(DirectionDetailEntity* directionDetailEntity) {
            
            if (directionDetailEntity) {
                
                directionDetailEntity.polyline.strokeWidth = 3;
                directionDetailEntity.polyline.strokeColor = [UIColor redColor];
                directionDetailEntity.polyline.map = _mapView;
                _currentPolyline = directionDetailEntity.polyline;
                // update zoom and point
                GMSCoordinateBounds* bounds = [[GMSCoordinateBounds alloc] initWithPath:directionDetailEntity.path];
                GMSCameraUpdate* update = [GMSCameraUpdate fitBounds:bounds];
                [_mapView moveCamera:update];
                [_detailCustomView setupWithData:directionDetailEntity];
                [_detailCustomView setHidden:NO];
            }
        }];
    } completion:nil];
    
    return YES;
}

@end
