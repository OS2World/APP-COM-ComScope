�   D REXX.METACONTROL `� OS/2     REXXSAA 4.00 10 Feb 1994  h  -� 鉸@Bb          �REXX.LITERALPOOL >   �      �     �  	   �     �     �  5   �  7   �  @   *     b     [     Y     ^     f     `     \     Y     V     O     H  
   Q     S     [     Y     R     L  
   K  
   M     O     ]     Z     S     W  9   W     �  5   �  	   �     �     �     �     �     �     �  
   �     �     �     �     �     �  /   �     �  %   �          
  
   	                                      .@echo offARG0You must supply a version directory as parameter one.You may also supply a destination path as parameter twoand the word DEBUG as the third parameter, for obvious purposes.1LENGTHDebug EnabledParameters are: A:TRUEFALSESTRIPt\Using file list: \FILES.LSTDestination is: SUBSTR2B:format /Q /ONCE >Formatting/Q /ONCE /V:OS_tools >label<\label.dat >LabelingSetting attributes to un-hide source initialization files\*.ini -h >Setting attributes to delete all files at destination\*.* -h >del\*.* < yes.ans >Deleting all files on File list is:LINESLINEINProcessing[T]LProcessing new directorySetting attributes to hide initialization files\*.ini +h >Setting attributes to hide icon files\*.ico +h >Making  directorySetting attributes to un-hide -h >copy FILESPECname>Copying  �REXX.VARIABLEBUF     �     �      �      �   	   �      �      �      �      �      �      �      �      �      �      �      �      �   	   �      �      �      �      �      �      �      �      �   	   �      �      �      �      �      �   rcsiglresultbCopyDemoFALSEcountpausesParamssSourcesDestinationsDebugsNullCONbDebugNULbInstallingDiskettesFileListsDiskformatlabelattribdelverifyonsLinesFileNamesDemoDirTRUEmdcopyoff �REXX.TOKENSIMAGE     � �    x              �    g    �    \    \    �    \    o    ]    �    X    �        \    H    `    �         �    
    g    
    g    
    g 	   
    g 
   �    \            �    �    \    o    ]    �    X 	   `    �    �    %    \ 	   \ 
   \    \        o 
   ] ,   �    X    \    �    I    `    �         �    
    g    �    \    \    �    \ 	   `        �    �        �    �    \    \    �    \    `        �        \    I    `    �         
    g    @    \    �        o 
   ] ,   �    X 
   \    �    H    `    �         �    � 
   \    g    �    \    g        �    �        �    �    \    g     � 
   \     o    ] <   �     X 
   \     �    g     �    g     � !    !   � "   � 	   \ "   o    ] <   � "   X 	   \ "   �    g "   �    g "   � #       \ #   I    `    � #     #   � $   
    g $   @ 	   \ $   @    g %   
    g %   @ 
   \ &    &   � '   �    \ 	   \ '   @    g (   �    \ (   o    ] =   � (   X 
   \ (   � 	   ` (   �    ` (   � )       \ )   H    g )   N    \ )   H    g J   � )     )   � *       \ *   I    `    � *     +   
    g +   ?    \ +   ?    g +   ?    \ +   �    � +    -   
    g -   ?    \ -   � .   �    \ .   ?    \ .   ?    g .   ?    \ /       \ /   I    `    � /     0   
    g 0   ?    \ 0   ?    g 0   ? 	   \ 0   @    g 0   ?    \ 0   �    � 0    2   
     g 2   ?    \ 2   � 3   �    \ 3   ?    \ 3   ?    g 3   ? 	   \ 3   @    g 3   ?    \ 4    4   � G   � 4    5   � 6       \ 6   I    `    � 6     7   
 !   g 7   � 8   �    \ 8   ? 	   \ 8   @ "   g 8   ?    \ 9       \ 9   I    `    � 9     :   
 #   g :   ? 
   \ :   � ;   �    \ ;   ? 
   \ ;   @ $   g ;   ?    \ <       \ <   I    `    � <     =   
 %   g =   ? 
   \ =   @ &   g =   ?    \ =   �    � =    ?   
 '   g ?   @ 
   \ ?   � @   �    \ @   ? 
   \ @   @ &   g @   ?    \ A    A   � B       \ B   I    `    � B     B   � C   �    \ D   
 (   g D   ?    \ E    E   � F   �    \ F   ?    \ G   �   �     '    � G   X G   o )   ] /   � G   X    \ G   � G   H 	   ` G   � H   �    \ H   o *   ] -   � H   X    \ H   � I   �    \    \ J       \ J   I    `    � J     K   
 +   g K   ?    \ K   � L    L   o    ] =   � L   X    \ L   � 	   ` L   � 	   ` L   � L   H ,   g �   � L     L   � M   �    \ M   o    ] <   � M   X    \ M   � -   g M   � .   g M   � N   �    \ N   o    ] <   � N   X    \ N   � /   g N   � ,   g N   � O       \ O   I    `    � O     O   � P   
 0   g P   ?    \ Q   �    \ R    R   � S   �    \ S   o *   ] -   � S   X    \ S   � T   �    \    \ U       \ U   I    `    � U     V   
 +   g V   ?    \ V   � W   �    \    \ X       \ X   I    `    � X     Y   
 1   g Y   � Z   �    \ Z   ? 
   \ Z   @ 2   g Z   ?    \ [       \ [   I    `    � [     \   
 3   g \   � ]   �    \ ]   ? 
   \ ]   @ 4   g ]   ?    \ ^   
 5   g ^   @    \ ^   @ 6   g _   �    \ _   ? 
   \ _   @    g _   @    \ `   � 
   \ 
   \ `   @    g `   @    \ a       \ a   I    `    � a     b   
 7   g b   ?    \ b   � c   �    \ c   ?    \ c   @ 8   g c   ?    \ d       \ d   I    `    � d     e   �    \ e   � f    f   � g    g   o 
   ] ,   � g   X    \ g   � g   I    ` =   � g     g   � h       \ h   I    `    � h     i   
 9   g i   @    \ i   ? 
   \ i   @    g i   @ i   o :   ]    � i   X ;   g i   �    \ i   � i   ? <   g i   ?    \ i   �    � i    k   
 =   g k   @    \ k   � l   �    \ l   ?    \ l   ? 
   \ l   @    g l   @ l   o :   ]    � l   X ;   g l   �    \ l   � l   ? <   g l   ?    \ m    m   � n    o   �    \ o   ?    \ p       \ p   I    `    � p     q   
 1   g q   � r   �    \ r   ? 
   \ r   @ 2   g r   ?    \ s       \ s   I    `    � s     t   
 3   g t   � u   �    \ u   ? 
   \ u   @ 4   g u   ?    \ v       \ v   I    `    � v     w   �    \ w   � w   �     �  
� .CLASSINFO ���     �   WPCommandFile j � �� ��    H WPProgramFile  
                   ��  $                                     	 8 WPObject           	                     ��   ��������      