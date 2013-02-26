//
//  PasteboardTableViewController.m
//  OpenUDIDViewer
//
//  Created by David Haynes on 26/02/2013.
//  Copyright (c) 2013 Machindo Apps. All rights reserved.
//

#import "PasteboardTableViewController.h"
#import <UIKit/UIPasteboard.h>

static NSString * const kOpenUDIDDescription = @"OpenUDID_with_iOS6_Support";
static NSString * const kOpenUDIDKey = @"OpenUDID";
static NSString * const kOpenUDIDSlotKey = @"OpenUDID_slot";
static NSString * const kOpenUDIDAppUIDKey = @"OpenUDID_appUID";
static NSString * const kOpenUDIDBundleIDKey = @"OpenUDID_bundleid";
static NSString * const kOpenUDIDTSKey = @"OpenUDID_createdTS";
static NSString * const kOpenUDIDOOTSKey = @"OpenUDID_optOutTS";
static NSString * const kOpenUDIDDomain = @"org.OpenUDID";
static NSString * const kOpenUDIDSlotPBPrefix = @"org.OpenUDID.slot.";
static int const kOpenUDIDRedundancySlots = 100;

#define OpenUDIDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@interface PasteboardTableViewController ()

@end

@implementation PasteboardTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kOpenUDIDRedundancySlots;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OpenUDIDCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the pastboard dict for each item
	NSString* slotPBid = [NSString stringWithFormat:@"%@%d",kOpenUDIDSlotPBPrefix,[indexPath row]];
	UIPasteboard* slotPB = [UIPasteboard pasteboardWithName:slotPBid create:NO];
	NSDictionary* dict = [self getDictFromPasteboard:slotPB];
	
	NSString *oudid = [dict objectForKey:kOpenUDIDKey];
	NSString *appUID = [dict objectForKey:kOpenUDIDAppUIDKey];
	NSDate *timeStamp = [dict objectForKey:kOpenUDIDTSKey];
	NSDate *optOutTimeStamp = [dict objectForKey:kOpenUDIDOOTSKey];
	NSString *bundleID = [dict objectForKey:kOpenUDIDBundleIDKey];

	UILabel *slotPBidLabel = (UILabel *)[cell viewWithTag:1];
	slotPBidLabel.text = slotPBid;
	UILabel *oudidLabel = (UILabel *)[cell viewWithTag:2];
	oudidLabel.text = oudid;
	UILabel *appUIDLabel = (UILabel *)[cell viewWithTag:3];
	appUIDLabel.text = appUID;
	UILabel *timeStampLabel = (UILabel *)[cell viewWithTag:4];
	timeStampLabel.text = [timeStamp description];
	UILabel *optOutTSLabel = (UILabel *)[cell viewWithTag:5];
	optOutTSLabel.text = [optOutTimeStamp description];
	UILabel *bundleLabel = (UILabel *)[cell viewWithTag:6];
	bundleLabel.text = bundleID;
 
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - OpenUDID helper methods

// Output contents of OpenUDID Pasteboards to console
-(void)printOpenUDIDPasteboards {
	for (int n=0; n<kOpenUDIDRedundancySlots; n++) {
        NSString* slotPBid = [NSString stringWithFormat:@"%@%d",kOpenUDIDSlotPBPrefix,n];
        UIPasteboard* slotPB = [UIPasteboard pasteboardWithName:slotPBid create:NO];
        OpenUDIDLog(@"SlotPB name = %@",slotPBid);
		
		NSDictionary* dict = [self getDictFromPasteboard:slotPB];
		NSString* oudid = [dict objectForKey:kOpenUDIDKey];
		OpenUDIDLog(@"SlotPB dict = %@",dict);
		OpenUDIDLog(@"oudid = %@",oudid);
		oudid = nil;
		dict = nil;
    }
}

// Retrieve an NSDictionary from a pasteboard of a given type
- (NSMutableDictionary*) getDictFromPasteboard:(id)pboard {
    id item = [pboard dataForPasteboardType:kOpenUDIDDomain];
	
    if (item) {
        @try{
            item = [NSKeyedUnarchiver unarchiveObjectWithData:item];
        } @catch(NSException* e) {
            OpenUDIDLog(@"Unable to unarchive item %@ on pasteboard!", [pboard name]);
            item = nil;
        }
    }
    
    // return an instance of a MutableDictionary
    return [NSMutableDictionary dictionaryWithDictionary:(item == nil || [item isKindOfClass:[NSDictionary class]]) ? item : nil];
}


@end
