//
//  NSString+Additions.m
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

-(int)occurencesOfSubstring:(NSString *)substr 
{
	//consider that for this, it may be(though I'm not sure) faster to use the less-robust outlined below.
	return [self occurencesOfSubstring:substr options:NSCaseInsensitiveSearch];
}

-(int)occurencesOfSubstring:(NSString *)substr options:(int)opt 
{
	/* if one wanted to make a much shorter(is it faster?), but rather less robust implementation, one would do:
	 return [[self componentsSeparatedByString:substr] count] - 1; */
	int slen = [self length];
	int position = 0;
	NSRange currentRange;
	BOOL flag = YES;
	int count = 0;
	do 
	{
		currentRange = [self rangeOfString:substr
								   options:opt
									 range:NSMakeRange(position, slen-position)];
		
		if (currentRange.location == NSNotFound) 
		{
			flag = NO;
		} 
		else 
		{
			count++;
			position = currentRange.location + currentRange.length;
		}
	} 
	while (flag == YES);
	
	return count;
}

- (NSArray *)tokensSeparatedByCharactersFromSet:(NSCharacterSet *)separatorSet
{
	NSScanner      *scanner      = [NSScanner scannerWithString:self];
	NSCharacterSet *tokenSet     = [separatorSet invertedSet];
	NSMutableArray *tokens       = [NSMutableArray array];
	
	[scanner setCharactersToBeSkipped:separatorSet];
	
	while (![scanner isAtEnd])
	{
		NSString  *destination = [NSString string];
		
		if ([scanner scanCharactersFromSet:tokenSet intoString:&destination])
		{
			[tokens addObject:[NSString stringWithString:destination]];
		}
	}
	
	return [NSArray arrayWithArray:tokens];
}

- (NSArray *)objCTokens
{
	NSMutableCharacterSet *tokensSet = [NSMutableCharacterSet alphanumericCharacterSet];
	[tokensSet addCharactersInString:@"_:"];
	return [self tokensSeparatedByCharactersFromSet:[tokensSet invertedSet]];
}

- (NSArray *)words
{
	NSMutableCharacterSet *tokenSet = [NSMutableCharacterSet letterCharacterSet];
	[tokenSet addCharactersInString:@"-"];
	return [self tokensSeparatedByCharactersFromSet:[tokenSet invertedSet]];
}

// Useful for checking for illegal characters.
- (BOOL) containsCharacterFromSet:(NSCharacterSet *)set
{
	return ([self rangeOfCharacterFromSet:set].location != NSNotFound);
}

// Useful for replacing illegal characters with "?" or something.
- (NSString *)stringWithSubstitute:(NSString *)subs forCharactersFromSet:(NSCharacterSet *)set
{
	NSRange r = [self rangeOfCharacterFromSet:set];
	if (r.location == NSNotFound) return self;
	NSMutableString *newString = [self mutableCopy];
	do
	{
		[newString replaceCharactersInRange:r withString:subs];
		r = [newString rangeOfCharacterFromSet:set];
	}
	while (r.location != NSNotFound);
	return newString;
}

-(NSArray *)linesSortedByLength
{
	return [[self componentsSeparatedByString:@"\n"] sortedArrayUsingSelector:@selector(compareLength:)];
}

-(NSComparisonResult)compareLength:(NSString *)otherString
{
	if([self length] < [otherString length])      { return NSOrderedAscending; }
	else if([self length] > [otherString length]) { return NSOrderedDescending; }
	//if same length, use alphabetical ordering.
	else                                          { return [self compare:otherString]; } 
}

- (BOOL)smartWriteToFile:(NSString *)path atomically:(BOOL)atomically
{
	if([self isEqualToString:[NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:NULL]]) 
	{ 
		return YES; 
	}
	return [self writeToFile:path atomically:atomically encoding:NSASCIIStringEncoding error:NULL];
}

