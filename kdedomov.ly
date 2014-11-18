\version "2.18.2"
\include "deutsch.ly"

\header {
  title = "Kde domov můj"
  composer = "F. Škroup / J. K. Tyl"
}
#(set-global-staff-size 25 )

global = {
  \time 4/4
  \key d \major
  \tempo 4=100
}

globalend = {
  \bar "|."
}

soprano = \relative c'' {
  \global
  r4 a2 h8 a |
  e4 g2 fis8 e |
  d2 r4 d8 d |
  d8. ( g16 ) g2 a8 h |
  a8 ( fis ) d4 r4 d8 d |
  
  d8 ( g ) g ( h ) d4 ( cis8 ) h |
  h4 a r a8 a |
  a2 ~ a8 h a g |
  fis2 r4 a8 a |
  cis2 ~ cis8 h a g |
  fis2 r4 fis8 fis |
  
  fis4. fis8 fis4 ( gis8 ) ais8 |
  ais8 ( h ) h4 r h8 h |
  h8 ( a ) a2 g8 a |
  fis4 ( d'2 ) cis8 h |
  h4 a2 e8 fis |
  d2 r2
  \globalend
}

alto = \relative c' {
  \global
  r4 d2. |
  cis4 e d cis |
  a2 r4 d8 c |
  h4 d2 d4 ~ |
  d2 r4 d8 c |
  
  h4 d2. ~ |
  d2 r4 cis8 d |
  e4 d cis d8 e |
  d2 r4 fis4 |
  g cis, d e |
  d2 r4 d |
  
  e1 |
  e8 d d4 r d4 ~ |
  d2. cis4 |
  h4 fis' 2 d4 |
  d2 cis4 h8 cis8 |
  a2 r
  \globalend
}

tenor = \relative c {
  \global
  r4 fis2 g8 fis |
  a4 h2 a8 g8 |
  fis2 r4 g8 a |
  g4 ~ g2 fis8 g |
  fis8 a fis4 r4 g8 a8 |
  
  g4 ~ g h a8 g |
  g4 fis r g8 fis |
  e2 ~ e4 a |
  a2 r4 d |
  a1 |
  a2 r4 a4 |
  
  ais2. h8 cis |
  cis h h4 r g8 eis |
  fis2. e4 |
  d4 h' a gis |
  fis2. g4 |
  fis2 r |
  \globalend
}

bass = \relative c {
  \global
  r4 d2. |
  a4 e'2 a,4 |
  d2 r4 e8 fis |
  g4 h,2 d8 g, |
  d'2 r4 e8 fis |
  
  g4 h, g2 ~ |
  g8 h d4 r e8 d |
  cis4 h a h8 cis |
  d2 r4 d4 |
  e4 a, h  cis |
  d2 r4 d |
  
  cis2 fis |
  fis8 g g4 r g,8 gis |
  a2. ais4 |
  h2. e4 |
  a,2. ~ a4 |
  d2 r |
  \globalend
}

verseOne = \lyricmode {
  \set stanza = "1."
  Kde do -- mov |
  můj, kde do -- mov |
  můj? Vo -- da |
  hu -- čí po lu -- |
  či -- nách, bo -- ry |
  
  šu -- mí po ska -- |
  li -- nách, v_sa -- dě |
  stkví se ja -- ra |
  květ, zem -- ský |
  ráj to na po -- |
  hled! A to |
  
  je ta krá -- sná |
  ze -- mě, ze -- mě |
  če -- ská, do -- mov |
  můj, ze -- mě |
  če -- ská, do -- mov |
  můj!
  
}

verseTwo = \lyricmode {
  \set stanza = "2."
  Kde do -- mov |
  můj, kde do -- mov |
  můj? V_kra -- ji |
  znáš -- -li Bo -- hu |
  mi -- lém, du -- še |
  
  út -- lé v_tě -- le |
  či -- lém, my -- sl |
  jas -- nou, vznik a |
  zdar, a tu |
  sí -- lu vzdo -- ru |
  zmar? To je |
  
  Če -- chů sla -- vné |
  plé -- mě, me -- zi |
  Če -- chy, do -- mov |
  můj, me -- zi |
  Če -- chy, do -- mov |
  můj!
  
}

%% http://lsr.dsi.unimi.it/LSR/Item?id=336
%% see also http://code.google.com/p/lilypond/issues/detail?id=1228

%% Usage:
%%   \new Staff \with {
%%     \override RestCollision.positioning-done = #merge-rests-on-positioning
%%   } << \somevoice \\ \othervoice >>
%% or (globally):
%%   \layout {
%%     \context {
%%       \Staff
%%       \override RestCollision.positioning-done = #merge-rests-on-positioning
%%     }
%%   } 
%%
%% Limitations:
%% - only handles two voices
%% - does not handle multi-measure/whole-measure rests

