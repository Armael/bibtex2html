#########################################
# Configuration part 
#########################################

# where to put executable files
BINDIR = /usr/local/bin

# where to install the man pages
MANDIR = /usr/local/man

#########################################
# End of configuration part
#########################################

MAJORVN=1
MINORVN=41

CAMLC    = ocamlc
CAMLCOPT = ocamlopt 
CAMLDEP  = ocamldep
ZLIBS    =
DEBUG    =
FLAGS    = $(ZLIBS) $(DEBUG)
PROFILE  =

STRLIB = -cclib -lstr

OBJS =  options.cmx latexmacros.cmx latexscan.cmx bbl_lexer.cmx \
	bibtex.cmx bibtex_lexer.cmx bibtex_parser.cmx \
	readbib.cmx expand.cmx bibfilter.cmx \
	html.cmx biboutput.cmx version.cmx translate.cmx \
	copying.cmx main.cmx

BIB2BIBOBJS = options.cmx bibtex.cmx bibtex_lexer.cmx \
        bibtex_parser.cmx readbib.cmx \
	latex_accents.cmx condition.cmx \
	condition_parser.cmx condition_lexer.cmx parse_condition.cmx \
	bibfilter.cmx \
	html.cmx biboutput.cmx version.cmx copying.cmx bib2bib.cmx

all: bibtex2html bib2bib

install:
	cp bibtex2html bib2bib $(BINDIR)
	cp bibtex2html.1 $(MANDIR)/man1/bibtex2html.1
	cp bibtex2html.1 $(MANDIR)/man1/bib2bib.1

local:
	cp bibtex2html bib2bib $$HOME/bin/$$OSTYPE

bibtex2html: $(OBJS)
	ocamlopt $(PROFILE) $(FLAGS) -o bibtex2html str.cmxa $(OBJS) $(STRLIB)
	strip bibtex2html

bibtex2html.byte: $(OBJS:.cmx=.cmo)
	ocamlc -use-runtime ~demons/bin/$(OSTYPE)/ocamlcustomrun \
		-o bibtex2html.byte str.cma $(OBJS:.cmx=.cmo)  

bibtex2html.static: $(OBJS)
	ocamlopt $(PROFILE) $(FLAGS) -o bibtex2html.static str.cmxa $(OBJS) $(STRLIB) -cclib "-L. -static"
	strip bibtex2html.static

bib2bib: $(BIB2BIBOBJS)
	ocamlopt $(PROFILE) $(FLAGS) -o bib2bib str.cmxa $(BIB2BIBOBJS) $(STRLIB)
	strip bib2bib

bib2bib.static: $(BIB2BIBOBJS)
	ocamlopt $(PROFILE) $(FLAGS) -o bib2bib.static str.cmxa $(BIB2BIBOBJS) $(STRLIB) -cclib "-L. -static"
	strip bib2bib.static

bib2bib.byte: $(BIB2BIBOBJS:.cmx=.cmo)
	ocamlc -use-runtime ~demons/bin/$(OSTYPE)/ocamlcustomrun \
		-o bib2bib.byte str.cma $(BIB2BIBOBJS:.cmx=.cmo) 

static:
	ln -sf /usr/lib/libncurses.a libcurses.a
	make bibtex2html.static bib2bib.static
	cp bibtex2html.static bib2bib.static $$HOME/bin/$$OSTYPE

bibtex_parser.mli bibtex_parser.ml: bibtex_parser.mly
	ocamlyacc bibtex_parser.mly

condition_parser.mli condition_parser.ml: condition_parser.mly
	ocamlyacc condition_parser.mly

version.ml: Makefile
	echo "let version = \""$(MAJORVN).$(MINORVN)"\"" > version.ml
	echo "let date = \""`date`"\"" >> version.ml

latexscan.ml: latexscan.mll
	ocamllex latexscan.mll

bibtex_lexer.ml: bibtex_lexer.mll
	ocamllex bibtex_lexer.mll



# export
########

NAME=bibtex2html-$(MAJORVN).$(MINORVN)

FTP = /users/demons/filliatr/ftp/ocaml/bibtex2html

SOURCEFILES = *.ml* Makefile .depend README COPYING GPL CHANGES manual.tex *.1

export: source doc linux solaris

move-olds:
	cp $(FTP)/bibtex2html* $(FTP)/olds

source: clean 
	mkdir -p export/$(NAME)
	cp $(SOURCEFILES) export/$(NAME)
	(cd export ; tar cf $(NAME).tar $(NAME) ; \
	gzip -f --best $(NAME).tar)
	cp README COPYING GPL CHANGES export/$(NAME).tar.gz $(FTP)

BINARY = bibtex2html-$(MAJORVN).$(MINORVN)-$(OSTYPE)

linux: clean binary

solaris:
	rmake sun-demons $(HOME)/soft/ocaml/bibtex clean binary

sunos4:
	rmake ??? $(HOME)/soft/ocaml/bibtex clean binary

BINARYFILES = README COPYING GPL bibtex2html bib2bib bibtex2html.1 bib2bib.1 

binary: bibtex2html bib2bib
	mkdir -p export/$(BINARY)
	cp $(BINARYFILES) export/$(BINARY)
	(cd export; tar czf $(BINARY).tar.gz $(BINARY))
	cp export/$(BINARY).tar.gz $(FTP)

AIX=bibtex2html-$(MAJORVN).$(MINORVN)-AIX

aix:
	mkdir -p export/$(AIX)
	cp $(BINARYFILES) export/$(AIX)
	(cd export; tar cf $(AIX).tar $(AIX); gzip --best $(AIX).tar)

# documentation
###############

WWW=/users/demons/filliatr/WWW/bibtex2html

doc: manual.ps manual.html
	gzip -c manual.ps > $(WWW)/doc/manual.ps.gz
	cp -f manual.html $(WWW)/doc

manual.ps: manual.tex
	latex manual && latex manual
	dvips manual.dvi -o manual.ps

manual.html: manual.tex
	hevea manual.tex

# generic rules :
#################

.SUFFIXES: .mli .ml .mll .cmi .cmo .cmx

.mli.cmi:
	$(CAMLC) -c $(FLAGS) $<

.ml.cmo:
	$(CAMLC) -c $(FLAGS) $<

.ml.o:
	$(CAMLCOPT) -c $(FLAGS) $<

.ml.cmx:
	$(CAMLCOPT) -c $(PROFILE) $(FLAGS) $<

.mll.ml:
	ocamllex $<

# clean and depend
##################

clean:
	rm -f *~ *.cm[iox] *.o 
	rm -f bibtex_lexer.ml bibtex_parser.ml bibtex_parser.mli 
	rm -f latexscan.ml bibtex2html bbl_lexer.ml
	rm -f bib2bib condition_parser.mli condition_parser.ml
	rm -f condition_lexer.ml manual.html
	rm -f bibtex2html.static bib2bib.static


depend .depend: \
	bibtex_lexer.ml bbl_lexer.ml \
	latexscan.ml latex_accents.ml \
	bibtex_parser.mli bibtex_parser.ml \
	condition_parser.mli condition_parser.ml \
	condition_lexer.ml
	rm -f .depend
	ocamldep $(ZLIBS) *.mli *.ml > .depend

include .depend

