\version "2.18.2"
\include "deutsch.ly"

\header {
  title = "Nad Tatrou sa blýska"
  composer = "lidová / Ján Matúška"
}
#(set-global-staff-size 25 )

global = {
  \time 2/4
  \key a \major
  \tempo 4=100
}

globalend = {
  \bar "|."
}

soprano = \relative c' {
  \global
  fis8 gis8 a4 |
  a a8 a |
  gis8 a h a |
  gis4 fis |
  a8 h cis4 |
  cis cis8 cis |
  h cis d cis |
  
  h4 a |
  \repeat volta 2 {
    cis8 cis cis4 |
    h4 h8 h |
    h8 cis h4 |
    a a8 a |
    gis a h a |
    gis4 fis |
  }
}

alto = \relative c' {
  \global
  cis8 eis fis4 |
  fis fis8 e |
  fis2 |
  fis8 eis cis4 |
  fis8 gis a4 |
  cis,4 fis8 e |
  fis2 ~ |
  
  fis8 e e4 |
  \repeat volta 2 {
    e2 |
    e8 fis e fis |
    eis4 fis8 gis |
    fis4 fis8 e |
    fis2 ~ |
    fis8 eis cis4 |
  }
}

tenor = \relative c' {
  \global
  a8 cis cis4 |
  cis d8 a |
  d cis d cis |
  d cis a4 |
  cis8 e e4 |
  a,4 a |
  a2 ~ |
  
  a8 gis8 cis4 |
  \repeat volta 2 {
    a2 |
    gis8 a gis4 |
    gis cis |
    cis d8 a |
    d cis d cis |
    d cis a4 |
  }
}

bass = \relative c {
  \global
  fis8 cis fis4 |
  fis8 e d cis |
  h a fis a |
  h cis fis4 |
  fis8 e a gis |
  fis e d cis |
  d cis h cis |
  
  d e a4 |
  \repeat volta 2 {
    a,4 cis8 a |
    e'4. d8 |
    cis4 dis8 eis |
    fis8 e d cis |
    h a gis a |
    h cis fis4 |
  }
  
  
}

verseOne = \lyricmode {
  \set stanza = "1."
  Nad Ta -- trou |
  sa blý -- ska, |
  hro -- my di -- vo |
  bi -- jú, |
  nad Ta -- trou |
  sa blý -- ska, |
  hro -- my di -- vo |
  bi -- jú, |
  \repeat volta 2 {
    za -- stav -- me |
    ich bra -- tia, |
    veď sa o -- |
    ny ztra -- tia, |
    Slo -- vá -- ci o -- |
    ži -- jú.
  }
}

verseTwo = \lyricmode {
  \set stanza = "2."
  To Slo -- ven -- |
  sko na -- še |
  pos -- iaľ tvr -- do |
  spa -- lo, |
  to Slo -- ven -- |
  sko na -- še |
  pos -- iaĺ tvr -- do |
  spa -- lo. |
  \repeat volta 2 {
    a -- le bles -- |
    ky hro -- mu |
    vzbu -- dzu -- jú |
    ho k_to -- mu, |
    a -- by sa pre -- |
    bra -- lo.
  }
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