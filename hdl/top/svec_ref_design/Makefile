SIM   =../../testbench/include
DOC   =../../../doc/manual
SW    =../../../software/include/hw

SOURCES = $(wildcard *.cheby)
TARGETS = $(SOURCES:.cheby=.vhd)

all: $(TARGETS)

.PHONY: $(TARGETS)

$(TARGETS): %.vhd : %.cheby
	@echo "\n\033[34m\033[1m-> Processing file $<\033[0m"
	@cheby -i $< --gen-hdl=$@
	@cheby -i $< \
		--gen-doc=$(DOC)/$(@:.vhd=.html) \
	        --gen-consts=$(SIM)/$(@:.vhd=.v) \
		--gen-c=$(SW)/$(@:.vhd=.h)
