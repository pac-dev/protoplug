// protojuce/cdefs/typedefs.h
// c structures as exported by protoplug
// included by protojuce.lua

// pointer-structs :
// this is equivalent passing the pointers directly

typedef struct pGraphics
{ void *pointer; } pGraphics;

typedef struct pFillType
{ void *pointer; } pFillType;

typedef struct pColourGradient
{ void *pointer; } pColourGradient;

typedef struct pImage
{ void *pointer; } pImage;

typedef struct pFont
{ void *pointer; } pFont;

typedef struct pPath
{ void *pointer; } pPath;

typedef struct pComponent
{ void *pointer; } pComponent;

//typedef struct pMidiBuffer
//{ void *pointer; } pMidiBuffer;

//typedef struct pMidiBuffer_Iterator
//{ void *pointer; } pMidiBuffer_Iterator;


// accessible structs that get converted to JUCE objects

typedef struct pAudioFormatReader
{ 
	const void *pointer; 
	const double sampleRate;
	const unsigned int bitsPerSample;
	const int64_t lengthInSamples;
	const unsigned int numChannels;
	const bool usesFloatingPointData;
} pAudioFormatReader;

typedef struct LagrangeInterpolator
{
    float lastInputSamples[5];
    double subSamplePos;
} LagrangeInterpolator;

typedef struct Colour
{
	union
	{
		struct { uint8_t b, g, r, a; }; 
		uint32_t argb;
	}; 
} Colour;

typedef struct Point_int
{
	int x, y;
} Point_int;

typedef struct Point_float
{
	float x, y;
} Point_float;

typedef struct Line_int
{
	int startx, starty;
	int endx, endy;
} Line_int;

typedef struct Line_float
{
	float startx, starty;
	float endx, endy;
} Line_float;

typedef struct Rectangle_int
{
	int x, y, w, h;
} Rectangle_int;

typedef struct Rectangle_float
{
	float x, y, w, h;
} Rectangle_float;

typedef struct KeyPress
{
	int keyCode;
	int mods;
	wchar_t textCharacter;
} KeyPress;

typedef struct AffineTransform
{
	float mat00, mat01, mat02;
	float mat10, mat11, mat12;
} AffineTransform;

typedef struct PathStrokeType
{
	float thickness;
	int jointStyle;
	int endStyle;
} PathStrokeType;

typedef struct MouseEvent
{
	int x, y;
	int mods;
	pComponent eventComponent;
	pComponent originalComponent;
	int64_t eventTime;
	int64_t mouseDownTime;
	Point_int mouseDownPos;
	uint8_t numberOfClicks, wasMovedSinceMouseDown;
} MouseEvent;

typedef struct MouseWheelDetails
{
	float deltaX;
	float deltaY;
	bool isReversed;
	bool isSmooth;
} MouseWheelDetails;
