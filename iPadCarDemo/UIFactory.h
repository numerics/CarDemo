//
//  UIFactory.h
//
//  Created by John Basile on 10/29/11.
//  Copyright (c) 2011 Numerics. All rights reserved.

#import <Foundation/Foundation.h>

typedef enum
{
	kNoAdjustment   = 0,
	
	kAdjustX        = 1,
	kAdjustY        = 2,
	kAdjustXY       = 3,
	kAdjustWidth    = 4,
	kAdjustHeight   = 8,
	kAdjustWH       = 12,
	kAdjustALL      = 15,
	
	kAdjustBASEPAD  = 16,
	kAdjustXPAD     = kAdjustBASEPAD + kAdjustX,
	kAdjustYPAD     = kAdjustBASEPAD + kAdjustY,
	kAdjustXYPAD    = kAdjustBASEPAD + kAdjustXY,
	kAdjustWPAD     = kAdjustBASEPAD + kAdjustWidth,
	kAdjustHPAD     = kAdjustBASEPAD + kAdjustHeight,
	kAdjustWHPAD    = kAdjustBASEPAD + kAdjustWH,
	kAdjustALLPAD   = 32,
	
	kAdjust568      = 64,
	kAdjustY568     = kAdjust568 + kAdjustY,
	kAdjustH568     = kAdjust568 + kAdjustHeight,
	
	kAdjustCELL     = 128,
	
}CGRectAdjust;

@interface UIFactory : NSObject
{
	NSString        *appPrefix;
	NSString        *appSuffix;         // for now, nil or _iPad... could add other, eg _iPh5
	NSString        *appProduct;
	
	BOOL            iPad;
	
	UIColor         *backgroundColor;
	
	NSDictionary    *commonDict;
	
	UIImage			*dividerImage;
	
	UIColor			*linkColorNormal;
	UIColor			*defaultColorHighlight;
	UIColor			*greyTextColor;
	UIColor			*lightGreyTextColor;
	UIImage			*loadingBackgroundImage;
	
	NSString        *_bundleName;
	
	NSMutableDictionary		*_colorDictionary;
	NSMutableDictionary		*_fontDictionary;
	NSMutableDictionary		*_fontColorAlignDictionary;
	NSMutableDictionary		*_imageDictionary;
	NSDictionary			*_propertiesDictionary;
}

@property (nonatomic, readonly) BOOL isPortraitOrientation;
@property (nonatomic, readonly) BOOL isLandscapeOrientation;

@property (nonatomic, readonly) BOOL iPad;

@property (nonatomic, strong) NSString      *appPrefix;
@property (nonatomic, strong) NSString      *appSuffix;
@property (nonatomic, strong) NSString      *appProduct;

@property (nonatomic, strong) UIColor       *backgroundColor;
@property (nonatomic, strong) NSDictionary  *commonDict;
@property (nonatomic, strong) NSArray       *abstractObjects;


@property (nonatomic, strong) UIImage		*dividerImage;

@property (nonatomic, strong) UIColor		*linkColorNormal;
@property (nonatomic, strong) UIColor		*defaultColorHighlight;
@property (nonatomic, strong) UIColor		*greyTextColor;
@property (nonatomic, strong) UIColor		*lightGreyTextColor;

@property (nonatomic, strong) UIImage		*loadingBackgroundImage;

@property (nonatomic) CGFloat titleLineHeightLarge;
@property (nonatomic) CGFloat titleLineHeightSmall;
@property (nonatomic) CGFloat titleMaxHeight;

//*********** MACROS TO ADJUST A RECT WHEN PROVIDE A ELEMENTS OF A CGRECT, (I.E. X,Y, WIDTH, HEIGHT) ***************//

#define KCGRECTMAKE_ALL(X,Y,W,H)        [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustALL]
#define KCGRECTMAKE_X(X,Y,W,H)          [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustX]
#define KCGRECTMAKE_Y(X,Y,W,H)          [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustY]
#define KCGRECTMAKE_XY(X,Y,W,H)         [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustXY]
#define KCGRECTMAKE_W(X,Y,W,H)          [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustWidth]
#define KCGRECTMAKE_H(X,Y,W,H)          [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustHeight]
#define KCGRECTMAKE_WH(X,Y,W,H)         [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustWH]

//*********** MACROS WITH THE PAD SUFFIX => OPERATIONS WILL ONLY BE PERFORMED WHEN THE DEVICE IS AN IPAD, (I.E. NOT IPHONE 5)
#define KCGRECTMAKE_ALLPAD(X,Y,W,H)     [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustALLPAD]
#define KCGRECTMAKE_XPAD(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustXPAD]
#define KCGRECTMAKE_YPAD(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustYPAD]
#define KCGRECTMAKE_XYPAD(X,Y,W,H)      [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustXYPAD]
#define KCGRECTMAKE_WPAD(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustWPAD]
#define KCGRECTMAKE_HPAD(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustHPAD]
#define KCGRECTMAKE_WHPAD(X,Y,W,H)      [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustWHPAD]