#(define (rest-score r)
  (let ((score 0)
	(yoff (ly:grob-property-data r 'Y-offset))
	(sp (ly:grob-property-data r 'staff-position)))
    (if (number? yoff)
	(set! score (+ score 2))
	(if (eq? yoff 'calculation-in-progress)
	    (set! score (- score 3))))
    (and (number? sp)
	 (<= 0 2 sp)
	 (set! score (+ score 2))
	 (set! score (- score (abs (- 1 sp)))))
    score))

#(define (merge-rests-on-positioning grob)
  (let* ((can-merge #f)
	 (elts (ly:grob-object grob 'elements))
	 (num-elts (and (ly:grob-array? elts)
			(ly:grob-array-length elts)))
	 (two-voice? (= num-elts 2)))
    (if two-voice?
	(let* ((v1-grob (ly:grob-array-ref elts 0))
	       (v2-grob (ly:grob-array-ref elts 1))
	       (v1-rest (ly:grob-object v1-grob 'rest))
	       (v2-rest (ly:grob-object v2-grob 'rest)))
	  (and
	   (ly:grob? v1-rest)
	   (ly:grob? v2-rest)	     	   
	   (let* ((v1-duration-log (ly:grob-property v1-rest 'duration-log))
		  (v2-duration-log (ly:grob-property v2-rest 'duration-log))
		  (v1-dot (ly:grob-object v1-rest 'dot))
		  (v2-dot (ly:grob-object v2-rest 'dot))
		  (v1-dot-count (and (ly:grob? v1-dot)
				     (ly:grob-property v1-dot 'dot-count -1)))
		  (v2-dot-count (and (ly:grob? v2-dot)
				     (ly:grob-property v2-dot 'dot-count -1))))
	     (set! can-merge
		   (and 
		    (number? v1-duration-log)
		    (number? v2-duration-log)
		    (= v1-duration-log v2-duration-log)
		    (eq? v1-dot-count v2-dot-count)))
	     (if can-merge
		 ;; keep the rest that looks best:
		 (let* ((keep-v1? (>= (rest-score v1-rest)
				      (rest-score v2-rest)))
			(rest-to-keep (if keep-v1? v1-rest v2-rest))
			(dot-to-kill (if keep-v1? v2-dot v1-dot)))
		   ;; uncomment if you're curious of which rest was chosen:
		   ;;(ly:grob-set-property! v1-rest 'color green)
		   ;;(ly:grob-set-property! v2-rest 'color blue)
		   (ly:grob-suicide! (if keep-v1? v2-rest v1-rest))
		   (if (ly:grob? dot-to-kill)
		       (ly:grob-suicide! dot-to-kill))
		   (ly:grob-set-property! rest-to-keep 'direction 0)
		   (ly:rest::y-offset-callback rest-to-keep)))))))
    (if can-merge
	#t
	(ly:rest-collision::calc-positioning-done grob))))


\score {
  \new PianoStaff <<
    \new Staff = "horni" \with {
      midiInstrument = "acoustic grand"
      \override RestCollision.positioning-done = #merge-rests-on-positioning
    } <<
      \new Voice = "soprano" { \voiceOne \soprano }
      \new Voice = "alto" { \voiceTwo \alto }
    >>
    \new Lyrics \with {
      \override VerticalAxisGroup #'staff-affinity = #CENTER
      alignAboveContext = "horni"
    } \lyricsto "soprano" \verseOne
    \new Lyrics \with {
      \override VerticalAxisGroup #'staff-affinity = #CENTER
      alignAboveContext = "horni"
    } \lyricsto "soprano" \verseTwo
    \new Staff \with {
      midiInstrument = "acoustic grand"
      \override RestCollision.positioning-done = #merge-rests-on-positioning
    } <<
      \clef bass
      \new Voice = "tenor" { \voiceOne \tenor }
      \new Voice = "bass" { \voiceTwo \bass }
    >>
  >>
  \layout {}
}

\score {
  \unfoldRepeats
  \new PianoStaff <<
    \new Staff \with {
      midiInstrument = "acoustic grand"
      \override RestCollision.positioning-done = #merge-rests-on-positioning
    } <<
      \new Voice = "soprano" { \voiceOne \soprano }
      \new Voice = "alto" { \voiceTwo \alto }
    >>
    \new Lyrics \with {
      \override VerticalAxisGroup #'staff-affinity = #CENTER
    } \lyricsto "soprano" \verseOne
    \new Staff \with {
      midiInstrument = "acoustic grand"
      \override RestCollision.positioning-done = #merge-rests-on-positioning
    } <<
      \clef bass
      \new Voice = "tenor" { \voiceOne \tenor }
      \new Voice = "bass" { \voiceTwo \bass }
    >>
  >>
  \midi {}
}