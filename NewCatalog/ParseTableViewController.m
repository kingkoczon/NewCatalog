//
//  ParseTableViewController.m
//  NewCatalog
//
//  Created by Bobby Koczon on 1/8/13.
//  Copyright (c) 2013 Bobby Koczon. All rights reserved.
//

#import "ParseTableViewController.h"

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "Results.h"

@interface ParseTableViewController () {
    NSMutableArray *_objects;
}

@end

@implementation ParseTableViewController

@synthesize detailsViewController = _detailsViewController;


-(NSString *)fkStringByEscapingURIComponent:(NSString *)stringWithSpecialChaarcters {
	return [(__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
																				  (__bridge CFStringRef)stringWithSpecialChaarcters,
																				  NULL,
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8)
			stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

-(NSString *)fkStringByUnescapingURIComponent:(NSString *)stringWithPercentEscapes {
	return [[stringWithPercentEscapes stringByReplacingOccurrencesOfString:@"+" withString:@" "]
			stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(void)loadResults:(NSString *)title {
    
    NSString *urlString = [@"http://ecatalog.coronado.lib.ca.us/search~S0/?searchtype=t&searcharg=" stringByAppendingString:[self fkStringByEscapingURIComponent:title]];
    
    NSURL *resultsUrl = [NSURL URLWithString:urlString];
    
    NSData *resultsHtmlData = [NSData dataWithContentsOfURL:resultsUrl];
    
    TFHpple *resultsParser = [TFHpple hppleWithHTMLData:resultsHtmlData];
    
    NSString *resultsXpathQueryString = @"//td[@class='browseEntryData']/a[2]";
    NSArray *resultsNodes = [resultsParser searchWithXPathQuery:resultsXpathQueryString];
    
    NSMutableArray *newResults = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in resultsNodes) {
        
        Results *result = [[Results alloc] init];
        [newResults addObject:result];
        
        result.title = [[element firstChild] content];
        
        result.url = [element objectForKey:@"href"];
    }
    
    _objects = newResults;
    [self.tableView reloadData];
}

- (void)loadResults {
    
    NSURL *resultsUrl = [NSURL URLWithString:@"http://ecatalog.coronado.lib.ca.us/search~S0/?searchtype=t&searcharg=finding+nemo&sortdropdown=-&SORT=D&extended=0&SUBMIT=Search&searchlimits=&searchorigarg=tfinding+nemo"];
    NSData *resultsHtmlData = [NSData dataWithContentsOfURL:resultsUrl];
    
    TFHpple *resultsParser = [TFHpple hppleWithHTMLData:resultsHtmlData];
    
    NSString *resultsXpathQueryString = @"//td[@class='browseEntryData']/a[2]";
    NSArray *resultsNodes = [resultsParser searchWithXPathQuery:resultsXpathQueryString];
    
    NSMutableArray *newResults = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in resultsNodes) {
        
        Results *result = [[Results alloc] init];
        [newResults addObject:result];
        
        result.title = [[element firstChild] content];
        
        result.url = [element objectForKey:@"href"];
    }
    
    _objects = newResults;
    [self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadResults];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    Results *thisResult = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = thisResult.title;
    cell.detailTextLabel.text = thisResult.url;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showDetail"])
	{
		//DetailViewController *dvc = segue.destinationViewController;
		//dvc.delegate = self;
	}
}


@end