- (unsigned)lineCount
{
    unsigned count = 0;
    unsigned location = 0;
	
    while (location < [self length])
    {
        // get next line start and set current location to it
        [self getLineStart:nil end:&location contentsEnd:nil forRange:NSMakeRange(location,1)];
        count += 1;
    }
	
    return count;
}

- (BOOL)containsString:(NSString *)aString
{
    return [self containsString:aString ignoringCase:NO];
}

- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag
{
    unsigned mask = (flag ? NSCaseInsensitiveSearch : 0);
    NSRange range = [self rangeOfString:aString options:mask];
    return (range.length > 0);
}

-(NSArray *) splitToSize:(unsigned)size
{
    NSMutableArray *splitStrings = [NSMutableArray array];
	
    int count = 0;
    int i = 0;
    unsigned loc = 0;
    NSString *tempString;
	
    count = [self length] / size;
	
	
    for (i = 0; i < count; i++)
	{
        loc = size * i;
		
        tempString = [self substringWithRange:NSMakeRange(loc,size)];
        [splitStrings addObject: tempString];
        //[splitStrings addObject: [tempString copy]];
	}
	
    loc = size * count;
	
    tempString = [self substringFromIndex:loc];
	
    [splitStrings addObject: tempString];
    //[splitStrings addObject: [tempString copy]];
	
    return splitStrings;
}

-(NSString *)removeTabsAndReturns
{
    NSMutableString *outputString = [NSMutableString string];
    NSCharacterSet *charSet;
    NSString *temp;
	
    NSScanner *scanner = [NSScanner scannerWithString:self];
	
    charSet = [NSCharacterSet characterSetWithCharactersInString:@"\n\r\t"];
	
    while ([scanner scanUpToCharactersFromSet:charSet intoString:&temp])
	{
		[outputString appendString:temp];
		
	}
    return [outputString copy];
}

-(NSString*)newlineToCR
{
    NSMutableString *str = [NSMutableString string];
    [str setString: self];
	
    [str replaceOccurrencesOfString:@"\n" withString:@"\r" 
							options:NSLiteralSearch 
							  range:NSMakeRange (0, [str length])];
    return [str copy];
}

-(NSString *)safeFilePath
{
	int numberWithName = 1;
	BOOL isDir;
	NSString *safePath = [[NSString alloc] initWithString:self];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:safePath isDirectory:&isDir])
	{
		while ([[NSFileManager defaultManager] fileExistsAtPath:safePath isDirectory:&isDir])
		{
			safePath = [[NSString alloc] initWithFormat:@"%@ %d.%@", [self stringByDeletingPathExtension],numberWithName,[self pathExtension]];
			
			numberWithName++;
		}
	}
	
	return safePath;
}

-(NSRange)whitespaceRangeForRange:(NSRange)characterRange
{
    NSString *string = [self copy];
    NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    unsigned int areamax = NSMaxRange(characterRange);
    unsigned int length = [string length];
    
    NSRange start = [string rangeOfCharacterFromSet:whitespaceSet
											options:NSBackwardsSearch
											  range:NSMakeRange(0, characterRange.location)];
    
    if (start.location == NSNotFound)
    {
        start.location = 0;
    }  
    else 
    {
        start.location = NSMaxRange(start);
    }
    
    NSRange end = [string rangeOfCharacterFromSet:whitespaceSet
										  options:0
											range:NSMakeRange(areamax, length - areamax)];
    
    if (end.location == NSNotFound)
        end.location = length;
    
    NSRange searchRange = NSMakeRange(start.location, end.location - start.location); 
    //last whitespace to next whitespace
    return searchRange;
}

-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to
{
	NSString *rightPart = [self substringFromIndex:from];
	return [rightPart substringToIndex:to-from];
}
// Useful for parsing strings, in conjunction with rangeOf... methods.
- (NSString *)substringBeforeRange:(NSRange)range
{
	return [self substringToIndex:range.location];
}

- (NSString *)substringAfterRange:(NSRange)range
{
	return [self substringFromIndex:NSMaxRange (range)];
}



@end
