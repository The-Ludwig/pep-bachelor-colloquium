# TEXTARGET is the output filename TEXTSOURCE is input. Simply change these if you want to compile one .tex file 
TEXTARGET:=2022-11.pdf
TEXSOURCE:=main.tex

inputs := $(wildcard data/*.tex)
outputs := $(patsubst data/%.tex,build/%.pdf,$(inputs))

all: $(outputs)

# $(TEXDEPEND): a_plot.py data.txt | build

TEXOPTIONS := -lualatex \
		--output-directory=build \
		--interaction=nonstopmode \
		--halt-on-error \
		--use-make \
		--synctex=1 \

TEXPREFIX := TEXINPUTS=build: \
	BIBINPUTS=build: \
	max_print_line=1048576 \


clean:
	rm -rf build

build:
	mkdir -p build

# Use this to work on tex-document, it will be updated continuesly by latexmk
work: FORCE | build
	$(TEXPREFIX) latexmk -pvc $(TEXOPTIONS) -jobname=$(basename $(TEXTARGET)) -usepretex='\input{data/$(basename $(TEXTARGET)).tex}' $(TEXSOURCE)

build/%.pdf: FORCE | build
	$(TEXPREFIX) latexmk $(TEXOPTIONS) -jobname=$(basename $(@F)) -usepretex='\input{data/$(basename $(@F)).tex}' $(TEXSOURCE)

FORCE:

.PHONY: all clean FORCE build