//*********** MACROS WITH THE CELL SUFFIX => THE DEVICE IS AN IPAD, SCALED BY 2.4 FOR TABLE CELLS
#define KCGRECTMAKE_ALLCELL(X,Y,W,H)     [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustALLPAD+kAdjustCELL]
#define KCGRECTMAKE_XCELL(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustXPAD+kAdjustCELL]
#define KCGRECTMAKE_YCELL(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustYPAD+kAdjustCELL]
#define KCGRECTMAKE_XYCELL(X,Y,W,H)      [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustXYPAD+kAdjustCELL]
#define KCGRECTMAKE_WCELL(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustWPAD+kAdjustCELL]
#define KCGRECTMAKE_HCELL(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustHPAD+kAdjustCELL]
#define KCGRECTMAKE_WHCELL(X,Y,W,H)      [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustWHPAD+kAdjustCELL]

//*********** MACROS WITH THE PAD SUFFIX => OPERATIONS WILL ONLY BE PERFORMED WHEN THE DEVICE IS AN IPHONE 5
#define KCGRECTMAKE_H568(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustH568]
#define KCGRECTMAKE_Y568(X,Y,W,H)       [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustY568]

//*********** MACROS TO ADJUST A RECT WHEN PROVIDE A CGRECT ***************//

#define KCGRECTADJUST_ALL(R)            [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustALL]
#define KCGRECTADJUST_X(R)              [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustX]
#define KCGRECTADJUST_Y(R)              [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustY]
#define KCGRECTADJUST_XY(R)             [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustXY]
#define KCGRECTADJUST_W(R)              [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustWidth]
#define KCGRECTADJUST_H(R)              [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustHeight]
#define KCGRECTADJUST_WH(R)             [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustWH]

//*********** MACROS WITH THE PAD SUFFIX => OPERATIONS WILL ONLY BE PERFORMED WHEN THE DEVICE IS AN IPAD, (I.E. NOT IPHONE 5)
#define KCGRECTADJUST_ALLPAD(R)         [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustALLPAD]
#define KCGRECTADJUST_XPAD(R)           [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustXPAD]
#define KCGRECTADJUST_YPAD(R)           [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustYPAD]
#define KCGRECTADJUST_HPAD(R)           [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustHPAD]
#define KCGRECTADJUST_WPAD(R)           [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustWPAD]
#define KCGRECTADJUST_XYPAD(R)          [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustXYPAD]
#define KCGRECTADJUST_WHPAD(R)          [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustWHPAD]

//*********** MACROS WITH THE CELL SUFFIX => THE DEVICE IS AN IPAD, SCALED BY 2.4 FOR TABLE CELLS
#define KCGRECTADJUST_ALLCELL(R)        [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustALLPAD+kAdjustCELL]
#define KCGRECTADJUST_XCELL(R)          [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustXPAD+kAdjustCELL]
#define KCGRECTADJUST_YCELL(R)          [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustYPAD+kAdjustCELL]
#define KCGRECTADJUST_XYCELL(R)         [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustXYPAD+kAdjustCELL]
#define KCGRECTADJUST_WCELL(R)          [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustWPAD+kAdjustCELL]
#define KCGRECTADJUST_HCELL(R)          [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustHPAD+kAdjustCELL]
#define KCGRECTADJUST_WHCELL(R)         [[UIFactory sharedInstance] CGRectMake:CGRectMake(X, Y, W, H) CGRectAdjust:kAdjustWHPAD+kAdjustCELL]

//*********** MACROS WITH THE 568 SUFFIX => OPERATIONS WILL ONLY BE PERFORMED WHEN THE DEVICE IS AN IPHONE 5
#define KCGRECTADJUST_H568(R)           [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustH568]
#define KCGRECTADJUST_Y568(R)           [[UIFactory sharedInstance] CGRectMake:(R) CGRectAdjust:kAdjustY568]

//*********** MACROS TO USE FACTORY METHODS FOR UNIVERSAL CONVERSIONS ***************//

