//
//  NSString+Additions.h

//#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (int)occurencesOfSubstring:(NSString *)substr;
- (int)occurencesOfSubstring:(NSString *)substr options:(int)opt;

- (NSArray *)tokensSeparatedByCharactersFromSet:(NSCharacterSet *) separatorSet;
- (NSArray *)objCTokens;	// (and C tokens too) a contiguous body of non-'punctuation' characters.
							// skips quotes, -, +, (), {}, [], and the like.
- (NSArray *)words;			// roman-alphabet words

- (BOOL) containsCharacterFromSet:(NSCharacterSet *)set;
- (NSString *)stringWithSubstitute:(NSString *)subs forCharactersFromSet:(NSCharacterSet *)set;

- (NSArray *)linesSortedByLength;
- (NSComparisonResult)compareLength:(NSString *)otherString;

- (BOOL)smartWriteToFile:(NSString *)path atomically:(BOOL)atomically;
							// won't write to file if nothing has changed, (may be slow for large amounts of text)

- (unsigned)lineCount;		// count lines/paragraphs

- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag;

-(NSArray *) splitToSize:(unsigned)size; // returns NSArray of <= size character strings
-(NSString *)removeTabsAndReturns;
-(NSString *)newlineToCR;

-(NSString *)safeFilePath;

-(NSRange)whitespaceRangeForRange:(NSRange) characterRange; 
//returns the range of characters around characterRange, extended out to the nearest whitespace

- (NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
- (NSString *)substringBeforeRange:(NSRange)range;
- (NSString *)substringAfterRange:(NSRange)range;



@end
