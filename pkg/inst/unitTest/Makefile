# $Id: Makefile 32 2010-08-12 13:15:21Z mariotomo $

TOP=../..
PKG=${shell cd ${TOP};pwd}
SUITE=doSvUnit.R
R=R

all: inst xtest

xtest: inst test ## produces an output that can be used in emacs compilation buffer
	egrep "\*\*(FAILS|ERROR)\*\* in [^:]*" ${TOP}/tests/.output -o | cut -d\  -f 3- | xargs -I {} -n 1 grep -nF "{}" *.R

inst: # Install package
	cd ${TOP}/..;\
	${R} CMD INSTALL ${PKG}

test: # Run unit tests
	export RCMDCHECK=FALSE;\
	cd ${TOP}/tests;\
	${R} --vanilla --slave < ${SUITE} | grep . | tee .output;

cover: # compute unit tests coverage
	export RCMDCHECK=FALSE;\
	cd ${TOP}/tests;\
	${R} --vanilla --slave < ${SUITE}

## useful oneliner for quickly finding the testcases.
##
## for i in $(make 2>&1 | egrep "FAILURE in ([^:]*)" -o | cut -b 12-); do grep -n $i *.R ; done
##
