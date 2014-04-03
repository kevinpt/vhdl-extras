#!/usr/bin/python
# -*- coding: utf-8 -*-

'''Engineering unit string formatting
'''

# Copyright © 2013 Kevin Thibedeau

# This file is part of Ripyl.

# Ripyl is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# Ripyl is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public
# License along with Ripyl. If not, see <http://www.gnu.org/licenses/>.

import math

class Eng(object):
    '''Base class for engineering unit string formatting'''
    def __init__(self, f, frac_digits=3):
        '''
        f (number)
            The number to represent in engineering units.

        frac_digits (int)
            The number of fractional digits to display in a string.
        '''
        self.f = f
        self.frac_digits = frac_digits
        if frac_digits < 0:
            raise ValueError('frac_digits must be a positive integer')
        
    def __float__(self):
        return self.f

    def __repr__(self):
        return 'Eng({}, {})'.format(self.f, self.frac_digits)
        
    def _to_eng(self):
        exp = int(math.log10(abs(self.f)))
        e_exp = exp - exp % 3
        if e_exp <= 0 and self.f < 10.0**e_exp:
            e_exp -= 3
        e_num = self.f / 10**e_exp
        return e_num, e_exp

    def __str__(self):
        e_num, e_exp = self._to_eng()
        digits = '{0:.{1}f}'.format(e_num, self.frac_digits)
        return digits + 'e' + str(e_exp)


si_prefixes = {
    21:  'Y',
    18:  'Z',
    15:  'E',
    12:  'P',
    9:   'G',
    6:   'M',
    3:   'k',
    0:   '',
    -3:  'm',
    -6:  'u',
    -9:  'n',
    -12: 'p',
    -15: 'f',
    -18: 'a',
    -21: 'z',
    -24: 'y'
}

class EngSI(Eng):
    '''Class for engineering unit string formatting with SI units'''
    def __init__(self, f, units='', frac_digits=3, unit_sep=' '):
        '''
        f (number)
            The number to represent in engineering units.

        units (string)
            The units that the number represents.

        frac_digits (int)
            The number of fractional digits to display in a string.

        unit_sep (string)
            The separator between the number and the units string
        '''
        Eng.__init__(self, f, frac_digits)
        self.units = units
        self.unit_sep = unit_sep
        self.prefixes = si_prefixes

    def __repr__(self):
        return 'EngSI({}, {}, {}, {})'.format(self.f, self.units, self.frac_digits, self.unit_sep)
        
    def __str__(self):
        e_num, e_exp = self._to_eng()
        digits = '{0:.{1}f}'.format(e_num, self.frac_digits)
        
        if e_exp in self.prefixes:
            str_exp = self.unit_sep + self.prefixes[e_exp] + self.units
        else:
            str_exp = 'e' + str(e_exp)
        
        return digits + str_exp


        
si_uc_prefixes = {
    21:  'Y',
    18:  'Z',
    15:  'E',
    12:  'P',
    9:   'G',
    6:   'M',
    3:   'k',
    0:   '',
    -3:  'm',
    -6:  u'\u03bc', # Greek small-mu
    -9:  'n',
    -12: 'p',
    -15: 'f',
    -18: 'a',
    -21: 'z',
    -24: 'y'
}

class EngUSI(EngSI):
    '''Class for engineering unit string formatting with SI units with unicode characters'''
    def __init__(self, f, units='', frac_digits=3, unit_sep=' '):
        EngSI.__init__(self, f, units, frac_digits, unit_sep)
        self.prefixes = si_uc_prefixes
        
    def __repr__(self):
        return 'EngUSI({}, {}, {}, {})'.format(self.f, self.units, self.frac_digits, self.unit_sep)



def eng(f, frac_digits=3):
    '''Create engineering formatted string'''
    return str(Eng(f, frac_digits))
    
def eng_si(f, units='', frac_digits=3, unit_sep=' '):
    '''Create engineering formatted string with SI units'''
    return str(EngSI(f, units, frac_digits, unit_sep))
    
def eng_usi(f, units='', frac_digits=3, unit_sep=' '):
    '''Create engineering formatted string with unicode SI units'''
    return str(EngUSI(f, units, frac_digits, unit_sep))

