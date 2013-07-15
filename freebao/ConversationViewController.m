//
//  ConversationViewController.m
//  freebao
//
//  Created by freebao on 13-7-5.
//  Copyright (c) 2013年 WeiQun. All rights reserved.
//

#import "ConversationViewController.h"

#define HIDE_TABBAR @"10000"
#define SHOW_TABBAR @"10001"
#define RECEIVE_REFRESH_VIEW @"fb_receive_msg"

#define  SHOW_LANGUAGE_MENU @"fb_language_menu"

#import "AppDelegate.h"

#define KAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

@interface ConversationViewController ()

@end

@implementation ConversationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    tittleView.hidden = NO;
    tittleLineView.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_TABBAR object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpRefreshView];
    self.tableView.contentInset = UIEdgeInsetsOriginal;
    refreshFooterView.hidden = YES;
    
    tittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [tittleView setBackgroundColor:[UIColor colorWithRed:35/255.0 green:166/255.0 blue:210/255.0 alpha:0.9]];
    tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    tittleLabel.textAlignment = UITextAlignmentCenter;
    [tittleLabel setBackgroundColor:[UIColor clearColor]];
    tittleLabel.text = @"Chats";
    tittleLabel.textColor = [UIColor whiteColor];
    [tittleView addSubview: tittleLabel];
    tittleLabel.center = CGPointMake(160, 22);
    tittleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 0.5)];
    [tittleLineView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:77/255.0 blue:105/255.0 alpha:0.7]];
    [self.navigationController.view addSubview:tittleView];
    [self.navigationController.view addSubview:tittleLineView];

    headPhotos = [[NSMutableArray alloc] initWithObjects:
                  @"",
                  @"http://farm4.static.flickr.com/3483/4017988903_84858e0e6e_s.jpg",
                  @"http://farm3.static.flickr.com/2436/4015786038_7b530f9cce_s.jpg",
                  @"http://farm3.static.flickr.com/2643/4025878602_85f7cd1724_s.jpg",
                  @"http://farm3.static.flickr.com/2494/4011329502_09e6d03b4d_s.jpg",
                  @"http://farm4.static.flickr.com/3103/4027083130_b187516f48_s.jpg",
                  @"http://farm3.static.flickr.com/2557/4007449481_59d7a8d848_s.jpg",
                  @"http://farm4.static.flickr.com/3479/4021202695_381ff2e9bc_s.jpg",
                  @"http://farm3.static.flickr.com/2598/4010566163_1426fa3389_s.jpg",
                  @"http://farm3.static.flickr.com/2589/4015601052_ba81c7544b_s.jpg",
                  @"http://farm3.static.flickr.com/2551/4025950491_20a7615b69_s.jpg",
                  @"http://farm3.static.flickr.com/2534/4009711388_66ae983c7e_s.jpg",
                  @"http://farm3.static.flickr.com/2469/4008746903_e90b09241d_s.jpg",
                  @"http://farm3.static.flickr.com/2432/4025384253_0e521644dd_s.jpg",
                  @"http://farm3.static.flickr.com/2585/4023151655_d63ecd4025_s.jpg",
                  @"http://farm3.static.flickr.com/2421/4019640142_7ee56e4b1c_s.jpg",
                  @"http://farm4.static.flickr.com/3511/4016743839_69370584f3_s.jpg",
                  @"http://farm3.static.flickr.com/2547/4016748951_f52700aeaa_s.jpg",
                  @"http://farm4.static.flickr.com/3639/4014434499_b832e04061_s.jpg",
                  @"http://farm3.static.flickr.com/2190/4018090737_846760e3da_s.jpg",
                  @"http://farm4.static.flickr.com/3524/4018550718_c4f43a83d0_s.jpg",
                  @"http://farm4.static.flickr.com/3511/4008358164_a5def010c7_s.jpg",
                  @"http://farm3.static.flickr.com/2792/4023230831_34b3dfc1ea_s.jpg",
                  @"http://farm3.static.flickr.com/2438/4021904945_c3706a652a_s.jpg",
                  @"http://farm3.static.flickr.com/2655/4012063376_5e120a4428_s.jpg",
                  @"http://farm3.static.flickr.com/2637/4009152189_9fd9034b60_s.jpg",
                  @"http://farm3.static.flickr.com/2673/4017117612_ae364923b0_s.jpg",
                  @"http://farm3.static.flickr.com/2495/4020233997_453672b620_s.jpg",
                  @"http://farm3.static.flickr.com/2586/4014510731_47e9a9b73d_s.jpg",
                  @"http://farm3.static.flickr.com/2739/4025489621_65264987f8_s.jpg",
                  @"http://farm3.static.flickr.com/2577/4016420951_def68019dd_s.jpg",
                  @"http://farm3.static.flickr.com/2500/4026353518_15268c4488_s.jpg",
                  @"http://farm3.static.flickr.com/2453/4008435378_8e16c06970_s.jpg",
                  @"http://farm3.static.flickr.com/2745/4026003536_31da429e13_s.jpg",
                  @"http://farm3.static.flickr.com/2674/4019640830_31e067d771_s.jpg",
                  @"http://farm3.static.flickr.com/2671/4017291336_b39b72224c_s.jpg",
                  @"http://farm3.static.flickr.com/2665/4015357692_6d31ab729b_s.jpg",
                  @"http://farm3.static.flickr.com/2475/4009936307_9a6039aec7_s.jpg",
                  @"http://farm3.static.flickr.com/2436/4019681008_a5da6093d0_s.jpg",
                  @"http://farm3.static.flickr.com/2475/4012817856_0e97e6718b_s.jpg",
                  @"http://farm3.static.flickr.com/2458/4011407242_0073aa2d22_s.jpg",
                  @"http://farm4.static.flickr.com/3509/4017070907_cea45a8d3a_s.jpg",
                  @"http://farm4.static.flickr.com/3488/4020067072_7c60a7a60a_s.jpg",
                  @"http://farm4.static.flickr.com/3503/4011136126_80c3b02986_s.jpg",
                  @"http://farm3.static.flickr.com/2751/4021887851_c5626ff59a_s.jpg",
                  @"http://farm3.static.flickr.com/2700/4020348292_856262abc7_s.jpg",
                  @"http://farm3.static.flickr.com/2620/4010967777_005fdd1867_s.jpg",
                  @"http://farm4.static.flickr.com/3517/4011690509_4ce02b32cf_s.jpg",
                  @"http://farm3.static.flickr.com/2454/4012955142_7177f21bf4_s.jpg",
                  @"http://farm3.static.flickr.com/2538/4014440923_a2b9824628_s.jpg",
                  @"http://farm3.static.flickr.com/2635/4010051525_74df73bbd7_s.jpg",
                  @"http://farm3.static.flickr.com/2752/4020781123_baaa208689_s.jpg",
                  @"http://farm3.static.flickr.com/2622/4014471899_05043a20e3_s.jpg",
                  @"http://farm3.static.flickr.com/2780/4022823482_26e5530c84_s.jpg",
                  @"http://farm4.static.flickr.com/3515/4016721686_c828925456_s.jpg",
                  @"http://farm3.static.flickr.com/2575/4022946879_977e8df918_s.jpg",
                  @"http://farm3.static.flickr.com/2648/4018130671_8390158767_s.jpg",
                  @"http://farm3.static.flickr.com/2493/4022863018_6197f81c8d_s.jpg",
                  @"http://farm4.static.flickr.com/3216/4018267822_e90308c44c_s.jpg",
                  @"http://farm3.static.flickr.com/2530/4009339944_4d9eb769fc_s.jpg",
                  @"http://farm3.static.flickr.com/2577/4026000780_e615efd67c_s.jpg",
                  @"http://farm4.static.flickr.com/3499/4018569395_a4483387b0_s.jpg",
                  @"http://farm4.static.flickr.com/3509/4019095546_c0f110bc1c_s.jpg",
                  @"http://farm3.static.flickr.com/2579/4022669316_42065ea829_s.jpg",
                  @"http://farm3.static.flickr.com/2560/4009382268_7d8812fe98_s.jpg",
                  @"http://farm3.static.flickr.com/2645/4025740346_03e948466f_s.jpg",
                  @"http://farm3.static.flickr.com/2800/4021259282_122075711c_s.jpg",
                  @"http://farm3.static.flickr.com/2430/4019625100_b23147c748_s.jpg",
                  @"http://farm3.static.flickr.com/2527/4026734100_e52fc21603_s.jpg",
                  @"http://farm3.static.flickr.com/2635/4020892994_e6101d0f0e_s.jpg",
                  @"http://farm3.static.flickr.com/2672/4008379269_157e86729e_s.jpg",
                  @"http://farm3.static.flickr.com/2620/4009289798_bdcf26500a_s.jpg",
                  @"http://farm3.static.flickr.com/2455/4024701539_9ee5b7fac6_s.jpg",
                  @"http://farm3.static.flickr.com/2588/4010668107_97207ceb22_s.jpg",
                  @"http://farm3.static.flickr.com/2459/4023575284_cd01deba10_s.jpg",
                  @"http://farm3.static.flickr.com/2613/4019518861_5fbd679d61_s.jpg",
                  @"http://farm3.static.flickr.com/2429/4027017756_f9e6102700_s.jpg",
                  @"http://farm3.static.flickr.com/2487/4020209639_81a3a2bbc2_s.jpg",
                  @"http://farm3.static.flickr.com/2670/4013657757_12c694c4ee_s.jpg",
                  @"http://farm3.static.flickr.com/2804/4019095448_049ef023e3_s.jpg",
                  @"http://farm3.static.flickr.com/2197/4011866354_0948246520_s.jpg",
                  @"http://farm3.static.flickr.com/2557/4010652749_1d0c35fabd_s.jpg",
                  @"http://farm3.static.flickr.com/2543/4010847393_9844b1a37f_s.jpg",
                  @"http://farm3.static.flickr.com/2724/4021388365_7c739b9b16_s.jpg",
                  @"http://farm4.static.flickr.com/3484/4018164769_2e68f895dc_s.jpg",
                  @"http://farm3.static.flickr.com/2643/4020492457_84c4140077_s.jpg",
                  @"http://farm3.static.flickr.com/2670/4011966914_e1849fda91_s.jpg",
                  @"http://farm3.static.flickr.com/2653/4015298872_d4ef36c14a_s.jpg",
                  @"http://farm3.static.flickr.com/2710/4024844149_40dca40cd2_s.jpg",
                  @"http://farm3.static.flickr.com/2546/4012296861_146d4805df_s.jpg", nil];
}

