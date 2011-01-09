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
	import getopt.LongOpt;
	
/**************************************************************************/
	
	/**
	 * The following documentation of this class is a modified version
	 * of Aaron M. Renn's Java port documentation. 
	 */
	
	/**
	 * This is a AS3 port of GNU getopt, a class for parsing command line
	 * arguments passed to programs.  It is based on the C getopt() functions
	 * in glibc 2.0.6 and should parse options in a 100% compatible manner.
	 * If it does not, that is a bug.  The programmer's interface is also
	 * very compatible.
	 * <p>
	 * To use Getopt, create a Getopt object with a argv array passed to the
	 * main method, then call the getopt() method in a loop.  It will return an
	 * int that contains the value of the option character parsed from the
	 * command line.  When there are no more options to be parsed, it
	 * returns -1.
	 * <p>
	 * A command line option can be defined to take an argument.  If an
	 * option has an argument, the value of that argument is stored in an
	 * instance variable called optarg, which can be accessed using the
	 * getOptarg() method.  If an option that requires an argument is
	 * found, but there is no argument present, then an error message is
	 * printed. Normally getopt() returns a '?' in this situation, but
	 * that can be changed as described below.
	 * <p>
	 * If an invalid option is encountered, an error message is printed
	 * to the standard error and getopt() returns a '?'.  The value of the
	 * invalid option encountered is stored in the instance variable optopt
	 * which can be retrieved using the getOptopt() method.  To suppress
	 * the printing of error messages for this or any other error, set
	 * the value of the opterr instance variable to false using the 
	 * setOpterr() method.
	 * <p>
	 * Between calls to getopt(), the instance variable optind is used to
	 * keep track of where the object is in the parsing process.  After all
	 * options have been returned, optind is the index in argv of the first
	 * non-option argument.  This variable can be accessed with the getOptind()
	 * method.
	 * <p>
	 * Note that this object expects command line options to be passed in the
	 * traditional Unix manner.  That is, proceeded by a '-' character. 
	 * Multiple options can follow the '-'.  For example "-abc" is equivalent
	 * to "-a -b -c".  If an option takes a required argument, the value
	 * of the argument can immediately follow the option character or be
	 * present in the next argv element.  For example, "-cfoo" and "-c foo"
	 * both represent an option character of 'c' with an argument of "foo"
	 * assuming c takes a required argument.  If an option takes an argument
	 * that is not required, then any argument must immediately follow the
	 * option character in the same argv element.  For example, if c takes
	 * a non-required argument, then "-cfoo" represents option character 'c'
	 * with an argument of "foo" while "-c foo" represents the option
	 * character 'c' with no argument, and a first non-option argv element
	 * of "foo".
	 * <p>
	 * The user can stop getopt() from scanning any further into a command line
	 * by using the special argument "--" by itself.  For example: 
	 * "-a -- -d" would return an option character of 'a', then return -1
	 * The "--" is discarded and "-d" is pointed to by optind as the first
	 * non-option argv element.
	 * <p>
	 * Here is a basic example of using Getopt:
	 * <p>
	 * <pre>
	 * var g:Getopt = new Getopt(argv, "ab:c::d");
	 * //
	 * var c:String;
	 * var arg:String;
	 * while ((c = g.getopt()) != Getopt.END_OF_ARGS)
	 *   {
	 *     switch(c)
	 *       {
	 *          case 'a':
	 *          case 'd':
	 *            trace('You picked ' + c);
	 *            break;
	 *            //
	 *          case 'b':
	 *          case 'c':
	 *            arg = g.getOptarg();
	 *            trace('You picked ' + c + ' with argument of ' + arg);
	 *            break;
	 *            //
	 *          case '?':
	 *            break; // getopt() already printed an error
	 *            //
	 *          default:
	 *            trace('getopt() returned ' + c);
	 *       }
	 *   }
	 * </pre>
	 * <p>
	 * In this example, a new Getopt object is created with three params.
	 * The first param is the argument list that was passed on through the
	 * Event.INVOKE (Adobe AIR > 1.X) upon application start up. The second
	 * param is the list of valid options.  Each character represents a valid
	 * option.  If the character is followed by a single colon, then that
	 * option has a required argument.  If the character is followed by two
	 * colons, then that option has an argument that is not required.
	 * <p>
	 * Note in this example that the value returned from getopt() is cast to
	 * a char prior to printing.  This is required in order to make the value
	 * display correctly as a character instead of an integer.
	 * <p>
	 * If the first character in the option string is a colon, for example
	 * ":abc::d", then getopt() will return a ':' instead of a '?' when it
	 * encounters an option with a missing required argument.  This allows the
	 * caller to distinguish between invalid options and valid options that
	 * are simply incomplete.
	 * <p>
	 * In the traditional Unix getopt(), -1 is returned when the first non-option
	 * charcter is encountered.  In GNU getopt(), the default behavior is to
	 * allow options to appear anywhere on the command line.  The getopt()
	 * method permutes the argument to make it appear to the caller that all
	 * options were at the beginning of the command line, and all non-options
	 * were at the end.  For example, calling getopt() with command line args
	 * of "-a foo bar -d" returns options 'a' and 'd', then sets optind to 
	 * point to "foo".  The program would read the last two argv elements as
	 * "foo" and "bar", just as if the user had typed "-a -d foo bar". 
	 * <p> 
	 * The user can force getopt() to stop scanning the command line with
	 * the special argument "--" by itself.  Any elements occuring before the
	 * "--" are scanned and permuted as normal.  Any elements after the "--"
	 * are returned as is as non-option argv elements.  For example, 
	 * "foo -a -- bar -d" would return  option 'a' then -1.  optind would point 
	 * to "foo", "bar" and "-d" as the non-option argv elements.  The "--"
	 * is discarded by getopt().
	 * <p>
	 * There are two ways this default behavior can be modified.  The first is
	 * to specify traditional Unix getopt() behavior (which is also POSIX
	 * behavior) in which scanning stops when the first non-option argument
	 * encountered.  (Thus "-a foo bar -d" would return 'a' as an option and
	 * have "foo", "bar", and "-d" as non-option elements).  The second is to
	 * allow options anywhere, but to return all elements in the order they
	 * occur on the command line.  When a non-option element is ecountered,
	 * an integer 1 is returned and the value of the non-option element is
	 * stored in optarg is if it were the argument to that option.  For
	 * example, "-a foo -d", returns first 'a', then 1 (with optarg set to
	 * "foo") then 'd' then -1.  When this "return in order" functionality
	 * is enabled, the only way to stop getopt() from scanning all command
	 * line elements is to use the special "--" string by itself as described
	 * above.  An example is "-a foo -b -- bar", which would return 'a', then
	 * integer 1 with optarg set to "foo", then 'b', then -1.  optind would
	 * then point to "bar" as the first non-option argv element.  The "--"
	 * is discarded.
	 * <p>
	 * <strong><i>The lack of POSIX properties in AS3 defaults the following 
	 * paragraph to "gnu.posixly_correct = false". Section can be ignored.</i>
	 * </strong>
	 * The POSIX/traditional behavior is enabled by either setting the 
	 * property "gnu.posixly_correct" or by putting a '+' sign as the first
	 * character of the option string.  The difference between the two 
	 * methods is that setting the gnu.posixly_correct property also forces
	 * certain error messages to be displayed in POSIX format.  To enable
	 * the "return in order" functionality, put a '-' as the first character
	 * of the option string.  Note that after determining the proper 
	 * behavior, Getopt strips this leading '+' or '-', meaning that a ':'
	 * placed as the second character after one of those two will still cause
	 * getopt() to return a ':' instead of a '?' if a required option
	 * argument is missing.
	 * <p>
	 * In addition to traditional single character options, GNU Getopt also
	 * supports long options.  These are preceeded by a "--" sequence and
	 * can be as long as desired.  Long options provide a more user-friendly
	 * way of entering command line options.  For example, in addition to a
	 * "-h" for help, a program could support also "--help".  
	 * <p>
	 * Like short options, long options can also take a required or non-required 
	 * argument.  Required arguments can either be specified by placing an
	 * equals sign after the option name, then the argument, or by putting the
	 * argument in the next argv element.  For example: "--outputdir=foo" and
	 * "--outputdir foo" both represent an option of "outputdir" with an
	 * argument of "foo", assuming that outputdir takes a required argument.
	 * If a long option takes a non-required argument, then the equals sign
	 * form must be used to specify the argument.  In this case,
	 * "--outputdir=foo" would represent option outputdir with an argument of
	 * "foo" while "--outputdir foo" would represent the option outputdir
	 * with no argument and a first non-option argv element of "foo".
	 * <p>
	 * Long options can also be specified using a special POSIX argument 
	 * format (one that I highly discourage).  This form of entry is 
	 * enabled by placing a "W;" (yes, 'W' then a semi-colon) in the valid
	 * option string.  This causes getopt to treat the name following the
	 * "-W" as the name of the long option.  For example, "-W outputdir=foo"
	 * would be equivalent to "--outputdir=foo".  The name can immediately
	 * follow the "-W" like so: "-Woutputdir=foo".  Option arguments are
	 * handled identically to normal long options.  If a string follows the 
	 * "-W" that does not represent a valid long option, then getopt() returns
	 * 'W' and the caller must decide what to do.  Otherwise getopt() returns
	 * a long option value as described below.
	 * <p>
	 * While long options offer convenience, they can also be tedious to type
	 * in full.  So it is permissible to abbreviate the option name to as
	 * few characters as required to uniquely identify it.  If the name can
	 * represent multiple long options, then an error message is printed and
	 * getopt() returns a '?'.  
	 * <p>
	 * If an invalid option is specified or a required option argument is 
	 * missing, getopt() prints an error and returns a '?' or ':' exactly
	 * as for short options.  Note that when an invalid long option is
	 * encountered, the optopt variable is set to integer 0 and so cannot
	 * be used to identify the incorrect option the user entered.
	 * <p>
	 * Long options are defined by LongOpt objects.  These objects are created
	 * with a contructor that takes four params: a String representing the
	 * object name, a integer specifying what arguments the option takes
	 * (the value is one of LongOpt.NO_ARGUMENT, LongOpt.REQUIRED_ARGUMENT,
	 * or LongOpt.OPTIONAL_ARGUMENT), a StringBuffer flag object (described
	 * below), and an integer value (described below).
	 * <p>
	 * To enable long option parsing, create an array of LongOpt's representing
	 * the legal options and pass it to the Getopt() constructor.  WARNING: If
	 * all elements of the array are not populated with LongOpt objects, the
	 * getopt() method will throw a NullPointerException.
	 * <p>
	 * When getopt() is called and a long option is encountered, one of two
	 * things can be returned.  If the flag field in the LongOpt object 
	 * representing the long option is non-null, then the integer value field
	 * is stored there and an integer 0 is returned to the caller.  The val
	 * field can then be retrieved from the flag field.  Note that since the
	 * flag field is a StringBuffer, the appropriate String to integer converions
	 * must be performed in order to get the actual int value stored there.
	 * If the flag field in the LongOpt object is null, then the value field
	 * of the LongOpt is returned.  This can be the character of a short option.
	 * This allows an app to have both a long and short option sequence 
	 * (say, "-h" and "--help") that do the exact same thing.
	 * <p>
	 * With long options, there is an alternative method of determining 
	 * which option was selected.  The method getLongind() will return the
	 * the index in the long option array (NOT argv) of the long option found.
	 * So if multiple long options are configured to return the same value,
	 * the application can use getLongind() to distinguish between them. 
	 * <p>
	 * Here is an expanded Getopt example using long options and various
	 * techniques described above:
	 * <p>
	 * <pre>
	 * // argv = <params from Event.INVOKE>
	 * 
	 * var c:String;
	 * var arg:String;
	 * var longopts:Array = new Array(3);
	 * // 
	 * longopts[0] = new LongOpt("help", LongOpt.NO_ARGUMENT, null, 'h');
	 * longopts[1] = new LongOpt("outputdir", LongOpt.REQUIRED_ARGUMENT, '', 'o'); 
	 * longopts[2] = new LongOpt("maximum", LongOpt.OPTIONAL_ARGUMENT, null, 2);
	 * // 
	 * var g:Getopt = new Getopt(argv, "-:bc::d:hW;", longopts);
	 * g.setOpterr(false); // We'll do our own error handling
	 * //
	 * while ((c = g.getopt()) != Getopt.END_OF_ARGS)
	 *   switch (c)
	 *     {
	 *        case Getopt.LONG_OPTION:
	 *          arg = g.getOptarg();
	 *          trace('Got long option "'+longopts[g.getLongind()].name+'" with value "' +
	 *                 longopts[g.getLongind()].val + '" and argument "' + arg + '"');
	 *          break;
	 *          //
	 *        case Getopt.INVALID_ORDER:
	 *          arg = g.getOptarg();
	 *          trace('I see you have return in order set and that a non-option argv element was' +
	 *	               ' just found with value "' + arg + '"');
	 *          break;
	 *          //
	 *        case Getopt.LONG_GUESS:
	 *          arg = g.getOptarg();
	 *          trace('I know this but i pretend I didn\'t');
	 *          trace('We picked option ' + longopts[g.getLongind()].name + ' with value ' + arg);
	 *          break;
	 *          //
	 *        case 'b':
	 *          trace('You picked plain old option ' + c);
	 *          break;
	 *          //
	 *        case 'c':
	 *        case 'd':
	 *          arg = g.getOptarg();
	 *          trace('You picked option "' + c + '" with argument ' + arg);
	 *          break;
	 *          //
	 *        case 'h':
	 *          trace('I see you asked for help');
	 *          break;
	 *          //
	 *        case 'W':
	 *          trace('Hmmm. You tried a -W with an incorrect long option name');
	 *          break;
	 *          //
	 *        case ':':
	 *          trace('Doh! You need an argument for option ' + g.getOptopt());
	 *          break;
	 *          //
	 *        case '?':
	 *          trace('The option "' + g.getOptopt() + '" is not valid');
	 *          break;
	 *          //
	 *        default:
	 *          trace('getopt() returned ' + c);
	 *          break;
	 *     }
	 * //
	 * for (var i:int = g.getOptind(); i < argv.length ; i++)
	 *   trace('Non option argv element: ' + argv[i] + '\n');
	 * </pre>
	 * <p>
	 * There is an alternative form of the constructor used for long options
	 * above.  This takes a trailing boolean flag.  If set to false, Getopt
	 * performs identically to the example, but if the boolean flag is true
	 * then long options are allowed to start with a single '-' instead of
	 * "--".  If the first character of the option is a valid short option
	 * character, then the option is treated as if it were the short option.
	 * Otherwise it behaves as if the option is a long option.  Note that
	 * the name given to this option - long_only - is very counter-intuitive.
	 * It does not cause only long options to be parsed but instead enables
	 * the behavior described above.
	 * <p> 
	 * Note that the functionality and variable names used are driven from 
	 * the C lib version as this object is a port of the C code, not a 
	 * new implementation.  This should aid in porting existing C/C++ code,
	 * as well as helping programmers familiar with the glibc version to
	 * adapt to the Java version even if it seems very non-Java at times.
	 * <p>
	 * In this release I made all instance variables protected due to
	 * overwhelming public demand.  Any code which relied on optarg,
	 * opterr, optind, or optopt being public will need to be modified to
	 * use the appropriate access methods.
	 * <p>
	 * Please send all bug reports, requests, and comments to 
	 * <a href="mailto:carl.calderon+as3getopt@gmail.com">
	 * carl.calderon@gmail.com
	 * </a>.
	 *
	 * @version 1.0.0
	 *
	 * @author Roland McGrath (roland@gnu.ai.mit.edu)
	 * @author Ulrich Drepper (drepper@cygnus.com)
	 * @author Aaron M. Renn (arenn@urbanophile.com)
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 *
	 * @see LongOpt
	 */
	public class Getopt
	{
		
		/**
		 * End of arguments.
		 */
		public static const END_OF_ARGS		:String = '-1';
		/**
		 * LongOpt / Long option found
		 */
		public static const LONG_OPTION		:String = '0';
		/**
		 * Arguments defined in invalid ordering.
		 */
		public static const INVALID_ORDER 	:String = '1';
		/**
		 * Found possible LongOpt.
		 */
		public static const LONG_GUESS		:String = '2';
		
		/** 
		 * Describe how to deal with options that follow non-option ARGV-elements.
		 *
		 * If the caller did not specify anything,
		 * the default is REQUIRE_ORDER if the property 
		 * gnu.posixly_correct is defined, PERMUTE otherwise.
		 *
		 * The special argument `--' forces an end of option-scanning regardless
		 * of the value of `ordering'.  In the case of RETURN_IN_ORDER, only
		 * `--' can cause `getopt' to return -1 with `optind' != ARGC.
		 *
		 * REQUIRE_ORDER means don't recognize them as options;
		 * stop option processing when the first non-option is seen.
		 * This is what Unix does.
		 * This mode of operation is selected by either setting the property
		 * gnu.posixly_correct, or using `+' as the first character
		 * of the list of option characters.
		 */
		protected static const REQUIRE_ORDER	:int	= 1;
		/**
		 * PERMUTE is the default.  We permute the contents of ARGV as we scan,
		 * so that eventually all the non-options are at the end.  This allows options
		 * to be given in any order, even with programs that were not written to
		 * expect this.
		 */
		protected static const PERMUTE			:int	= 2;
		/**
		 * RETURN_IN_ORDER is an option available to programs that were written
		 * to expect options and other ARGV-elements in any order and that care about
		 * the ordering of the two.  We describe each non-option ARGV-element
		 * as if it were the argument of an option with character code 1.
		 * Using `-' as the first character of the list of option characters
		 * selects this mode of operation.
		 */
		protected static const RETURN_IN_ORDER	:int	= 3;
		
		/**
		 * For communication from `getopt' to the caller.
		 * When `getopt' finds an option that takes an argument,
		 * the argument value is returned here.
		 * Also, when `ordering' is RETURN_IN_ORDER,
		 * each non-option ARGV-element is returned here.
		 */
		protected var optarg			:String;
		
		/** 
		 * Callers store false here to inhibit the error message
		 * for unrecognized options.  
		 */
		protected var opterr			:Boolean	= true;
		
		/**
		 *  Index in ARGV of the next element to be scanned.
		 *  This is used for communication to and from the caller
		 *  and for communication between successive calls to `getopt'.
		 *
		 *  On entry to `getopt', zero means this is the first call; initialize.
		 *
		 *  When `getopt' returns '-1', this is the index of the first of the
		 *  non-option elements that the caller should itself scan.
		 *
		 *  Otherwise, `optind' communicates from one call to the next
		 *  how much of ARGV has been scanned so far.  
		 */
		protected var optind			:int 		= 0;
		
		/** 
		 * When an unrecognized option is encountered, getopt will return a '?'
		 * and store the value of the invalid option here.
		 */
		protected var optopt			:String		= '?';
		
		/** 
		 * The next char to be scanned in the option-element
		 * in which the last option character we returned was found.
		 * This allows us to pick up the scan where we left off.
		 *
		 * If this is zero, or a null string, it means resume the scan
		 * by advancing to the next ARGV-element.  
		 */
		protected var nextchar			:String;
		
		/**
		 * This is the string describing the valid short options.
		 */
		protected var optstring			:String;
		
		/**
		 * This is an array of LongOpt objects which describ the valid long 
		 * options.
		 */
		protected var long_options		:Array;
		
		/**
		 * This flag determines whether or not we are parsing only long args
		 */
		protected var long_only			:Boolean;
		
		/**
		 * Stores the index into the long_options array of the long option found
		 */
		protected var longind			:int;
		
		/**
		 * The flag determines whether or not we operate in strict POSIX compliance
		 * @default false. AS3 does not recognize this kind of property
		 */
		protected var posixly_correct	:Boolean	= false;
		
		/**
		 * A flag which communicates whether or not checkLongOption() did all
		 * necessary processing for the current option
		 */
		protected var longopt_handled	:Boolean;
		
		/**
		 * The index of the first non-option in argv
		 */
		protected var first_nonopt		:int		= 1;
		
		/**
		 * The index of the last non-option in argv
		 */
		protected var last_nonopt		:int		= 1;
		
		/**
		 * Saved argument list passed to the program
		 */
		protected var argv				:Array;
		/**
		 * Determines whether we permute arguments or not
		 */
		protected var ordering			:int;
		
		/**
		 * Name to print as the program name in error messages.
		 */
		protected var progname			:String;
		
		/**
		 * Flag to tell getopt to immediately return '-1' the next time it is
		 * called.
		 */
		private var endparse		:Boolean = false;
		
		/**
		 * Construct a Getopt instance with given input data that is capable of
		 * parsing long options and short options.  Contrary to what you might
		 * think, the flag 'long_only' does not determine whether or not we 
		 * scan for only long arguments.  Instead, a value of true here allows
		 * long arguments to start with a '-' instead of '--' unless there is a
		 * conflict with a short option name.
		 * 
		 * @constructor
		 * @param argv The String array passed as the command ilne to the program
		 * @param optstring A String containing a description of the valid short args for this program
		 * @param long_options An array of LongOpt objects that describes the valid long args for this program
		 * @param long_only true if long options that do not conflict with short options can start with a '-' as well as '--'
		 */
		public function Getopt(argv:Array,optstring:String,long_options:Array=null,long_only:Boolean=false)
		{
			super(); // for FlexPMD
			//TODO use setOptstring (optimize?)
			if(optstring.length == 0)
				optstring = ' ';
			
			this.progname 		= argv[0];
			this.argv 			= argv.slice(1);
			this.optstring 		= optstring;
			this.long_options 	= long_options;
			this.long_only 		= long_only;
			
			//TODO check for posixly_correct substitute in as3
			
			// Determine how to handle the ordering of options and non-options
			if(optstring.charAt(0) == '-')
			{
				ordering = RETURN_IN_ORDER;
				if(optstring.length > 1)
					this.optstring = optstring.substring(1);
			}
			else if(optstring.charAt(0) == '+')
			{
				ordering = REQUIRE_ORDER;
				if(optstring.length > 1)
					this.optstring = optstring.substring(1);
			}
			else if(posixly_correct)
			{
				ordering = REQUIRE_ORDER;
			}
			else
			{
				ordering = PERMUTE; // The normal default case
			}
		}
		
		/**
		 * In GNU getopt, it is possible to change the string containg valid options
		 * on the fly because it is passed as an argument to getopt() each time.  In
		 * this version we do not pass the string on every call.  In order to allow
		 * dynamic option string changing, this method is provided.
		 *
		 * @param optstring The new option string to use
		 */
		public function setOptstring(optstring:String):void
		{
			if(optstring.length == 0)
				optstring = ' ';
			this.optstring = optstring;
		}
		
		/**
		 * optind it the index in ARGV of the next element to be scanned.
		 * This is used for communication to and from the caller
		 * and for communication between successive calls to `getopt'.
		 *
		 * When `getopt' returns '-1', this is the index of the first of the
		 * non-option elements that the caller should itself scan.
		 *
		 * Otherwise, `optind' communicates from one call to the next
		 * how much of ARGV has been scanned so far.  
		 */
		public function getOptind():int
		{
			return optind;
		}
		
		/**
		 * This method allows the optind index to be set manually.  Normally this
		 * is not necessary (and incorrect usage of this method can lead to serious
		 * lossage), but optind is a public symbol in GNU getopt, so this method 
		 * was added to allow it to be modified by the caller if desired.
		 *
		 * @param optind The new value of optind
		 */
		public function setOptind(optind:int):void
		{
			this.optind = optind;
		}
		
		/**
		 * Since in GNU getopt() the argument vector is passed back in to the
		 * function every time, the caller can swap out argv on the fly.  Since
		 * passing argv is not required in the AS3 version, this method allows
		 * the user to override argv.  Note that incorrect use of this method can
		 * lead to serious lossage.
		 *
		 * @param argv New argument list
		 */
		public function setArgv(argv:Array):void
		{
			this.argv = argv;
		}
		
		/** 
		 * For communication from `getopt' to the caller.
		 * When `getopt' finds an option that takes an argument,
		 * the argument value is returned here.
		 * Also, when `ordering' is RETURN_IN_ORDER,
		 * each non-option ARGV-element is returned here.
		 * No set method is provided because setting this variable has no effect.
		 */
		public function getOptarg():String
		{
			return optarg;
		}
		
		/**
		 * Normally Getopt will print a message to the standard error when an
		 * invalid option is encountered.  This can be suppressed (or re-enabled)
		 * by calling this method.  There is no get method for this variable 
		 * because if you can't remember the state you set this to, why should I?
		 */
		public function setOpterr(opterr:Boolean):void
		{
			this.opterr = opterr;
		}
		
		/**
		 * When getopt() encounters an invalid option, it stores the value of that
		 * option in optopt which can be retrieved with this method.  There is
		 * no corresponding set method because setting this variable has no effect.
		 */
		public function getOptopt():*
		{
			return optopt;
		}
		
		/**
		 * Returns the index into the array of long options (NOT argv) representing
		 * the long option that was found.
		 */
		public function getLongind():int
		{
			return longind;
		}
		
		/**
		 * Exchange the shorter segment with the far end of the longer segment.
		 * That puts the shorter segment into the right place.
		 * It leaves the longer segment in the right place overall,
		 * but it consists of two parts that need to be swapped next.
		 * This method is used by getopt() for argument permutation.
		 */
		protected function exchange(argv:Array):void
		{
			var bottom	:int = first_nonopt;
			var middle	:int = last_nonopt;
			var top		:int = optind;
			var tem		:String;
			var i		:int;
			var len		:int;
			
			while(top > middle && middle > bottom)
			{
				if(top - middle > middle - bottom)
				{
					// Bottom segment is the short one. 
					len = middle - bottom;
					
					// Swap it with the top part of the top segment. 
					for (i = 0; i < len; i++)
					{
						tem = argv[bottom+i];
						argv[bottom+i] = argv[top - (middle - bottom) + i];
						argv[top - (middle - bottom) + i] = tem;
					}
					// Exclude the moved bottom segment from further swapping. 
					top -= len;
				}
				else
				{
					// Top segment is the short one.
					len = top - middle;
					
					// Swap it with the bottom part of the bottom segment. 
					for (i = 0; i < len; i++)
					{
						tem = argv[bottom + i];
						argv[bottom + i] = argv[middle + i];
						argv[middle + i] = tem;
					}
					// Exclude the moved top segment from further swapping. 
					bottom += len;
				}
			}
			
			// Update records for the slots the non-options now occupy. 
			first_nonopt += optind - last_nonopt;
			last_nonopt   = optind;
		}
		
		/**
		 * Check to see if an option is a valid long option.  Called by getopt().
		 * Put in a separate method because this needs to be done twice.  (The
		 * C getopt authors just copy-pasted the code!).
		 *
		 * @return Various things depending on circumstances
		 */
		protected function checkLongOption():String 
		{
			var pfound		:LongOpt 	= null;
			var ambig		:Boolean	= false;
			var exact		:Boolean	= false;
			
			longopt_handled	= true;
			longind			= -1;
			
			var nameend	:int = nextchar.indexOf('=');
			if(nameend == -1)
				nameend = nextchar.length;
				
			// Test all lnog options for either exact match or abbreviated matches
			for (var i:int = 0; i < long_options.length; i++)
			{
				if(long_options[i].name.substr(0,nameend) == nextchar.substring(0,nameend))
				{
					if(long_options[i].name == nextchar.substring(0,nameend))
					{
						// Exact match found
						pfound = long_options[i];
						longind = i;
						exact = true;
						break;
					}
					else if(pfound == null)
					{
						// First nonexact match found
						pfound = long_options[i];
						longind = i;
					}
					else
					{
						// Second or later nonexact match found
						ambig = true;
					}
				}
			}
			
			// Push an error if the option specified was ambiguous
			if(ambig && !exact)
			{
				if(opterr)
				{
					GetoptError.push('ambigious',progname,argv[optind]);
				}
				nextchar = '';
				optopt = '0';
				++optind;
				
				return '?';
			}
			
			if(pfound != null)
			{
				++optind;
				
				if(nameend != nextchar.length)
				{
					if(pfound.hasArg != LongOpt.NO_ARGUMENT)
					{
						if(nextchar.substring(nameend).length > 1)
							optarg = nextchar.substring(nameend+1);
						else
							optarg = '';
					}
					else
					{
						if(opterr)
						{
							// -- option
							if(argv[optind - 1].substr(0,2) == '--')
							{
								GetoptError.push('arguments1',progname,pfound.name);
							}
							// +option or -option
							else
							{
								GetoptError.push('arguments2',progname,String(argv[optind-1]).charAt(0),pfound.name);
							}
						}
						nextchar = '';
						optopt = pfound.val;
						
						return '?'
					}
				}
				else if( pfound.hasArg == LongOpt.REQUIRED_ARGUMENT)
				{
					if(optind < argv.length)
					{
						optarg = argv[optind];
						++optind;
					}
					else
					{
						if(opterr)
						{
							GetoptError.push('requires',progname,argv[optind-1]);
						}
						nextchar = '';
						optopt = pfound.val;
						if(optstring.charAt(0) == ':')
							return ':';
						else
							return '?';
					}
				}
				nextchar = '';
				if(pfound.flag != null)
				{
					pfound.flag = '';
					pfound.flag += pfound.val;
					return '0';
				}
				return pfound.val;
			}
			longopt_handled = false;
			return '0';
		}
		
		/**
		 * This method returns a char that is the current option that has been
		 * parsed from the command line.  If the option takes an argument, then
		 * the internal variable 'optarg' is set which is a String representing
		 * the the value of the argument.  This value can be retrieved by the
		 * caller using the getOptarg() method.  If an invalid option is found,
		 * an error message is printed and a '?' is returned.  The name of the
		 * invalid option character can be retrieved by calling the getOptopt()
		 * method.  When there are no more options to be scanned, this method
		 * returns '-1'.  The index of first non-option element in argv can be
		 * retrieved with the getOptind() method.
		 *
		 * @return Various things as described above
		 */
		public function getopt():String
		{
			optarg = null;
			if(endparse == true)
				return '-1';
			if(nextchar == null || nextchar == '')
			{
				// If we have just processed some options following some non-options,
				//  exchange them so that the options come first.
				if(last_nonopt > optind)
					last_nonopt = optind;
				if(first_nonopt > optind)
					first_nonopt = optind;
				
				if(ordering == PERMUTE)
				{
					// If we have just processed some options following some non-options,
					// exchange them so that the options come first.
					if(first_nonopt != last_nonopt && last_nonopt != optind)
						exchange(argv);
					else if(last_nonopt != optind)
						first_nonopt = optind;
					
					// Skip any additional non-options
					// and extend the range of non-options previously skipped.
					while(optind < argv.length && argv[optind] == '' || String(argv[optind]).charAt(0) != '-' || argv[optind] == '-')
					{
						optind++;
					}
					last_nonopt = optind;
				}
				
				// The special ARGV-element `--' means premature end of options.
				// Skip it like a null option,
				// then exchange with previous non-options as if it were an option,
				// then skip everything else like a non-option.
				if(optind != argv.length && argv[optind] == '--')
				{
					optind++;
					if(first_nonopt != last_nonopt && last_nonopt != optind)
						exchange(argv);
					else if(first_nonopt == last_nonopt)
						first_nonopt = optind;
					
					last_nonopt = argv.length;
					optind = argv.length;
				}
				
				// If we have done all the ARGV-elements, stop the scan
				// and back over any non-options that we skipped and permuted.
				if(optind == argv.length)
				{
					if(first_nonopt != last_nonopt)
						optind = first_nonopt;
					return '-1';
				}
				
				// If we have come to a non-option and did not permute it,
				// either stop the scan or describe it to the caller and pass it by.
				if(argv[optind] == '' || String(argv[optind]).charAt(0) != '-' || argv[optind] == '-')
				{
					if(ordering == REQUIRE_ORDER)
						return '-1';
						
					optarg = argv[optind++];
					return '1';
				}
				
				// We have found another option-ARGV-element.
				// Skip the initial punctuation.
				if(String(argv[optind]).substr(0,2) == '--')
					nextchar = String(argv[optind]).substring(2);
				else
					nextchar = String(argv[optind]).substring(1);
			}
			// Decode the current option-ARGV-element.

			/* Check whether the ARGV-element is a long option.

			   If long_only and the ARGV-element has the form "-f", where f is
			   a valid short option, don't consider it an abbreviated form of
			   a long option that starts with f.  Otherwise there would be no
			   way to give the -f short option.
               
			   On the other hand, if there's a long option "fubar" and
			   the ARGV-element is "-fu", do consider that an abbreviation of
			   the long option, just like "--fu", and not "-f" with arg "u".
               
			   This distinction seems to be the most useful approach.  */
			var c:String;
			if(long_options != null && String(argv[optind]).substr(0,2) == '--' 
				|| (long_only && String(argv[optind]).length > 2) ||
				optstring.indexOf(String(argv[optind]).charAt(1)) == -1)
			{
				c = checkLongOption();
				if(longopt_handled)
					return c;
					
				// Can't find it as a long option.  If this is not getopt_long_only,
				// or the option starts with '--' or is not a valid short
				// option, then it's an error.
				// Otherwise interpret it as a short option.
				if(!long_only || String(argv[optind]).substr(0,2) == '--')
					GetoptError.push('unrecognized',progname,nextchar);
				else
					GetoptError.push('unrecognized2',progname,String(argv[optind]).charAt(0),nextchar);
				
				nextchar = '';
				++optind;
				optopt = '0';
				
				return '?';
				
			}
			
			// Look at and handle the next short option-character
			c = nextchar.charAt(0);
			if(nextchar.length > 1)
				nextchar = nextchar.substring(1);
			else
				nextchar = '';
				
			var temp:String = null;
			if(optstring.indexOf(c) != -1)
				temp = optstring.substring(optstring.indexOf(c));
			
			if(nextchar == '')
				++optind;
				
			if(temp == null || c == ':')
			{
				if(opterr)
				{
					if(posixly_correct)
					{
						GetoptError.push('illegal',progname,c);
					}
					else
					{
						GetoptError.push('invalid',progname,c);
					}
				}
				
				optopt = c;
				return '?';
			}
			// Convenience. Treat POSIX -W foo same as long option --foo
			if(temp.charAt(0) == 'W' && temp.length > 1 && temp.charAt(1) == ';')
			{
				if(!nextchar == '')
				{
					optarg = nextchar;
				}
				// No further cars in this argv element and no more argv elements
				else if(optind == argv.length)
				{
					if(opterr)
					{
						GetoptError.push('requires2',progname,c);
					}
					optopt = c;
					if(optstring.charAt(0) == ':')
						return ':';
					else
						return '?';
				}
				else
				{
					// We already incremented `optind' once;
					// increment it again when taking next ARGV-elt as argument.
					nextchar = argv[optind];
					optarg = argv[optind];
				}
				
				c = checkLongOption();
				
				if(longopt_handled)
					return c;
				else
				{
					// Let the application handle it
					nextchar = null;
					++optind;
					return 'W';
				}
			}
			
			if(temp.length > 1 && temp.charAt(1) == ':')
			{
				if(temp.length > 2 && temp.charAt(2) == ':')
				{
					// This is an option that accepts and argument optionally
					if(!nextchar == '')
					{
						optarg = nextchar;
						++optind;
					}
					else
					{
						optarg = null;
					}
					nextchar = null;
				}
				else
				{
					if(!nextchar == '')
					{
						optarg = nextchar;
						++optind;
					}
					else if(optind == argv.length)
					{
						if(opterr)
						{
							GetoptError.push('requires2',progname,c);
						}
						optopt = c;
						if(optstring.charAt(0) == ':')
							return ':';
						else
							return '?';
					}
					else
					{
						optarg = argv[optind];
						++optind;
						
						// Ok, here's an obscure Posix case.  If we have o:, and
						// we get -o -- foo, then we're supposed to skip the --,
						// end parsing of options, and make foo an operand to -o.
						// Only do this in Posix mode.
						// Ignored by default as AS3 port.
						if(posixly_correct && optarg == '--')
						{
							// If end of argv, error out
							if(optind == argv.length)
							{
								if(opterr)
								{
									GetoptError.push('requires2',progname,c);
								}
								optopt = c;
								if(optstring.charAt(0) == ':')
									return ':';
								else
									return '?';
							}
							
							// Set new optarg and set to end
			                // Don't permute as we do on -- up above since we
			                // know we aren't in permute mode because of Posix.
							optarg = argv[optind];
							++optind;
							first_nonopt = optind;
							last_nonopt = argv.length;
							endparse = true;
						}
					}
					
					nextchar = null;
					
				}
			}
			
			return c;
			
		}
		
		/**
		 *	String representation of the Getopt class
		 *	@return String
		 */
		public function toString():String
		{
			return '[Getopt]';
		}
		
	}

}

