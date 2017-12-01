//
//  MessageListViewController.m
//  JustChatting
//
//  Created by Lemonade on 2017/8/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MessageListViewController.h"
#import "BasicNavigationController.h"
#import "LoginViewController.h"

@interface MessageListViewController () <BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, BMKRouteSearchDelegate>
/** 基础地图 */
@property (nonatomic, readwrite, strong) BMKMapView *mapView;
/** 定位服务 */
@property (nonatomic, readwrite, strong) BMKLocationService *locationService;
/** 地理编码服务 */
@property (nonatomic, readwrite, strong) BMKGeoCodeSearch *geoCodeSearchService;
/** 路径搜索服务 */
@property (nonatomic, readwrite, strong) BMKRouteSearch *routeSearchService;
/** 大头针 */
@property (nonatomic, readwrite, strong) BMKPointAnnotation *annotation;

/** 是否第一次定位 */
@property (nonatomic, readwrite, assign, getter=isFirstGetLocation) BOOL firstGetLocation;

@end

@implementation MessageListViewController

#pragma mark - Life Circle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    
    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
    
    if (!isAutoLogin) {
        BasicNavigationController *basicNavi = [[BasicNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [self presentViewController:basicNavi animated:YES completion:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    self.locationService.delegate = self;
    self.geoCodeSearchService.delegate = self;
    self.routeSearchService.delegate = self;
    [self.locationService startUserLocationService];
    
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    start.name = @"杭州大厦";
    start.cityName = @"杭州市";
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    end.name = @"火车东站";
    end.cityName = @"杭州市";
    BMKMassTransitRoutePlanOption *option = [[BMKMassTransitRoutePlanOption alloc] init];
    option.from = start;
    option.to = end;
    [self.routeSearchService massTransitSearch:option];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    self.locationService.delegate = nil;
    self.geoCodeSearchService.delegate = nil;
    self.routeSearchService.delegate = nil;
}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
#pragma mark - BMKLocationServiceDelegate
// 处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    
}
// 处理位置更新信息
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    if (self.isFirstGetLocation) {
        self.mapView.centerCoordinate = userLocation.location.coordinate;
        self.firstGetLocation = NO;
        [self.mapView setNeedsDisplay];
    }
    BMKReverseGeoCodeOption *reverseCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL reverseFlag = [self.geoCodeSearchService reverseGeoCode:reverseCodeSearchOption];

    if (reverseFlag) {
        PDLog(@"地理反编码成功");
    } else {
        PDLog(@"地理反编码失败");
    }
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_OPEN_NO_ERROR) {
//        PDLog(@"%@", result);
        self.annotation.coordinate = result.location;
        self.annotation.title = result.address;
        [self.mapView layoutSubviews];
    } else {
        PDLog(@"存在问题");
    }
}
#pragma mark - BMKRouteSearchDelegate
- (void)onGetMassTransitRouteResult:(BMKRouteSearch *)searcher result:(BMKMassTransitRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"%@", result);
}
#pragma mark - Lazy Load
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc] init];
        [self.view addSubview:_mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _mapView.zoomLevel = 19;
        self.firstGetLocation = YES;
    }
    return _mapView;
}
- (BMKLocationService *)locationService {
    if (_locationService == nil) {
        _locationService = [[BMKLocationService alloc] init];
    }
    return _locationService;
}
- (BMKPointAnnotation *)annotation {
    if (_annotation == nil) {
        _annotation = [[BMKPointAnnotation alloc] init];
        [self.mapView addAnnotation:_annotation];
    }
    return _annotation;
}
- (BMKGeoCodeSearch *)geoCodeSearchService {
    if (_geoCodeSearchService == nil) {
        _geoCodeSearchService = [[BMKGeoCodeSearch alloc] init];
        _geoCodeSearchService.delegate = self;
    }
    return _geoCodeSearchService;
}
- (BMKRouteSearch *)routeSearchService {
    if (_routeSearchService == nil) {
        _routeSearchService = [[BMKRouteSearch alloc] init];
    }
    return _routeSearchService;
}
@end
