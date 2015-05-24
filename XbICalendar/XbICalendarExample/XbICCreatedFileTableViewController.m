//
//  XbICCreatedFileTableViewController.m
//  XbICalendar
//
//  Created by Han Chengge on 5/22/15.
//  Copyright (c) 2015 GaltSoft. All rights reserved.
//

#import "XbICCreatedFileTableViewController.h"
#import "XbICAddViewController.h"

@interface XbICCreatedFileTableViewController ()

@property (nonatomic, strong) NSArray * files;
@property (nonatomic, strong) NSString * selectedFile;

@end

@implementation XbICCreatedFileTableViewController

static NSString * kCellReuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *directroyContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.ics'"];
    self.files = [directroyContent filteredArrayUsingPredicate:fltr];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.files[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedFile = self.files[indexPath.row];
    
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        XbICAddViewController * viewController = segue.destinationViewController;
        viewController.fileName = self.selectedFile;
    }
}

@end