/**
 * Error Message handling
 * Reference: Java Port by Aaron M. Renn uses
 * external files for localized error messages.
 * This is removed for the AS3 Port since no
 * external files should be needed in order to
 * compile Getopt.as. May be corrected in future 
 * versions or forks.
 * 
 * @langversion ActionScript 3
 * @playerversion Flash 9.0.0
 * 
 * @author Carl Calderon (carl.calderon@gmail.com)
 */
internal class GetoptError
{
	/**
	 * The localized strings (EN)
	 */
	private static const messages_en:Object = 
	{
		ambigious:'{0}: option "{1}" is ambigious',
		arguments1:'{0}: option "--{1}" doesn\'t allow an argument',
		arguments2:'{0}: option "{1}{2}" doesn\'t allow and argument',
		requires:'{0}: option "{1}" requires and argument',
		unrecognized:'{0}: unrecognized option "--{1}"',
		unrecognized2:'{0}: unrecognized option "--{1}{2}"',
		illegal:'{0}: illegal option -- {1}',
		invalid:'{0}: invalid option -- {1}',
		requires2:'{0}: option requires an argument -- {1}',
		invalidValue:'Invalid value {0} for parameter "hasArg"',
		invalidError:'Invalid error message "{0}"'
	}
	
	/**
	 * AS3 Equivalent of System.err.#println
	 * @param id error message id
	 */
	public static function push(id:String,...args):void
	{
		var msg:String = messages_en[id];
		if(!msg) trace(msg['invalidError']);
		else
		{
			for (var i:int = 0; i < args.length; i++)
				msg = msg.split('{'+i+'}').join(args[i]);
			trace(msg);
		}
	}
	
	/**
	 * @constructor ignored. kept for FlexPMD validation.
	 */
	public function GetoptError(){ super(); /* for FlexPMD */ }

}