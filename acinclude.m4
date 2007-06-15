dnl setup codeblocks for current target
dnl copied and adapted from Ogre3D (www.ogre3d.org)

AC_DEFUN([CODEBLOCKS_GET_PLATFORM],
[CODEBLOCKS_PLATFORM=gtk
 AC_ARG_WITH(platform, 
             AC_HELP_STRING([--with-platform=PLATFORM],
                            [the platform to build, win32, macosx or gtk(default)]),
             CODEBLOCKS_PLATFORM=$withval,
             CODEBLOCKS_PLATFORM=gtk)

 
  PLATFORM_CFLAGS=""
  PLATFORM_LIBS=""

  dnl Do the extra checks per type here
  case $CODEBLOCKS_PLATFORM in 
    gtk)
      PLATFORM_CFLAGS="-I/usr/X11R6/include"
      PLATFORM_LIBS="-L/usr/X11R6/lib -lX11"
    ;;
    win32)
      PLATFORM_CFLAGS=""
      PLATFORM_LIBS="-lgdi32"
    ;;
    macosx)
      PLATFORM_CFLAGS=""
      PLATFORM_LIBS=""
    ;;
  esac

  AC_SUBST(PLATFORM_CFLAGS)
  AC_SUBST(PLATFORM_LIBS)
  AC_SUBST(CODEBLOCKS_PLATFORM)
])

AC_DEFUN([CODEBLOCKS_SETUP_FOR_TARGET],
[case $host in
*-*-cygwin* | *-*-mingw*)
	AC_SUBST(SHARED_FLAGS, "-shared -no-undefined -Xlinker --export-all-symbols")
	AC_SUBST(PLUGIN_FLAGS, "-shared -no-undefined -avoid-version")
	AC_CHECK_TOOL(RC, windres)
	nt=true
;;
*-*-darwin*) dnl including macosx
    AC_SUBST(SHARED_FLAGS, "-dynamic")
    AC_SUBST(PLUGIN_FLAGS, "-bundle -avoid-version")
    darwin=true
;;
 *) dnl default to standard linux
	AC_SUBST(SHARED_FLAGS, "-shared")
	AC_SUBST(PLUGIN_FLAGS, "-shared -avoid-version")
    linux=true
;;
esac
dnl you must arrange for every AM_conditional to run every time configure runs
AM_CONDITIONAL(CODEBLOCKS_NT, test x$nt = xtrue)
AM_CONDITIONAL(CODEBLOCKS_LINUX, test x$linux = xtrue)
AM_CONDITIONAL(CODEBLOCKS_DARWIN, test x$darwin = xtrue )
])

