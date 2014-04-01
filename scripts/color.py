#!usr/bin/python
# -*- coding: utf-8 -*-

'''Color formatting
'''

from __future__ import print_function, division

try:
    import colorama
    colorama.init()

    from colorama import Fore, Back, Style

except ImportError:

    def note(t): return t
    def success(t): return t
    def warn(t): return t
    def error(t): return t

else:
    import os
    _no_color = os.getenv('NO_COLOR', 'false')
    _no_color = True if _no_color.lower() in ['1', 'true', 't', 'y', 'yes'] else False

    def stdout_redirected():
        return os.fstat(0) != os.fstat(1)

    _redir_stdout = stdout_redirected()

    def colorize(t, code):
        if _no_color or _redir_stdout:
            return t

        return ''.join([code, t, Style.RESET_ALL])

    def note(t):
        return colorize(t, Fore.BLUE)

    def success(t):
        return colorize(t, Fore.GREEN)

    def warn(t):
        return colorize(t, Fore.YELLOW + Style.BRIGHT)

    def error(t):
        return colorize(t, Fore.RED + Style.BRIGHT)


if __name__ == '__main__':
    print('Colorized text:\n')
    print('note("foobar")    : ' + note('foobar'))
    print('success("foobar") : ' + success('foobar'))
    print('warn("foobar")    : ' + warn('foobar'))
    print('error("foobar")   : ' + error('foobar'))

    #import os
    #print('redir?', os.fstat(0) == os.fstat(1))
