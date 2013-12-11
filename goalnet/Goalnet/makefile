# Paths

LIBS=-L/usr/local/lib/ -lboost_system -lboost_filesystem -lopencv_core -lopencv_imgproc -lopencv_video -lopencv_highgui
INCLUDES=-I/usr/local/include/ -I evgOpencvUtilities/include -I src

CPPFLAGS=-O2

all: bin/checkVideo bin/InVideo bin/InImage bin/writeSharpness



bin/checkVideo: build/checkVideo.o build/mediaLoadSave.o
	g++ -o bin/checkVideo build/checkVideo.o build/mediaLoadSave.o $(LIBS)

bin/writeSharpness: build/writeSharpness.o build/mediaLoadSave.o
	g++ -o bin/writeSharpness build/writeSharpness.o build/mediaLoadSave.o $(LIBS)

bin/InVideo: build/InVideo.o build/mediaLoadSave.o build/Core.o
	g++ -o bin/InVideo build/InVideo.o build/mediaLoadSave.o build/Core.o $(LIBS)

bin/InImage: build/InImage.o build/mediaLoadSave.o build/Core.o
	g++ -o bin/InImage build/InImage.o build/mediaLoadSave.o build/Core.o $(LIBS)



build/mediaLoadSave.o: evgOpencvUtilities/src/mediaLoadSave.cpp evgOpencvUtilities/include/mediaLoadSave.h
	g++ -c -o build/mediaLoadSave.o $(CPPFLAGS) evgOpencvUtilities/src/mediaLoadSave.cpp $(INCLUDES)

build/checkVideo.o: checkVideo/main.cpp evgOpencvUtilities/include/mediaLoadSave.h
	g++ -c -o build/checkVideo.o $(CPPFLAGS) checkVideo/main.cpp $(INCLUDES)

build/writeSharpness.o: writeSharpness/main.cpp evgOpencvUtilities/include/mediaLoadSave.h
	g++ -c -o build/writeSharpness.o $(CPPFLAGS) writeSharpness/main.cpp $(INCLUDES)

build/InVideo.o: InVideo/main.cpp evgOpencvUtilities/include/mediaLoadSave.h src/Core.h
	g++ -c -o build/InVideo.o $(CPPFLAGS) InVideo/main.cpp $(INCLUDES)

build/InImage.o: InImage/main.cpp evgOpencvUtilities/include/mediaLoadSave.h src/Core.h
	g++ -c -o build/InImage.o $(CPPFLAGS) InImage/main.cpp $(INCLUDES)

build/Core.o: src/Core.cpp evgOpencvUtilities/include/mediaLoadSave.h src/Core.h
	g++ -c -o build/Core.o $(CPPFLAGS) src/Core.cpp $(INCLUDES)