dnl check what settings to enable
AC_DEFUN([CODEBLOCKS_ENABLE_SETTINGS],
[
AC_MSG_CHECKING(whether to enable debugging)
debug_default="no"
AC_ARG_ENABLE(debug, [AC_HELP_STRING([--enable-debug], [turn on debugging (default is OFF)])],,
                       enable_debug=$debug_default)
if test "x$enable_debug" = "xyes"; then
         CFLAGS="-g -DDEBUG $CFLAGS"
         CXXFLAGS="-g -DDEBUG $CXXFLAGS"
	AC_MSG_RESULT(yes)
else
	CFLAGS="-O2 -ffast-math $CFLAGS"
	CXXFLAGS="-O2 -ffast-math $CXXFLAGS"
	AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(whether to build the source formatter plugin)
astyle_default="yes"
AC_ARG_ENABLE(source-formatter, [AC_HELP_STRING([--enable-source-formatter], [build the source formatter plugin (default YES)])],,
                       enable_astyle=$astyle_default)
AM_CONDITIONAL([BUILD_ASTYLE], [test "x$enable_astyle" = "xyes"])
if test "x$enable_astyle" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(whether to build the autosave plugin)
autosave_default="yes"
AC_ARG_ENABLE(autosave, [AC_HELP_STRING([--enable-autosave], [build the autosave plugin (default YES)])],,
                       enable_autosave=$autosave_default)
AM_CONDITIONAL([BUILD_AUTOSAVE], [test "x$enable_autosave" = "xyes"])
if test "x$enable_autosave" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(whether to build the class wizard plugin)
cw_default="yes"
AC_ARG_ENABLE(class-wizard, [AC_HELP_STRING([--enable-class-wizard], [build the class wizard plugin (default YES)])],,
                       enable_cw=$cw_default)
AM_CONDITIONAL([BUILD_CLASSWIZARD], [test "x$enable_cw" = "xyes"])
if test "x$enable_cw" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(whether to build the code completion plugin)
cc_default="yes"
AC_ARG_ENABLE(code-completion, [AC_HELP_STRING([--enable-code-completion], [build the code completion plugin (default YES)])],,
                       enable_cc=$cc_default)
AM_CONDITIONAL([BUILD_CODECOMPLETION], [test "x$enable_cc" = "xyes"])
if test "x$enable_cc" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(whether to build the compiler plugin)
gcc_default="yes"
AC_ARG_ENABLE(compiler, [AC_HELP_STRING([--enable-compiler], [build the compiler plugin (default YES)])],,
                       enable_gcc=$gcc_default)
AM_CONDITIONAL([BUILD_COMPILER], [test "x$enable_gcc" = "xyes"])
if test "x$enable_gcc" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(whether to build the debugger plugin)
dbg_default="yes"
AC_ARG_ENABLE(debugger, [AC_HELP_STRING([--enable-debugger], [build the debugger plugin (default YES)])],,
                       enable_dbg=$dbg_default)
AM_CONDITIONAL([BUILD_DEBUGGER], [test "x$enable_dbg" = "xyes"])
if test "x$enable_dbg" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(whether to build the default MIME handler plugin)
mime_default="yes"
AC_ARG_ENABLE(mime-handler, [AC_HELP_STRING([--enable-mime-handler], [build the default MIME handler plugin (default YES)])],,
                       enable_mime=$mime_default)
AM_CONDITIONAL([BUILD_MIMEHANDLER], [test "x$enable_mime" = "xyes"])
if test "x$enable_mime" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(whether to build the scripted wizard plugin)
prw_default="yes"
AC_ARG_ENABLE(scripted-wizard, [AC_HELP_STRING([--enable-scripted-wizard], [build the scripted wizard plugin (default YES)])],,
                       enable_prw=$prw_default)
AM_CONDITIONAL([BUILD_SCRIPTEDWIZARD], [test "x$enable_prw" = "xyes"])
if test "x$enable_prw" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

AC_MSG_CHECKING(whether to build the to-do plugin)
todo_default="yes"
AC_ARG_ENABLE(todo, [AC_HELP_STRING([--enable-todo], [build the to-do plugin (default YES)])],,
                       enable_todo=$todo_default)
AM_CONDITIONAL([BUILD_TODO], [test "x$enable_todo" = "xyes"])
if test "x$enable_todo" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi


case $host in
	*-*-cygwin* | *-*-mingw*)
		AC_MSG_CHECKING(whether to build the xp-manifest plugin)
		xpmanifest_default="yes"
		AC_ARG_ENABLE(todo, [AC_HELP_STRING([--enable-xpmanifest], [build the xp-manifest plugin (default YES)])],,
                       enable_xpmanifest=$xpmanifest_default)
		AM_CONDITIONAL([BUILD_MANIFEST], [test "x$enable_xpmanifest" = "xyes"])
		if test "x$enable_xpmanifest" = "xyes"; then
			AC_MSG_RESULT(yes)
		else
			AC_MSG_RESULT(no)
		fi
		;;
	*)
		AM_CONDITIONAL([BUILD_MANIFEST], [false])
		;;
esac

AC_MSG_CHECKING(whether to build the contrib plugins)
contrib_default="no"
AC_ARG_ENABLE(contrib, [AC_HELP_STRING([--enable-contrib], [build the contrib plugins (default NO)])],,
                       enable_contrib=$contrib_default)
AM_CONDITIONAL([BUILD_CONTRIB], [test "x$enable_contrib" = "xyes"])
if test "x$enable_contrib" = "xyes"; then
	AC_MSG_RESULT(yes)
else
	AC_MSG_RESULT(no)
fi

GCC_PCH=0
PCH_FLAGS=
pch_default="yes"
AM_CONDITIONAL([PRECOMPILE_HEADERS], [false])
AC_ARG_ENABLE(pch, [AC_HELP_STRING([--enable-pch], [use precompiled headers if available (default YES)])],,
                       enable_pch=$pch_default)
