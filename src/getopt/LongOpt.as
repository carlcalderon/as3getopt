package getopt
{
	
	/**
	 * LongOpt definition of GNU getopt port. Based on Java port
	 * by Aaron M. Renn.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0 
	 * 
	 * @author Carl Calderon (carl.calderon[at]gmail.com)
	 * @version 1.0.0
	 * 
	 * @see Getopt
	 */
	public class LongOpt
	{
		/**
		 * Constant value used for the "has_arg" constructor argument.  This
		 * value indicates that the option takes no argument.
		 */
		public static const NO_ARGUMENT			:int = 0;
		/** 
		 * Constant value used for the "has_arg" constructor argument.  This
		 * value indicates that the option takes an argument that is required.
		 */
		public static const REQUIRED_ARGUMENT	:int = 1;
		/**
		 * Constant value used for the "has_arg" constructor argument.  This
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
		protected var _flag		:String;
		/**
		 * The value to store in "flag" if flag is not null, otherwise the
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
		 *	@return String
		 */
		public function getName():String { return name; }
		public function get name():String
		{
			return _name;
		}
		
		/**
		 *	Older implementation of #hasArg
		 *	@return int
		 */
		public function getHasArg():int { return hasArg; }
		public function get hasArg():int
		{
			return _hasArg;
		}
		
		/**
		 *	Older implementation of #flag
		 *	@return String
		 */
		public function getFlag():String { return flag; }
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
		 *	@return int
		 */
		public function getVal():* { return val; }
		public function get val():*
		{
			return _val;
		}
	
	}

}