Poor Man's ldd
========


# Poor mans ldd (pm-ldd) v.0.1
#
# this script for msys/mingw takes a PE binary or shared library
# as argument and recursively checks which other shared libraries it 
# depends on. It then outputs the whole list in a fashion which makes
# it easy to copy all dependencies next to a binary
# It does not output shared libraries present in the WINDOWS directory.
# It is not optimized and might check the same file multiple times.
#
# Example:
# $ pm-ldd /mingw/local/bin/iconv.exe
#  /mingw/local/bin/libiconv-2.dll
#  /mingw/local/bin/libintl-8.dll
#
#
