//
// REPhotoCollectionController.m
// REPhotoCollectionController
//
// Copyright (c) 2012 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REPhotoCollectionController.h"
#import "REPhotoThumbnailsCell.h"

@interface REPhotoCollectionController ()

@end

@implementation REPhotoCollectionController

@synthesize datasource = _datasource;
@synthesize groupByDate = _groupByDate;
@synthesize thumbnailViewClass = _thumbnailViewClass;

-(void)viewDidLoad {
    [super viewDidLoad];
    self.datasource = [NSMutableArray arrayWithArray:[self prepareDatasource]];
    self.title = @"Photos.";
    self.thumbnailViewClass = [ThumbnailView class];
}

- (NSMutableArray *)prepareDatasource
{
    NSMutableArray *datasource = [[NSMutableArray alloc] init];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage6.s3.amazonaws.com/5acf0f48d5ac11e1a3461231381315e1_5.jpg"
                                               date:[self dateFromString:@"05/01/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage0.s3.amazonaws.com/622c57d4ced411e1ae7122000a1e86bb_5.jpg"
                                               date:[self dateFromString:@"05/02/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage7.s3.amazonaws.com/1a8f3db4b87811e1ab011231381052c0_5.jpg"
                                               date:[self dateFromString:@"05/03/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage6.s3.amazonaws.com/c0039594b74011e181bd12313817987b_5.jpg"
                                               date:[self dateFromString:@"05/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage10.s3.amazonaws.com/b9e61198b69411e180d51231380fcd7e_5.jpg"
                                               date:[self dateFromString:@"05/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage3.s3.amazonaws.com/334b13f4b5ae11e1abd612313810100a_5.jpg"
                                               date:[self dateFromString:@"05/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage2.s3.amazonaws.com/9ab3ff16b59911e1b00112313800c5e4_5.jpg"
                                               date:[self dateFromString:@"05/26/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage10.s3.amazonaws.com/e02206c8b59511e1be6a12313820455d_5.jpg"
                                               date:[self dateFromString:@"06/25/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage9.s3.amazonaws.com/3b9c9182b53a11e1be6a12313820455d_5.jpg"
                                               date:[self dateFromString:@"06/23/2012"]]];
    [datasource addObject:[Photo photoWithURLString:@"http://distilleryimage6.s3.amazonaws.com/93f1fab2b4b711e192e91231381b3d7a_5.jpg"
                                               date:[self dateFromString:@"07/25/2012"]]];
    return datasource;
}

- (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    return [dateFormat dateFromString:string];
}

- (void)reloadData
{
    if (!_groupByDate) {
        REPhotoGroup *group = [[REPhotoGroup alloc] init];
        group.month = 1;
        group.year = 1900;
        [_ds removeAllObjects];
        for (NSObject *object in _datasource) {
            [group.items addObject:object];
        }
        [_ds addObject:group];
        return;
    }
    NSArray *sorted = [_datasource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSObject <REPhotoObjectProtocol> *photo1 = obj1;
        NSObject <REPhotoObjectProtocol> *photo2 = obj2;
        return ![photo1.date compare:photo2.date];
    }];
    [_ds removeAllObjects];
    for (NSObject *object in sorted) {
        NSObject <REPhotoObjectProtocol> *photo = (NSObject <REPhotoObjectProtocol> *)object;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |
                                        NSMonthCalendarUnit | NSYearCalendarUnit fromDate:photo.date];
        NSUInteger month = [components month];
        NSUInteger year = [components year];
        REPhotoGroup *group = ^REPhotoGroup *{
            for (REPhotoGroup *group in _ds) {
                if (group.month == month && group.year == year)
                    return group;
            }
            return nil;
        }();
        if (group == nil) {
            group = [[REPhotoGroup alloc] init];
            group.month = month;
            group.year = year;
            [group.items addObject:photo];
            [_ds addObject:group];
        } else {
            [group.items addObject:photo];
        }
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewController functions

- (void)setDatasource:(NSMutableArray *)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _ds = [[NSMutableArray alloc] init];
        self.groupByDate = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (id)initWithDatasource:(NSArray *)datasource
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.datasource = [NSMutableArray arrayWithArray:datasource];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_ds count] == 0) return 0;
    if (!_groupByDate) return 1;
    
    if ([self tableView:self.tableView numberOfRowsInSection:[_ds count] - 1] == 0) {
        return [_ds count] - 1;
    }
    return [_ds count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:section];
    return ceil([group.items count] / 4.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"REPhotoThumbnailsCell";
    REPhotoThumbnailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[REPhotoThumbnailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier thumbnailViewClass:_thumbnailViewClass];
    }
    
    REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:indexPath.section];
    
    int startIndex = indexPath.row * 4;
    int endIndex = startIndex + 4;
    if (endIndex > [group.items count])
        endIndex = [group.items count];
    
    [cell removeAllPhotos];
    for (int i = startIndex; i < endIndex; i++) {
        NSObject <REPhotoObjectProtocol> *photo = [group.items objectAtIndex:i];
        [cell addPhoto:photo];
    }
    [cell refresh];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return !_groupByDate ? 0 : 22;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i-%i-1", group.year, group.month]];
    
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    NSString *resultString = [dateFormatter stringFromDate:date];
    return resultString;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    return view;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
