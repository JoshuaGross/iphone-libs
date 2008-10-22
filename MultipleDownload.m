//
//  MultipleDownload.m
//
//  Created by Leon Ho on 14/10/2008.
//  Copyright 2008 Stepcase Limited.
//

#import "MultipleDownload.h"


@implementation MultipleDownload

@synthesize urls, requests, receivedDatas;

- init {
    if ((self = [super init])) {
		self.urls = [[NSMutableArray alloc] init];
		self.requests = [[NSMutableDictionary alloc] init];
		self.receivedDatas = [[NSMutableArray alloc] init];
		finishCount = 0;
    }
    return self;
}

- (void)dealloc {
	[urls release];
	[requests release];
	[receivedDatas release];
    [super dealloc];
}

- (void)setDelegate:(id)val
{
    delegate = val;
}

- (id)delegate
{
    return delegate;
}


#pragma mark Methods
- (void)initFromUrls:(NSArray *)aUrls {
	[urls addObjectsFromArray:aUrls];
	
	for(NSInteger i=0; i< [urls count]; i++){
		NSMutableData *aData = [[NSMutableData alloc] init];
		[receivedDatas addObject: aData];
		[aData release];
		
		NSURLRequest *request = [[NSURLRequest alloc] 
								 initWithURL: [NSURL URLWithString: [[urls objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding: 4]]
								 ];
		NSURLConnection *connection = [[NSURLConnection alloc]
									   initWithRequest:request
									   delegate:self];
		
		[requests setObject: [NSNumber numberWithInt: i] forKey: [NSValue valueWithNonretainedObject:connection]];
		[connection release];
		[request release];	
	}
	
}

- (NSData *)dataAtIndex:(NSInteger)idx {
	return [receivedDatas objectAtIndex:idx];
}

- (NSString *)dataAsStringAtIndex:(NSInteger)idx {
	return [[[NSString alloc] initWithData:[receivedDatas objectAtIndex:idx] encoding:NSUTF8StringEncoding] autorelease];
}


#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSInteger i = [[requests objectForKey: [NSValue valueWithNonretainedObject:connection]] intValue];
    [[receivedDatas objectAtIndex:i] setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSInteger i = [[requests objectForKey: [NSValue valueWithNonretainedObject:connection]] intValue];
    [[receivedDatas objectAtIndex:i] appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSInteger i = [[requests objectForKey: [NSValue valueWithNonretainedObject:connection]] intValue];
	finishCount++;
	
	if(delegate == nil) return;
	
	if ([delegate respondsToSelector:@selector(didFinishDownload:)])
        [delegate performSelector:@selector(didFinishDownload:) withObject: [NSNumber numberWithInt: i]];
    else
    { 
        [NSException raise:NSInternalInconsistencyException
					format:@"Delegate doesn't respond to didFinishDownload"];
    }

	if(finishCount >= [urls count]){
		if ([delegate respondsToSelector:@selector(didFinishAllDownload)])
			[delegate didFinishAllDownload];
		else	
		{ 
			[NSException raise:NSInternalInconsistencyException
						format:@"Delegate doesn't respond to didFinishAllDownload"];
		}
	}
}


@end