#define IMAGEDNAMED(X)                  [[UIFactory sharedInstance] imageNamed:X]
#define IMAGEFILE(X)                    [[UIFactory sharedInstance] imageWithContentsOfFile:X]
#define PROPERNIB(X)                    [[UIFactory sharedInstance] properNibName:X]
#define SETFRAMEMAKE(O,X,Y,W,H)         [[UIFactory sharedInstance] modFrame:(O) theRect:CGRectMake(X, Y, W, H)]
#define SETFRAMEADJUST(O,R)             [[UIFactory sharedInstance] modFrame:(O) theRect:(R)]

//
// Methods from CHLookAndFeelManager
//
+ (NSDictionary *) dictionaryFromPlistWithBaseName: (NSString *) aBaseName;

- (NSString *) setBundleName: (NSString *) keyName;

- (UIColor *) colorAtKey: (NSString *) keyName;
- (UIFont *) fontAtKey: (NSString *) keyName;
- (UIColor *) fontColorAtKey: (NSString *) keyName;
- (UIImage *) imageAtKey: (NSString *) keyName;
- (NSString *) stringAtKey: (NSString *) keyName;

- (UIColor *) colorFromHexString: (NSString *) hexString;

// Dictionaries
- (void) createColorDictionary;
- (void) createFontDictionary;
- (void) createFontColorDictionary;

//
// Returns the singleton reference to the UIFactory.
//
+ (UIFactory*) sharedInstance;


- (UIImage *)viewBackgroundForOrientation:(UIInterfaceOrientation)orientation;
- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics;
- (UIImage *)navigationBackgroundForIPadAndOrientation:(UIInterfaceOrientation)orientation;

- (void) setupStatusBar:(UIView *)baseView;


- (UIColor *)grayColor:(CGFloat)gray alpha:(CGFloat)alpha;

- (void)modFrame:(id)aObj theRect:(CGRect)rekt;

- (CGRect)CGRectMake:(CGRect)rekt CGRectAdjust:(int)options;

- (NSString *)properNibName:(NSString *)nibName;

- (UIImage *) imageWithContentsOfFile:(NSString *)path;

- (UIImage *) imageNamed:(NSString *)name;

- (UIColor *) getBackgroundFromProperties:(NSString *)property;

- (NSDictionary *) getTargetDict:(NSString *)viewController;

- (NSString *) getClassTitle:(NSString *)viewController;

- (id) loadClazz:(NSString *)viewController;

//- (NSDictionary *)fetchPropertyNamesForKeys: (id)aObj excludeTypes:(NSString *)excluded;
- (void)addValuesToObjfromJsonDict:(id)aObj jsonDict:(NSDictionary*)dict excludeTypes:(NSString *)excluded;

- (id) loadProperty: (NSString*)viewController property:(NSString *)key;

- (void)loadDefaultPropertyValues: (id)aObj;

- (void)loadDefaultPropertyValues:(id)aObj ObjectName:(NSString *)objName;

- (void)loadButtonProperties:(NSDictionary *)buttonInfo button:(id)obj;

- (void)loadLabelProperties:(NSDictionary *)labelInfo label:(UILabel *)lbl;

- (void)loadImageViewProperties:(NSDictionary *)imageViewInfo imageView:(UIImageView *)imv;

- (UIViewController *)loadControllerWithFactory:(NSString *)controllerName;

- (UIView *)loadViewWithFactory:(NSString *)viewName withFrame:(CGRect)frame;

- (BOOL) isPortraitOrientation;

- (BOOL) isLandscapeOrientation;

- (UIFont*) fontWithSize:(CGFloat)fontSize bold:(BOOL)bold italic:(BOOL)italic;

- (UILabel *) stdTitleLabelWithText:(NSString*)text;

- (UILabel *) stdLabelWithText:(NSString*)text;

- (UILabel *) labelWithColor:(UIColor *)Color selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

- (UILabel *) labelWithColor:(UIColor *)color selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold text:(NSString*)text;

- (UILabel *) labelWithColor:(UIColor *)color
			   selectedColor:(UIColor *)selectedColor
					fontSize:(CGFloat)fontSize
						bold:(BOOL)bold
					  italic:(BOOL)italic
						text:(NSString*)text;

- (UITextView*) textViewWithColor:(UIColor *)Color fontSize:(CGFloat)fontSize bold:(BOOL)bold;

//
// Creates a new, autoreleased text field. The caller is responsible for retaining ownership.
//
- (UITextField*) textFieldWithFrame:(CGRect)frame;

- (NSString *) getFormattedRuntimeString:(NSInteger) runtime;

- (NSString *) stringWithTimeInterval:(NSTimeInterval) timeInterval;

/// Replacement for the deprecated sizeWithFont
- (CGSize)sizeWithMyFont:(UIFont *)font withText:(NSString *)text withWidth:(CGFloat)width;

