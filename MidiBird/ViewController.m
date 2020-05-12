//
//  ViewController.m
//  MidiBird
//
//  Created by Sinri Edogawa on 2020/5/11.
//  Copyright © 2020 Sinri Edogawa. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MidiWorkerMac/MidiWorkerMac.h>

@interface ViewController() //: NSViewController

@property (weak) IBOutlet NSTextField *selectedMidiFilePathTextInput;

@property NSURL *loadedMidiURL;
@property AVMIDIPlayer*player;
@property NSTimer*timer;
@property (weak) IBOutlet NSSlider *progressSlider;
@property (weak) IBOutlet NSTextField *progressLabel;
@property (weak) IBOutlet NSTextField *totalLabel;
@property (weak) IBOutlet NSButton *playControlButton;
@property (weak) IBOutlet NSTabView *sourceTabView;
@property (unsafe_unretained) IBOutlet NSTextView *midiDraftTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [_playControlButton setEnabled:NO];
    [_progressSlider setEnabled:NO];
    
//    [_progressSlider setTarget:self];
//    [_progressSlider setAction:@selector(progressSliderValueChanged:)];
    
    //MidiWorker*worker=[[MidiWorker alloc]init];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)whenLoadButtonClicked:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    op.canChooseFiles = YES;
    op.canChooseDirectories = NO;
    [op runModal];
    if([op URL]!=nil){
        _loadedMidiURL=[op URL];
        NSLog(@"Midi URL: %@",_loadedMidiURL);
        _selectedMidiFilePathTextInput.stringValue = [_loadedMidiURL path];

        [self prepareMidiDataToPlay:[NSData dataWithContentsOfURL:_loadedMidiURL]];
        [_playControlButton setEnabled:YES];
    }
}
- (IBAction)whenPreviewButtonClicked:(id)sender {
//    MidiWorker*_worker=[[MidiWorker alloc]init];
//    //Name
//    [_worker setName:@"MidiBirdDraft"];
//    //Tempo
//    [_worker setTempo:0x078300];
//    //Time Signature
//    [_worker setTimeSignatureNumerator:4];
//    [_worker setTimeSignatureDenominator:2];
//    [_worker setTimeSignatureMetronome:24];
//    [_worker setTimeSignature32ndCount:8];
//    //Key Signature
//    [_worker setKeySignature:Major_C];
//
//    MidiTrace * mt=[[MidiTrace alloc]init];
//    NSString * numberedNotes=[_midiDraftTextView string];
//    [mt setNoteArray:[
//                      [MidiNote MidiNoteArrayMakerForChannel:0
//                                    NumberedMusicialNotation:numberedNotes
//                       ] mutableCopy
//                      ]
//     ];
//
//    [_worker.traceArray addObject:mt];
//    NSData * filedata=[_worker buildMidiFileData];
    
    NSData*data=[self generateMidiDataFromDraftString:[_midiDraftTextView string]];
    [self prepareMidiDataToPlay:data];
    [_playControlButton setEnabled:YES];
}

- (IBAction)whenSaveButtonClicked:(id)sender {
    NSSavePanel *op = [NSSavePanel savePanel];
    op.canCreateDirectories=YES;
    [op runModal];
    if([op URL]!=nil){
        NSError*error=nil;
        BOOL done=[[_midiDraftTextView string]writeToURL:[op URL] atomically:YES encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"write draft done=%i error=%@",done,error);
    }
}
- (IBAction)whenOpenButtonClicked:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    op.canChooseFiles = YES;
    op.canChooseDirectories = NO;
    [op runModal];
    if([op URL]!=nil){
        NSError*error=nil;
        NSString*draft=[NSString stringWithContentsOfURL:[op URL] encoding:NSUTF8StringEncoding error:&error];
        if(draft==nil){
            NSLog(@"read draft got nil while error=%@",error);
            [_midiDraftTextView setString:[error description]];
        }else{
            [_midiDraftTextView setString:draft];
        }
    }
}
- (IBAction)whenExportButtonClicked:(id)sender {
    NSData*data=[self generateMidiDataFromDraftString:[_midiDraftTextView string]];
    NSSavePanel *op = [NSSavePanel savePanel];
    [op setCanCreateDirectories:YES];
    [op runModal];
    if([op URL]!=nil){
        BOOL done=[data writeToURL:[op URL] atomically:YES];
        NSLog(@"exported = %i",done);
    }
}

#pragma mark midi data

