rootPath = ./
include ./include.mk

libSources = impl/*.c
libHeaders = inc/*.h
libTests = tests/*.c

signalAlignDependencies =  ${basicLibsDependencies}
signalAlignLib = ${basicLibs}

all : sL bD ${libPath}/signalAlignLib.a ${signalAlignBin}/signalAlignLibTests ${signalAlignBin}/compareDistributions \
      ${signalAlignBin}/signalMachine ${signalAlignBin}/runSignalAlign ${signalAlignBin}/signalAlignLib.py ${signalAlignBin}/zayante ${signalAlignBin}/bonnyDoon \
      ${signalAlignBin}/buildHdpUtil ${signalAlignBin}/trainModels ${signalAlignBin}/hdp_pipeline ${signalAlignBin}/testSignalAlign
	#cd externalTools && make all

clean :
	if [ -d ${signalAlignBin} ]; then rm -r ${signalAlignBin}; fi
	#rm -r ${signalAlignBin}
	rm -f ${libPath}/signalAlignLib.a
	cd externalTools && make clean

signalAlignLib : ${libPath}/signalAlignLib.a

sL :
	cd sonLib && make

bD :
	mkdir -v -p ${rootPath}bin

test :
	#cd ${signalAlignBin} && ./signalAlignLibTests
	cd ${signalAlignBin} && ./testSignalAlign
	#cd ${binPath} && ./sonLibTests

${signalAlignBin}/compareDistributions : compareDistributions.c ${libPath}/signalAlignLib.a ${signalAlignDependencies}
	${cxx} ${cflags} -I inc -I${libPath} -o ${signalAlignBin}/compareDistributions compareDistributions.c ${libPath}/signalAlignLib.a ${signalAlignLib}

${signalAlignBin}/signalAlignLibTests : ${libTests} tests/*.h ${libPath}/signalAlignLib.a ${signalAlignDependencies}
	${cxx} ${cflags} -I inc -I${libPath} -Wno-error -o ${signalAlignBin}/signalAlignLibTests ${libTests} ${libPath}/signalAlignLib.a ${signalAlignLib}

${signalAlignBin}/signalMachine : signalMachine.c ${libPath}/signalAlignLib.a ${signalAlignDependencies}
	${cxx} ${cflags} -I inc -I${libPath} signalMachineUtils.h -o ${signalAlignBin}/signalMachine signalMachine.c ${libPath}/signalAlignLib.a ${signalAlignLib} signalMachineUtils.c

${signalAlignBin}/buildHdpUtil : buildHdpUtil.c ${libPath}/signalAlignLib.a ${signalAlignDependencies}
	${cxx} ${cflags} -I inc -I${libPath} -o ${signalAlignBin}/buildHdpUtil buildHdpUtil.c ${libPath}/signalAlignLib.a ${signalAlignLib}

${signalAlignBin}/runSignalAlign : ${rootPath}scripts/runSignalAlign.py
	cp ${rootPath}scripts/runSignalAlign.py ${signalAlignBin}/runSignalAlign
	chmod +x ${signalAlignBin}/runSignalAlign

${signalAlignBin}/trainModels : ${rootPath}scripts/trainModels.py
	cp ${rootPath}scripts/trainModels.py ${signalAlignBin}/trainModels
	chmod +x ${signalAlignBin}/trainModels

${signalAlignBin}/hdp_pipeline : ${rootPath}scripts/hdp_pipeline.py
	cp ${rootPath}scripts/hdp_pipeline.py ${signalAlignBin}/hdp_pipeline
	chmod +x ${signalAlignBin}/hdp_pipeline

${signalAlignBin}/testSignalAlign : ${rootPath}scripts/testSignalAlign.py
	cp ${rootPath}scripts/testSignalAlign.py ${signalAlignBin}/testSignalAlign
	chmod +x ${signalAlignBin}/testSignalAlign

${signalAlignBin}/zayante : ${rootPath}scripts/zayante.py
	cp ${rootPath}scripts/zayante.py ${signalAlignBin}/zayante
	chmod +x ${signalAlignBin}/zayante

${signalAlignBin}/bonnyDoon : ${rootPath}scripts/bonnyDoon.py
	cp ${rootPath}scripts/bonnyDoon.py ${signalAlignBin}/bonnyDoon
	chmod +x ${signalAlignBin}/bonnyDoon


${signalAlignBin}/signalAlignLib.py : ${rootPath}scripts/signalAlignLib.py
	cp ${rootPath}scripts/signalAlignLib.py ${signalAlignBin}/signalAlignLib.py
	#cp ${rootPath}scripts/errorCorrectionLib.py ${signalAlignBin}/errorCorrectionLib.py
	cp ${rootPath}scripts/variantCallingLib.py ${signalAlignBin}/variantCallingLib.py
	cp ${rootPath}scripts/alignmentAnalysisLib.py ${signalAlignBin}/alignmentAnalysisLib.py

${libPath}/signalAlignLib.a : ${libSources} ${libHeaders} ${stBarDependencies}
	${cxx} ${cflags} -I inc -I ${libPath}/ -c ${libSources}
	ar rc signalAlignLib.a *.o
	ranlib signalAlignLib.a
	rm *.o
	mv signalAlignLib.a ${libPath}/
	cp ${libHeaders} ${libPath}/
