# Paths

LIBS=-L/usr/local/lib/ -lboost_system -lboost_filesystem -lopencv_core -lopencv_imgproc -lopencv_video -lopencv_highgui
INCLUDES=-I/usr/local/include/ -I evgOpencvUtilities/include

CPPFLAGS=-O2

all: bin/checkVideo



bin/checkVideo: build/checkVideo.o build/mediaLoadSave.o
	g++ -o bin/checkVideo build/checkVideo.o build/mediaLoadSave.o $(LIBS)



build/mediaLoadSave.o: evgOpencvUtilities/src/mediaLoadSave.cpp evgOpencvUtilities/include/mediaLoadSave.h
	g++ -c -o build/mediaLoadSave.o $(CPPFLAGS) evgOpencvUtilities/src/mediaLoadSave.cpp $(INCLUDES)

build/checkVideo.o: checkVideo/main.cpp evgOpencvUtilities/include/mediaLoadSave.h
	g++ -c -o build/checkVideo.o $(CPPFLAGS) checkVideo/main.cpp $(INCLUDES)