if test "x$enable_pch" = "x" -o "x$enable_pch" = "xyes" ; then
    if test "x$GCC" = "xyes"; then
        dnl test if we have gcc-3.4:
        AC_MSG_CHECKING([if the compiler supports precompiled headers])
        AC_TRY_COMPILE([],
            [
                #if !defined(__GNUC__) || !defined(__GNUC_MINOR__)
                    #error "no pch support"
                #endif
                #if (__GNUC__ < 3)
                    #error "no pch support"
                #endif
                #if (__GNUC__ == 3) && \
                   ((!defined(__APPLE_CC__) && (__GNUC_MINOR__ < 4)) || \
                   ( defined(__APPLE_CC__) && (__GNUC_MINOR__ < 3)))
                    #error "no pch support"
                #endif
            ],
            [
                AC_MSG_RESULT([yes])
                GCC_PCH=1
                PCH_FLAGS="-DCB_PRECOMP -Winvalid-pch"
            ],
            [
                AC_MSG_RESULT([no])
            ])
        AM_CONDITIONAL([PRECOMPILE_HEADERS], [test $GCC_PCH = 1])
    fi
fi

])

# _AM_PROG_TAR(FORMAT)
# --------------------
# Check how to create a tarball in format FORMAT.
# FORMAT should be one of `v7', `ustar', or `pax'.
#
# Substitute a variable $(am__tar) that is a command
# writing to stdout a FORMAT-tarball containing the directory
# $tardir.
#     tardir=directory && $(am__tar) > result.tar
#
# Substitute a variable $(am__untar) that extract such
# a tarball read from stdin.
#     $(am__untar) < result.tar
AC_DEFUN([_AM_PROG_TAR],
[# Always define AMTAR for backward compatibility.
AM_MISSING_PROG([AMTAR], [tar])
m4_if([$1], [v7],
     [am__tar='${AMTAR} chf - "$$tardir"'; am__untar='${AMTAR} xf -'],
     [m4_case([$1], [ustar],, [pax],,
              [m4_fatal([Unknown tar format])])
AC_MSG_CHECKING([how to create a $1 tar archive])
# Loop over all known methods to create a tar archive until one works.
_am_tools='gnutar m4_if([$1], [ustar], [plaintar]) pax cpio none'
_am_tools=${am_cv_prog_tar_$1-$_am_tools}
# Do not fold the above two line into one, because Tru64 sh and
# Solaris sh will not grok spaces in the rhs of `-'.
for _am_tool in $_am_tools
do
  case $_am_tool in
  gnutar)
    for _am_tar in tar gnutar gtar;
    do
      AM_RUN_LOG([$_am_tar --version]) && break
    done
    am__tar="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$$tardir"'
    am__tar_="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$tardir"'
    am__untar="$_am_tar -xf -"
    ;;
  plaintar)
    # Must skip GNU tar: if it does not support --format= it doesn't create
    # ustar tarball either.
    (tar --version) >/dev/null 2>&1 && continue
    am__tar='tar chf - "$$tardir"'
    am__tar_='tar chf - "$tardir"'
    am__untar='tar xf -'
    ;;
  pax)
    am__tar='pax -L -x $1 -w "$$tardir"'
    am__tar_='pax -L -x $1 -w "$tardir"'
    am__untar='pax -r'
    ;;
  cpio)
    am__tar='find "$$tardir" -print | cpio -o -H $1 -L'
    am__tar_='find "$tardir" -print | cpio -o -H $1 -L'
    am__untar='cpio -i -H $1 -d'
    ;;
  none)
    am__tar=false
    am__tar_=false
    am__untar=false
    ;;
  esac

  # If the value was cached, stop now.  We just wanted to have am__tar
  # and am__untar set.
  test -n "${am_cv_prog_tar_$1}" && break

  # tar/untar a dummy directory, and stop if the command works
  rm -rf conftest.dir
  mkdir conftest.dir
  echo GrepMe > conftest.dir/file
  AM_RUN_LOG([tardir=conftest.dir && eval $am__tar_ >conftest.tar])
  rm -rf conftest.dir
  if test -s conftest.tar; then
    AM_RUN_LOG([$am__untar <conftest.tar])
    grep GrepMe conftest.dir/file >/dev/null 2>&1 && break
  fi
done
rm -rf conftest.dir

AC_CACHE_VAL([am_cv_prog_tar_$1], [am_cv_prog_tar_$1=$_am_tool])
AC_MSG_RESULT([$am_cv_prog_tar_$1])])
AC_SUBST([am__tar])
AC_SUBST([am__untar])
]) # _AM_PROG_TAR