- (CGSize)sizeWithMyFont:(UIFont *)font withText:(NSString *)text withWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
-(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

//
// Returns the size of the given title taking into account a font size reduction
// if the title needs to wrap.
//
- (CGSize) titleSize:(NSString*)title withWidth:(CGFloat)width outFont:(UIFont**)outFont;

//
// Lays out the given title label at the given origin/point respecting the maximum width.
// Returns the resulting frame of the label.
//
- (CGRect) layoutTitleLabel:(UILabel*)titleLabel atPoint:(CGPoint)point withMaxWidth:(CGFloat)maxWidth;

//
// Draws the given title at the given origin/point respecting the maximum width.
// Returns the resulting frame of the label.
//
- (CGRect) drawTitle:(NSString*)title atPoint:(CGPoint)point withMaxWidth:(CGFloat)maxWidth;

//
// Toggles the selected state of a checkbox button.
//
- (void) checkboxToggleSelection:(id)source;

//
// sets the selected state of the checkbox
//
- (void) checkboxSetSelection:(id)source selected:(BOOL)selected;

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
- (void) adjustButtonSizeToFitText:(UIButton*)button;

//
// Corrects the width and height of the given UIButton to accomodate its text on a single line.
//
- (void) adjustButtonSizeToFitText:(UIButton*)button withInsets:(UIEdgeInsets)insets;

//
// Corrects the width and height of the given UILabel to accomodate its text on a single line.
//
- (void) adjustLabelSizeToFitText:(UILabel*)label;

//
// Corrects the height of the given UILabel to accomodate its text content relative to its current width.
//
- (void) adjustLabelHeightToFitText:(UILabel*)label;

//
// Returns the ideal height for the given text string.
//
- (CGFloat) idealStringHeight:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font;

//
// Returns the ideal size for the given text string.
//
- (CGSize) idealStringSize:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont*)font;

//
// A helper method to set just the x-position of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setX:(CGFloat)xPos;

//
// A helper method to set just the y-position of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setY:(CGFloat)yPos;

//
// A helper method to set just the origin of the given UIView.
// Returns the new origin of the view.
//
- (CGPoint) view:(UIView*)view setOrigin:(CGPoint)origin;

//
// A helper method to set just the width of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setWidth:(CGFloat)width;

//
// A helper method to set just the height of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setHeight:(CGFloat)height;

//
// A helper method to set just the size of the given UIView.
// Returns the new size of the view.
//
- (CGSize) view:(UIView*)view setSize:(CGSize)size;

//
// A helper method to set just the accessibility label and hint of the given view.
//
- (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint;

//
// A helper method to set just the accessibility label and hint of the given view.
//
- (void) view:(NSObject*)view setAccessibilityLabel:(NSString*)label andHint:(NSString*)hint andValue:(NSString*)value;

//
// A helper method to convert the string into an accessible string such that each letter is spoken separately.
//
- (NSString*) letterizeString:(NSString*)aString;

//
// Splits the given string on words and capitalizes each word.
//
- (NSString*) capitalizeWordsInString:(NSString*)str;

//
// A helper method to set just the font of the given UIButton.
//
- (void) button:(UIButton*)button setFont:(UIFont*)font;

//
// A helper method to return the font of a UIButton (this is done to reduce the number of compiler warnings).
//
- (UIFont*) buttonGetFont:(UIButton*)button;

//
// Loads the nib with the given name and return the first UIView.
//
- (UIView*) loadViewFromNibNamed:(NSString*)nibName owner:(id)owner;

- (UIButton*) replaceButton:(UIButton*)src withButton:(UIButton*)replacement;

- (UIView*) replaceView:(UIView*)src withView:(UIView*)replacement;

//
// Returns an autoreleased UIAccessibilityElement.
//
- (id) accessibleElementWithContainer:(id)container frame:(CGRect)frame label:(NSString*)label hint:(NSString*)hint;

//
// A helper method to defocus all subviews of a view
//
+ (void) resignFirstRespondersOf:(UIView*)parentView;

//
// A helper method to defocus all subviews of a view and a given class.  For example [UITextEntry class] if you only want to close onscreen keyboards.
//
+ (void) resignFirstRespondersOf:(UIView*)parentView ofClass:(Class)ofClass;


//
// Displays the following message in a standard UIAlertView.
//
- (void) alertMessage:(NSString*)message;

//
// A generic handler to deal with not implemented features.
//
- (void) notYetImplementedHandler:(id)source;

@end

@interface UIMutableFont : UIFont
{
	CGFloat _ascender;
	CGFloat _capHeight;
	CGFloat _descender;
	NSString* _familyName;
	NSString* _fontName;
	CGFloat _leading;
	CGFloat _pointSize;
	CGFloat _xHeight;
}

- (id) initWithFont:(UIFont*)font;

@end



