LYFILES=$(wildcard *.ly)$                                                    
TARGETS=$(patsubst %.ly,%.pdf,$(LYFILES))

all: $(TARGETS)

%.pdf: %.ly
	lilypond $<