-(void)prepareMidiDataToPlay:(NSData*)data{
    //NSHomeDirectory();
//    NSString*musicDirPath=[NSSearchPathForDirectoriesInDomains(NSMusicDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSLog(@"data: %@",data);
    
    
    NSError*error=nil;
    if(_player!=nil){
        if([_player isPlaying])[_player stop];
        _player = nil;
    }
    
    _player=[[AVMIDIPlayer alloc]initWithData:data soundBankURL:nil error:&error];
    
    NSLog(@"player is nil? %@ Error: %@",@(_player==nil),error);
    NSLog(@"midi duration: %f",[_player duration]);
    NSLog(@"midi rate: %f",[_player rate]);
    [_player prepareToPlay];
    
    //[_totalLabel performSelectorOnMainThread:@selector(setStringValue:) withObject:[NSString stringWithFormat:@"%d:%.2f",(int)[_player duration]/60,[_player duration]-((int)[_player duration]/60)] waitUntilDone:YES];
    [_totalLabel setStringValue:[NSString stringWithFormat:@"%d:%.2f",(int)[_player duration]/60,[_player duration]-((int)[_player duration]/60)]];
    [_progressSlider setEnabled:YES];
    //[self performSelectorOnMainThread:@selector(refreshButtonContent) withObject:nil waitUntilDone:NO];
    [self refreshButtonContent];
}

-(NSData*)generateMidiDataFromDraftString:(NSString*)draft{
    MidiWorker*_worker=[[MidiWorker alloc]init];
    //Name
    [_worker setName:@"MidiBirdDraft"];
    //Tempo
    [_worker setTempo:0x078300];
    //Time Signature
    [_worker setTimeSignatureNumerator:4];
    [_worker setTimeSignatureDenominator:2];
    [_worker setTimeSignatureMetronome:24];
    [_worker setTimeSignature32ndCount:8];
    //Key Signature
    [_worker setKeySignature:Major_C];
    
    MidiTrace * mt=[[MidiTrace alloc]init];
    NSString * numberedNotes=draft;
    [mt setNoteArray:[
                      [MidiNote MidiNoteArrayMakerForChannel:0
                                    NumberedMusicialNotation:numberedNotes
                       ] mutableCopy
                      ]
     ];

    [_worker.traceArray addObject:mt];
    NSData * filedata=[_worker buildMidiFileData];
    return filedata;
}

#pragma mark player

-(void)checkPlayerStatus{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        //NSLog(@"is playing %hhd position %f",[self->_player isPlaying],[self->_player currentPosition]);
        NSTimeInterval position=[self->_player currentPosition];
        NSTimeInterval total=[self->_player duration];
        [self->_progressLabel setStringValue:[NSString stringWithFormat:@"%d:%.2f",
                                        (int)position/60,
                                        position-((int)position/60)
                                        ]
         ];
        [self->_progressSlider setMinValue:0];
        [self->_progressSlider setMaxValue:total];
        [self->_progressSlider setFloatValue:[self->_player currentPosition]];
    }];
}

- (IBAction)onPlayerControlButton:(id)sender {
    [self refreshButtonContent];
}

-(void)renewTimer{
    if(_timer!=nil){
        [_timer invalidate];
        _timer=nil;
    }
    _timer=[NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(checkPlayerStatus) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

-(void)refreshButtonContent{
    if([_player isPlaying]){
        [_player stop];
        //[_playControlButton setTitle:@"Play"];
        [_playControlButton setImage:[NSImage imageNamed:NSImageNameTouchBarPlayTemplate]];
        [_timer invalidate];
    }else{
        [_player play:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"player completionHandler callback block, current: %f duration: %f",[self->_player currentPosition],[self->_player duration]);
                [self->_timer invalidate];
                [self->_playControlButton setImage:[NSImage imageNamed:NSImageNameTouchBarPlayTemplate]];
                if([self->_player currentPosition]+0.1>=[self->_player duration]){
                    [self->_player setCurrentPosition:0];
                }
                [self checkPlayerStatus];
            }];
        }];
        //[_playControlButton setTitle:@"Stop"];
        [_playControlButton setImage:[NSImage imageNamed:NSImageNameTouchBarPauseTemplate]];
        [self renewTimer];
    }
}

- (IBAction)progressSliderAction:(id)sender {
    NSLog(@"progressSliderAction -> %f",[_progressSlider floatValue]);
    [_player setCurrentPosition:[_progressSlider floatValue]];
}

@end
