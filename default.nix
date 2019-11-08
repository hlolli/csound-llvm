{ stdenv, callPackage, clang, clangStdenv, cmake, fetchFromGitHub, llvm,
  bison, flex }:

let libsndfile-llvm = callPackage ./libsndfile {};

in clangStdenv.mkDerivation rec {
  version = "353bf7c44c41e8615154d407de4a5138a7e572ab";
  name = "csound-llvm-${version}";
  buildInputs = [ cmake libsndfile-llvm flex llvm bison];
  NIX_CFLAGS_COMPILE = "-I$sourceRoot/include -O1";
  patches = [
    ./001_imports.patch
    ./002_spin_lock.patch
    ./003_mutex.patch
    ./004-stjmp.patch
  ];
  hardeningDisable = [ "all" ];
  src = fetchFromGitHub {
    owner = "csound";
    repo = "csound";
    rev = "${version}";
    sha256 = "13i2inhmv7kwjx82px621g5akcwldfn08pci1ym8c4s2x3qn6wf0";
  };
  postUnpack = ''
    rm $sourceRoot/CMakeLists.txt
    cp ${ ./CMakeLists.txt } $sourceRoot/CMakeLists.txt
  '';
  postPatch = ''
    substituteInPlace Opcodes/ftsamplebank.cpp \
      --replace std::string string
    substituteInPlace util/CMakeLists.txt \
      --replace 'add_dependency_to_framework(stdutil ''${LIBSNDFILE_LIBRARY})' ""
    substituteInPlace InOut/CMakeLists.txt \
      --replace 'check_deps(USE_ALSA ALSA_HEADER ALSA_LIBRARY PTHREAD_LIBRARY)' \
                'check_deps(USE_ALSA ALSA_HEADER ALSA_LIBRARY)'
    # prevent sanitize from being defined twive
    substituteInPlace Engine/csound_orc_compile.c --replace \
      "#ifdef EMSCRIPTEN" "#ifndef EMSCRIPTEN"
  '';
  configurePhase = "true";
  buildPhase = ''
    echo "#define USE_DOUBLE" > include/float-version.h
    mkdir build && cd build
    cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DLIBSNDFILE_LIBRARY=${libsndfile-llvm}/lib/libsndfile.bc \
      -DSNDFILE_H_PATH=${libsndfile-llvm}/include \
      -DLLVM_DIR=${llvm}/lib/cmake/llvm \
      -DBUILD_PYTHON_OPCODES=0 \
      -DHAVE_SPRINTF_L=0 \
      ../

    VERBOSE=1 make -j6 csound64
    mkdir bc && cd bc && ar x ../libcsound64.a

    for j in *.o; do mv $j ''${j//\.c\.o/".bc"} || mv $j ''${j//\.cpp\.o/".bc"}; done

    llvm-link -o csound.bc *.bc ${libsndfile-llvm}/lib/libsndfile.bc
    # opt csound-unopt.bc -O1 -o csound.bc
    cd ../../
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp build/bc/csound.bc $out/lib
    cp -rf include $out
  '';
  dontFixup = true;
  dontStrip = true;
}
