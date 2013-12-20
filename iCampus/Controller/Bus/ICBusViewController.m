//
//  ICBusViewController.m
//  iCampus
//
//  Created by Kwei Ma on 12/2/13.
//  Copyright (c) 2013 BISTU. All rights reserved.
//

#import "ICBusViewController.h"
#import "../../Model/Bus/ICBus.h"
#import "../../View/Bus/ICBusCell.h"

@interface ICBusViewController ()

@property (nonatomic, strong) ICBusListArray *busLines;

@property (nonatomic, copy) NSIndexPath *expandingIndexPath;

@end

@implementation ICBusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.title = @"校车";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.busLines = [ICBusListArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.busLines.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#   warning ===TEST===
    if (section > self.busLines.count) {
        return 1;
    }
#   warning ===END===
    ICBusList *buses = [self.busLines busListAtIndex:section];
    return buses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICBus *bus = [[self.busLines busListAtIndex:indexPath.section] busAtIndex:indexPath.row];
#   warning Bus with same title might cause error.
    ICBusCell *cell = [tableView dequeueReusableCellWithIdentifier:bus.name];
    if (!cell) {
        cell = [[ICBusCell alloc] initWithBus:bus
                              reuseIdentifier:bus.name];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0;
}

- (UIView *)stopsLayoutForExpandingCellWithBus:(ICBus *)bus {
    CGFloat x=20.0;
    CGFloat height = 100.0; // height of cell is 120.0. But need 20 padding
    CGFloat width = 120.0;
    
    ICBusStationList *stopList = bus.stationList;
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, (width-10.0)*stopList.count+40.0, height)];
    
    UIImageView *deprIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 45.0, 20.0, 20.0)];
    deprIcon.image = [UIImage imageNamed:@"SchoolBusTimeIcon.png"];
    //UIImageView *retnIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 70.0, 20.0, 20.0)];
    //retnIcon.image = [UIImage imageNamed:@"SchoolBusRetnIcon.png"];
    [main addSubview:deprIcon];
    //[main addSubview:retnIcon];
    
    NSInteger count = stopList.count;
    for (int i = 0; i<count; i++) {
        ICBusStation *stop = [stopList stationAtIndex:i];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
        
        UILabel *stopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0, width - 20.0, 40.0)];
        UILabel *stopDeprLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 45.0, width - 20.0, 20.0)];
        //UILabel *stopRetnLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 70.0, width - 20.0, 20.0)];
        
        stopNameLabel.textAlignment = NSTextAlignmentCenter;
        stopDeprLabel.textAlignment = NSTextAlignmentCenter;
        //stopRetnLabel.textAlignment = NSTextAlignmentCenter;
        
        stopNameLabel.font = [UIFont systemFontOfSize:16.0];
        stopDeprLabel.font = [UIFont systemFontOfSize:14.0];
        //stopRetnLabel.font = [UIFont systemFontOfSize:14.0];
        
        stopNameLabel.textColor = [UIColor darkGrayColor];
        stopDeprLabel.textColor = [UIColor grayColor];
        //stopRetnLabel.textColor = [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1.0];
        
        //stopNameLabel.backgroundColor = [UIColor yellowColor];
        //stopDeprLabel.backgroundColor = [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1.0];
        //stopRetnLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1.0];
        container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusStationNormal"]];
        if (i == 0) {
            container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusStationFirst"]];
        }
        if (i == count - 1) {
            container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ICBusStationLast"]];
        }
        
        stopNameLabel.numberOfLines = 2;
        
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        stopNameLabel.text = stop.name;
        stopDeprLabel.text = [dateFormatter stringFromDate:stop.time]==nil?@"-":[dateFormatter stringFromDate:stop.time];
        //stopRetnLabel.text = [dateFormatter stringFromDate:stop.returnTime];
        //stopDeprLabel.text = @"11:25";
        //stopRetnLabel.text = @"16:00";
        
        [container addSubview:stopNameLabel];
        [container addSubview:stopDeprLabel];
        //[container addSubview:stopRetnLabel];
        
        [main addSubview:container];
        x += 110.0;
    }
    
    return main;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [self.busLines busListAtIndex:section].name;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
