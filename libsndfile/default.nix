{ stdenv, clang, clangStdenv, cmake, fetchFromGitHub, llvm }:

clangStdenv.mkDerivation {
  name = "libsndfile-llvm";
  src = fetchFromGitHub {
    owner = "erikd";
    repo = "libsndfile";
    rev = "d5531723a07ffbf7717c141b792dba8e1fbcb1c5";
    sha256 = "0jvi14679kl0z1f9wyihwwgkk4vxgippmwzqqkfbiwf8hlpg72b6";
  };
  buildInputs = [ llvm cmake ];
  hardeningDisable = [ "fortify" ];
  phases = ["unpackPhase" "buildPhase" "installPhase"];
  buildPhase = ''
    mkdir build
    export CFLAGS="-O1 -emit-llvm -I./src -c"
    export CXXFLAGS="-O1 -emit-llvm -c"
    mv src/sndfile.h.in src/sndfile.h
    cp ${ ./configLinux64.h } src/config.h
    substituteInPlace src/sndfile.h \
      --replace @SF_COUNT_MAX@ 0x7FFFFFFFFFFFFFFFLL \
      --replace @TYPEOF_SF_COUNT_T@ int64_t

    clang $CFLAGS src/common.c -o build/common.bc
    clang $CFLAGS src/command.c -o build/command.bc
    clang $CFLAGS src/chanmap.c -o build/chanmap.bc
    clang $CFLAGS src/chunk.c -o build/chunk.bc
    clang $CFLAGS src/dwvw.c -o build/dwvw.bc
    clang $CFLAGS src/file_io.c -o build/file_io.bc
    clang $CFLAGS src/id3.c -o build/id3.bc
    clang $CFLAGS src/cart.c -o build/cart.bc
    clang $CFLAGS src/pcm.c -o build/pcm.bc
    clang $CFLAGS src/strings.c -o build/strings.bc
    clang $CFLAGS src/audio_detect.c -o build/audio_detect.bc
    clang $CFLAGS src/ulaw.c -o build/ulaw.bc
    clang $CFLAGS src/G72x/g72x.c -o build/G72x.bc
    clang $CFLAGS src/G72x/g723_16.c -o build/G723_16.bc
    clang $CFLAGS src/G72x/g723_24.c -o build/G723_24.bc
    clang $CFLAGS src/G72x/g723_40.c -o build/G723_40.bc
    clang $CFLAGS src/G72x/g721.c -o build/G721.bc
    clang $CFLAGS src/gsm610.c -o build/gsm610.bc
    clang $CFLAGS src/GSM610/gsm_create.c -o build/gsm_create.bc
    clang $CFLAGS src/GSM610/gsm_decode.c -o build/gsm_decode.bc
    clang $CFLAGS src/GSM610/gsm_destroy.c -o build/gsm_destroy.bc
    clang $CFLAGS src/GSM610/gsm_encode.c -o build/gsm_encode.bc
    clang $CFLAGS src/GSM610/gsm_option.c -o build/gsm_option.bc
    clang $CFLAGS src/GSM610/code.c -o build/code.bc
    clang $CFLAGS src/GSM610/preprocess.c -o build/preprocess.bc
    clang $CFLAGS src/GSM610/lpc.c -o build/lpc.bc
    clang $CFLAGS src/GSM610/add.c -o build/add.bc
    clang $CFLAGS src/GSM610/long_term.c -o build/long_term.bc
    clang $CFLAGS src/GSM610/short_term.c -o build/short_term.bc
    clang $CFLAGS src/GSM610/table.c -o build/table.bc
    clang $CFLAGS src/GSM610/rpe.c -o build/rpe.bc
    clang $CFLAGS src/GSM610/decode.c -o build/decode.bc
    clang $CFLAGS src/ALAC/alac_decoder.c -o build/alac_decoder.bc
    clang $CFLAGS src/ALAC/alac_encoder.c -o build/alac_encoder.bc
    clang $CFLAGS src/ALAC/ag_dec.c -o build/ag_dec.bc
    clang $CFLAGS src/ALAC/ag_enc.c -o build/ag_enc.bc
    clang $CFLAGS src/ALAC/ALACBitUtilities.c -o build/ALACBitUtilities.bc
    clang $CFLAGS src/ALAC/matrix_dec.c -o build/matrix_dec.bc
    clang $CFLAGS src/ALAC/matrix_enc.c -o build/matrix_enc.bc
    clang $CFLAGS src/ALAC/dp_dec.c -o build/dp_dec.bc
    clang $CFLAGS src/ALAC/dp_enc.c -o build/dp_enc.bc
    clang $CFLAGS src/broadcast.c -o build/broadcast.bc
    clang $CFLAGS src/alaw.c -o build/alaw.bc
    clang $CFLAGS src/float32.c -o build/float32.bc
    clang $CFLAGS src/double64.c -o build/double64.bc
    clang $CFLAGS src/sndfile.c -o build/sndfile.bc
    clang $CFLAGS src/aiff.c -o build/aiff.bc
    clang $CFLAGS src/au.c -o build/au.bc
    clang $CFLAGS src/alac.c -o build/alac.bc
    clang $CFLAGS src/avr.c -o build/avr.bc
    clang $CFLAGS src/caf.c -o build/caf.bc
    clang $CFLAGS src/dither.c -o build/dither.bc
    clang $CFLAGS src/dwd.c -o build/dwd.bc
    clang $CFLAGS src/flac.c -o build/flac.bc
    clang $CFLAGS src/g72x.c -o build/g72x.bc
    clang $CFLAGS src/htk.c -o build/htk.bc
    clang $CFLAGS src/macos.c -o build/macos.bc
    clang $CFLAGS src/ima_adpcm.c -o build/ima_adpcm.bc
    clang $CFLAGS src/ima_oki_adpcm.c -o build/ima_oki_adpcm.bc
    clang $CFLAGS src/nms_adpcm.c -o build/nms_adpcm.bc
    clang $CFLAGS src/ms_adpcm.c -o build/ms_adpcm.bc
    clang $CFLAGS src/vox_adpcm.c -o build/vox_adpcm.bc
    clang $CFLAGS src/ircam.c -o build/ircam.bc
    clang $CFLAGS src/mat4.c -o build/mat4.bc
    clang $CFLAGS src/mat5.c -o build/mat5.bc
    clang $CFLAGS src/nist.c -o build/nist.bc
    clang $CFLAGS src/paf.c -o build/paf.bc
    clang $CFLAGS src/pvf.c -o build/pvf.bc
    clang $CFLAGS src/raw.c -o build/raw.bc
    clang $CFLAGS src/rx2.c -o build/rx2.bc
    clang $CFLAGS src/sd2.c -o build/sd2.bc
    clang $CFLAGS src/sds.c -o build/sds.bc
    clang $CFLAGS src/svx.c -o build/svx.bc
    clang $CFLAGS src/txw.c -o build/txw.bc
    clang $CFLAGS src/voc.c -o build/voc.bc
    clang $CFLAGS src/wve.c -o build/wve.bc
    clang $CFLAGS src/w64.c -o build/w64.bc
    clang $CFLAGS src/wavlike.c -o build/wavlike.bc
    clang $CFLAGS src/wav.c -o build/wav.bc
    clang $CFLAGS src/xi.c -o build/xi.bc
    clang $CFLAGS src/mpc2k.c -o build/mpc2k.bc
    clang $CFLAGS src/rf64.c -o build/rf64.bc
    clang $CFLAGS src/ogg.c -o build/ogg.bc
    clang $CFLAGS src/ogg_vorbis.c -o build/ogg_vorbis.bc
    clang $CFLAGS src/ogg_speex.c -o build/ogg_speex.bc
    clang $CFLAGS src/ogg_pcm.c -o build/ogg_pcm.bc
    clang $CFLAGS src/ogg_opus.c -o build/ogg_opus.bc
    clang $CFLAGS src/ogg_vcomment.c -o build/ogg_vcomment.bc

    llvm-link -o libsndfile.bc build/*
  '';

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/include
    cp src/sndfile.h* $out/include
    cp libsndfile.bc $out/lib
  '';
  dontFixup = true;
  dontStrip = true;
}