//- (void)backButtonAction {
//    NSLog(@"[levi]back...");
//    backButton.hidden = YES;
//    languageButton.hidden = YES;
//    tittleLabel.text = @"Chats";
//    [[NSNotificationCenter defaultCenter] removeObserver:KAppDelegate.commChat.self name:RECEIVE_REFRESH_VIEW object:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//}

//- (void)languageMenuAction {
//    NSLog(@"[levi]");
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_LANGUAGE_MENU object:nil];
//}

-(void)setUpRefreshView
{
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [headPhotos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    }
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"BlankCell";
        BlankCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BlankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
    
    static NSString *CellIdentifier = @"ConversationCell";
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setHeadPhoto:[headPhotos objectAtIndex:indexPath.row]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        if (KAppDelegate.commChat == nil) {
            KAppDelegate.commChat = [[ChatViewController alloc] init];
        } else {
            KAppDelegate.commChat.isFirst = FALSE;
            KAppDelegate.commChat.isReload = TRUE;
        }
        tittleView.hidden = YES;
        tittleLineView.hidden = YES;
//        if (commentVC == nil) {
//            commentVC = [[CommentsViewController alloc] init];
//        }
//        tittleLabel.text = @"Test";
//        backButton.hidden = NO;
//        languageButton.hidden = NO;
        [self.navigationController pushViewController:KAppDelegate.commChat animated:YES];
    }
}

#pragma mark -
#pragma mark  - Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
}

//调用此方法来停止。
- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	refreshFooterView.hidden = NO;
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 200) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    else
        [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self refreshVisibleCellsImages];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //    [self refreshVisibleCellsImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate)
	{
//        [self refreshVisibleCellsImages];
    }
    
    if (scrollView.contentOffset.y < 200)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:5];
}

- (void)stopRefresh {
    [self doneLoadingTableViewData];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    _reloading = YES;
    NSLog(@"[levi] is loading data.......");
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
