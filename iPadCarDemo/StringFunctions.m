//
//  StringFunctions.m
//
//  Created by John Basile on 10/29/11.
//  Copyright (c) 2011 Numerics. All rights reserved.
//

#import "StringFunctions.h"

#import "DateUtil.h"
//#import "HtmlUtil.h"

@implementation StringFunctions

static NSMutableCharacterSet* BAD_CHARACTER_SET;

//
// Class initializer. Called only once before the class receives its first message.
//
+ (void) initialize
{
	BAD_CHARACTER_SET = [[NSMutableCharacterSet alloc] init];
	[BAD_CHARACTER_SET formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
	[BAD_CHARACTER_SET formUnionWithCharacterSet:[NSCharacterSet controlCharacterSet]];
	[BAD_CHARACTER_SET formUnionWithCharacterSet:[NSCharacterSet illegalCharacterSet]];
	[BAD_CHARACTER_SET removeCharactersInString:@"\n "];
}

//
// Tests if the given input is an empty string and, if so, returns defaultStr,
// otherwise param input is returned unchanged.
//
+ (NSString*) emptyStringDefault:(NSString*)input defaultStr:(NSString*)defaultStr
{
	return ([StringFunctions isEmptyString:input] ? defaultStr : input);
}

//
// Returns true if the given string is empty after trimming.
//
+(BOOL)isEmptyStringTrimmed:(NSString *)str
{
	return (str == nil || [[StringFunctions trim:str] length] == 0);
}

//
// Returns true if the given string is nil or empty.
//
+ (BOOL) isEmptyString:(NSString *)str
{
	if (str == nil)
	{
		return YES;
	}
	else if ([str length] <= 0)
	{
		return YES;
	}
	
	return NO;
}

//
// Returns a new string with whitespace character set trimmed from both ends.
//
+(NSString *)trim:(NSString *)str
{
	if (str != nil)
	{
		return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	// Return an empty string.	
	return [NSString string];
}


//
// Returns true if the two strings are equal ignoring case and after trimming.
//
+(BOOL)equalsIgnoreCaseTrim:(NSString *)str1 str2:(NSString *)str2
{
	if (str1 != nil && str2 != nil)
	{
		//str1 = [str1 copy];
		//str2 = [str2 copy];
		NSString *trimmed1 = nil;
		NSString *trimmed2 = nil;
		@try
		{
			// Trim both strings.
			NSCharacterSet *whitespaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
			// Note, the strings returned by stringByTrimmingCharactersInSet appear to be autoreleased! 
			trimmed1 = [str1 stringByTrimmingCharactersInSet:whitespaceCharacterSet];
			trimmed2 = [str2 stringByTrimmingCharactersInSet:whitespaceCharacterSet];
			
			NSComparisonResult result = [trimmed1 localizedCaseInsensitiveCompare:trimmed2];
			
			return (result == NSOrderedSame);
		}
		@finally
		{
			//[str1 release];
			//[str2 release];
			//[trimmed1 release];
			//[trimmed2 release];
		}
	}
	
	return FALSE;
}

//
// Returns true if the two strings are equal ignoring case.
//
+ (BOOL) equalsIgnoreCase:(NSString *)str1 str2:(NSString *)str2
{
	if (str1 != nil && str2 != nil)
	{
		return ([str1 localizedCaseInsensitiveCompare:str2] == NSOrderedSame);
		
//		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//		@try 
//		{
//			NSComparisonResult result = [str1 localizedCaseInsensitiveCompare:str2];
//			
//			return (result == NSOrderedSame);
//		}
//		@finally
//		{
//			[pool release];
//		}
	}
	
	return NO;
}
//
// next are two ways of word counting in a string.
//

+ (NSUInteger)wordCount:(NSString *) string
{
    NSCharacterSet *separators = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *words = [string componentsSeparatedByCharactersInSet:separators];
	
    NSIndexSet *separatorIndexes = [words indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) 
	{
        return [obj isEqualToString:@""];
    }];
	
    return [words count] - [separatorIndexes count];
}

+ (NSUInteger) countWords: (NSString *) string 
{
    NSScanner *scanner = [NSScanner scannerWithString: string];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil]) {
        count++;
    }
	
    return count;
	
} 

+ (NSString*) getWordByCount:(NSString*)string WordNumber:(int)wn
{
	NSString* toReturn = nil;
	NSCharacterSet *separators = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSArray *words = [string componentsSeparatedByCharactersInSet:separators];
	
	if( wn > [words count] )
		return toReturn;
	
	toReturn = [words objectAtIndex:wn-1];
	return toReturn;
	
}

