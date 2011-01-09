/**************************************************************************
/* Getopt.as -- Actionscript 3 port of GNU getopt from glibc 2.0.6
/*              Based on Java port by Aaron M. Renn 1998
/*
/* Copyright (c) 1987-1997 Free Software Foundation, Inc.
/* Java Port Copyright (c) 1998 by Aaron M. Renn (arenn@urbanophile.com)
/* AS3 Port Copyright (c) 2010 by Carl Calderon (carl.calderon@gmail.com)
/*
/* This program is free software; you can redistribute it and/or modify
/* it under the terms of the GNU Library General Public License as published 
/* by  the Free Software Foundation; either version 2 of the License or
/* (at your option) any later version.
/*
/* This program is distributed in the hope that it will be useful, but
/* WITHOUT ANY WARRANTY; without even the implied warranty of
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/* GNU Library General Public License for more details.
/*
/* You should have received a copy of the GNU Library General Public License
/* along with this program; see the file COPYING.LIB.  If not, write to 
/* the Free Software Foundation Inc., 59 Temple Place - Suite 330, 
/* Boston, MA  02111-1307 USA
/**************************************************************************/

package gnu.getopt
{
	
	/**
	 * LongOpt definition of GNU getopt port. Based on Java port
	 * by Aaron M. Renn. An array of LongOpt objects is passed to the Getopt
	 * object to define the list of valid long options for a given parsing
	 * session.  Refer to the getopt documentation for details on the
	 * format of long options.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0 
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @version 1.0.0
	 * 
	 * @see Getopt
	 */
	public class LongOpt
	{
		/**
		 * Constant value used for the "hasArg" constructor argument.  This
		 * value indicates that the option takes no argument.
		 */
		public static const NO_ARGUMENT			:int = 0;
		/** 
		 * Constant value used for the "hasArg" constructor argument.  This
		 * value indicates that the option takes an argument that is required.
		 */
		public static const REQUIRED_ARGUMENT	:int = 1;
		/**
		 * Constant value used for the "hasArg" constructor argument.  This
		 * value indicates that the option takes an argument that is optional.
		 */
		public static const OPTIONAL_ARGUMENT	:int = 2;
		
		/**
		 * @internal LongOpt name
		 */
		protected var _name		:String;
		
		/**
		 * @internal Indicates whether the option has no argument, a required argument,
		 * or an optional argument.
		 */
		protected var _hasArg	:int;
		
		/**
		 * @internal If this variable is not null, then the value stored in "val" is stored
		 * here when this long option is encountered.  If this is null, the value
		 * stored in "val" is treated as the name of an equivalent short option.
		 */
		protected var _flag		:String = null;
		
		/**
		 * @internal The value to store in "flag" if flag is not null, otherwise the
		 * equivalent short option character for this long option.
		 */
		protected var _val		:*;
		
		/**
		 * Creates a new LongOpt. Throws exception if <code>hasArg</code> is invalid.
		 * 
		 * @constructor
		 * 
		 * @param name 		LongOpt name
		 * @param hasArg 	Indicates how this LongOpt should handle arguments (NO_ARGUMENT,REQUIRED_ARGUMENT or OPTIONAL_ARGUMENT)
		 * @param flag 		If non-null, this is a location to store the value of "val" when this option is encountered, otherwise "val" is treated as the equivalent short option character.
		 * @param val		The value to return for this long option, or the equivalent single letter option to emulate if flag is null.
		 */
		public function LongOpt(name:String,hasArg:int,flag:String,val:*)
		{
			super();	// for FlexPMD
			if ((hasArg != NO_ARGUMENT) && (hasArg != REQUIRED_ARGUMENT) && (hasArg != OPTIONAL_ARGUMENT))
				throw new Error('Invalid value '+hasArg+' for parameter \'hasArg\'');
			this._name		= name;
			this._hasArg	= hasArg;
			this._flag		= flag;
			this._val		= val;
		}
		
		/**
		 *	Older implementation of #name
		 *  @copy #name
		 *	@return String
		 */
		public function getName():String { return name; }
		
		/**
		 * Returns the name of this LongOpt as a String
		 *
		 * @return Then name of the long option
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 *	Older implementation of #hasArg
		 *  @copy #hasArg
		 *	@return int
		 */
		public function getHasArg():int { return hasArg; }
		/**
		 * Returns the value set for the 'has_arg' field for this long option
		 *
		 * @return The value of 'hasArg'
		 */
		public function get hasArg():int
		{
			return _hasArg;
		}
		
		/**
		 *	Older implementation of #flag
		 *  @copy #flag
		 *	@return String
		 */
		public function getFlag():String { return flag; }
		/**
		 * Returns the value of the 'flag' field for this long option
		 *
		 * @return The value of 'flag'
		 */
		public function get flag():String
		{
			return _flag;
		}
		public function set flag(value:String):void
		{
			_flag = value;
		}
		
		/**
		 *	Older implementation of #val
		 *  @copy #val
		 *	@return *
		 */
		public function getVal():* { return val; }
		/**
		 * Returns the value of the 'val' field for this long option
		 *
		 * @return The value of 'val'
		 */
		public function get val():*
		{
			return _val;
		}
	
	}

}