//
// Replaces all "bad" characters in the given string with the given replacement.
// "Bad" characters are control characters, illegal characters and tabs.
// However spaces and newlines are allowed.
//
+ (NSString*) string:(NSString*)string byReplacingBadCharactersWithString:(NSString*)replacement
{
	NSString* toReturn = nil;
	
	@try
	{
		if (string != nil && replacement != nil)
		{
			NSCharacterSet* charSet = BAD_CHARACTER_SET;
			
			NSArray* components = [string componentsSeparatedByCharactersInSet:charSet];
			
			if (components != nil && [components count] > 0)
			{
				toReturn = [components componentsJoinedByString:replacement];
			}
		}
	}
	@catch (NSError* error)
	{
		// Log the error.
		NSLog(@"StringUtilities:string:byReplacingBadReviewCharactersWithString: Caught %@", error);
	}
	@catch (NSException* exc)
	{
		// Log the exception.
		NSLog(@"StringUtilities:string:byReplacingBadReviewCharactersWithString: Caught %@", exc);
	}
	
	if (toReturn == nil)
	{
		return (string == nil ? nil : [NSString stringWithString:string]);
	}
	else
	{
		//NSLog(@"Cleaned string has retain count [%d].\n[%@]", [toReturn retainCount], toReturn);
		return toReturn;
	}
}

//
// Strip HTML tags from the given string.
//
+ (NSString*) stripHtmlCodes:(NSString*) string 
{
    if (string == nil) 
	{
        return @"";
    }
	
    NSArray* htmlCodes = [NSArray arrayWithObjects:@"a", @"em", @"p", @"b", @"i", @"br", @"strong", nil];
	
    for (NSString* code in htmlCodes) 
	{
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", code] withString:@""];
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", code] withString:@""];
    }
	
    return string;
}

//
// Strip HTML tags from the given string, but attempt to maintain space formatting
//
+ (NSString*) stripHtmlCodesWithFormatting:(NSString*) string 
{
    if (string == nil) 
	{
        return @"";
    }
	
	//
	//
	//
    NSArray* emptyOut = [NSArray arrayWithObjects:@"a", @"em", @"i", @"br", @"strong", nil];
    for (NSString* code in emptyOut) 
	{
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", code] withString:@""];
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", code] withString:@""];
    }
	
	//
	//
	//
    NSArray* spaceOut = [NSArray arrayWithObjects:@"p", @"b", nil];	
    for (NSString* code in spaceOut) 
	{
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", code] withString:@""];
        string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", code] withString:@" "];
    }
	
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//
// Decodes any HTML entities contained within the string.
//
//+ (NSString*) stringWithHTMLEntitiesDecoded:(NSString*)input
//{
//	return [HtmlUtil stringWithHTMLEntitiesDecoded:input];
//}

//
// Replace common & escape codes with their string equivalents
//
+(NSString*) unescape:(NSString*)string
{
	if (string == nil)
	{
		return @"";
	}
	string = [string stringByReplacingOccurrencesOfString:@"&#38;" withString:@"&"];
	string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	string = [string stringByReplacingOccurrencesOfString:@"&reg;" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"'"];
	
	string = [string stringByReplacingOccurrencesOfString:@"&#38;" withString:@"&"];
	string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	string = [string stringByReplacingOccurrencesOfString:@"&reg;" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"'"];
	return string;
}


//
// Replaces the non-alphanumeric characters in the given string with the replacement string.
//
+ (NSString*) replaceNonAlphanumericChars:(NSString*)str withString:(NSString*)replacement
{
	if (![self isEmptyString:str] && replacement != nil)
	{
		NSCharacterSet* alphaNumericSet = [NSCharacterSet alphanumericCharacterSet];
		
		NSString* toReturn = str;
		
		for (NSInteger i = [toReturn length] - 1; i >= 0; i --)
		{
			if (![alphaNumericSet characterIsMember:[toReturn characterAtIndex:i]])
			{
				// If toReturn is still pointing to str then create a copy so we can modify it.
				if (toReturn == str)
				{
					toReturn = [NSMutableString stringWithString:str];
				}
				
				[(NSMutableString*)toReturn replaceCharactersInRange:NSMakeRange(i, 1) withString:replacement];
			}
		}
		
		return toReturn;
	}
	
	return str;
}

//
// Replaces the non-numeric characters in the given string with the replacement string.
//
+ (NSString*) replaceNonNumericChars:(NSString*)str withString:(NSString*)replacement
{
	if (![self isEmptyString:str] && replacement != nil)
	{
		NSCharacterSet* numericSet = [NSCharacterSet decimalDigitCharacterSet];
		
		NSString* toReturn = str;
		
		for (NSInteger i = [toReturn length] - 1; i >= 0; i --)
		{
			if (![numericSet characterIsMember:[toReturn characterAtIndex:i]])
			{
				// If toReturn is still pointing to str then create a copy so we can modify it.
				if (toReturn == str)
				{
					toReturn = [NSMutableString stringWithString:str];
				}
				
				[(NSMutableString*)toReturn replaceCharactersInRange:NSMakeRange(i, 1) withString:replacement];
			}
		}
		
		return toReturn;
	}
	
	return str;
}

//
// Converts the given object to a string.
//
+ (NSString*) convertString:(NSObject*)obj defaultString:(NSString*)defaultString
{
	if (obj != nil)
	{
		if ([obj isKindOfClass:[NSString class]])
		{
			return (NSString*)obj;
		}
		else
		{
			return [NSString stringWithFormat:@"%@", obj];
		}
	}
	
	return defaultString;
}
//
// Returns true if the given string is numeric.
//
+ (BOOL) isNumeric:(NSString*)str
{
	NSNumber *testNum;
	
	NSLocale *l_en = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setLocale: l_en];
	[f setAllowsFloats: YES];
	testNum = [f numberFromString: str];
	return (testNum) ? YES:NO;
}

//
// Converts the given object to an integer.
//
+ (NSInteger) convertInt:(NSObject*)obj defaultInt:(NSInteger)defaultInt
{
	if (obj != nil)
	{
		if ([obj isKindOfClass:[NSNumber class]])
		{
			return [(NSNumber*)obj intValue];
		}
		else if ([obj isKindOfClass:[NSString class]])
		{
			if (![StringFunctions isEmptyString:(NSString*)obj])
			{
				if ([self isNumeric:(NSString*)obj])
				{
					return [(NSString*)obj intValue];
				}
			}
		}
	}
	
	return defaultInt;
}

//
// Converts the given object to a float.
//
+ (CGFloat) convertFloat:(NSObject*)obj defaultFloat:(CGFloat)defaultFloat
{
	if (obj != nil)
	{
		if ([obj isKindOfClass:[NSNumber class]])
		{
			return [(NSNumber*)obj floatValue];
		}
		else if ([obj isKindOfClass:[NSString class]])
		{
			if (![StringFunctions isEmptyString:(NSString*)obj])
			{
				if ([self isNumeric:(NSString*)obj])
				{
					return [(NSString*)obj floatValue];
				}
			}
		}
	}
	
	return defaultFloat;
}

//
// Converts the given object to an NSDate.
//
+ (NSDate*) convertDate:(NSObject*)obj dateFormat:(NSString*)dateFormat defaultDate:(NSDate*)defaultDate
{
	return [DateUtil 
			dateFromString:[self convertString:obj defaultString:nil] 
			dateFormat:dateFormat
			defaultDate:defaultDate];
}

//
// Converts the given object to a BOOL.
//
+ (BOOL) convertBool:(NSObject*)obj defaultBool:(BOOL)defaultBool
{
	if (obj != nil)
	{
		if ([obj isKindOfClass:[NSNumber class]])
		{
			return [(NSNumber*)obj boolValue];
		}
		else if ([obj isKindOfClass:[NSString class]])
		{
			if (![StringFunctions isEmptyString:(NSString*)obj])
			{
				return [(NSString*)obj boolValue];
			}
		}
	}
	
	return defaultBool;
}

//
// Converts a BOOL to its string representation.
//
+ (NSString*) convertBoolToString:(BOOL)aBool
{
	return (aBool ? @"YES" : @"NO");
}

//
// Converts a CGRect to its string representation.
//
+ (NSString*) convertRectToString:(CGRect)aRect
{
	return NSStringFromCGRect(aRect);
}

//
// Converts a CGSize to its string representation.
//
+ (NSString*) convertSizeToString:(CGSize)aSize
{
	return NSStringFromCGSize(aSize);
}

//
// Returns YES if the given object is empty.
//
+ (BOOL) isEmpty:(id)obj
{
	if (obj == nil)
	{
		return YES;
	}
	else if ([obj respondsToSelector:@selector(count)])
	{
		return ([obj count] <= 0);
	}
	else if ([obj respondsToSelector:@selector(length)])
	{
		return ([obj length] <= 0);
	}
	
	return YES;
}

//
// Returns YES if the given array is empty.
//
+ (BOOL) isEmptyArray:(NSArray*)array
{
	return (array == nil || ([array respondsToSelector:@selector(count)] ? [array count] : 0) <= 0);
}

//
// Returns YES if the given dictionary is empty.
//
+ (BOOL) isEmptyDictionary:(NSDictionary*)dictionary
{
	return (dictionary == nil || [dictionary count] <= 0);
}

//
// Returns YES if the given data is empty.
//
+ (BOOL) isEmptyData:(NSData*)data
{
	return (data == nil || [data length] <= 0);
}

//
// Simply passes the parameters to NSLog if DEBUG_LOG_ENABLED is true.
//
//void DebugLog(NSString* format, ...)
//{
//	if (DEBUG_LOG_ENABLED)
//	{
//		va_list args;
//		va_start(args, format);
//		
//		NSLogv(format, args);
//		
//		va_end(args);
//	}
//}

@end
