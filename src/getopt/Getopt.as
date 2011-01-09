package getopt
{
	import getopt.LongOpt;

	public class Getopt
	{
		
		protected static const REQUIRE_ORDER		:int	= 1;
		protected static const PERMUTE			:int	= 2;
		protected static const RETURN_IN_ORDER	:int	= 3;
		
		protected var optarg			:String;
		protected var opterr			:Boolean;
		protected var optind			:int 		= 0;
		protected var optopt			:*		= '?';
		protected var nextchar			:String;
		protected var optstring			:String;
		protected var long_options		:Array;
		protected var long_only			:Boolean;
		protected var longind			:int;
		protected var posixly_correct	:Boolean	= false;	// default as 'false'
		protected var longopt_handled	:Boolean;
		protected var first_nonopt		:int		= 1;
		protected var last_nonopt		:int		= 1;
		protected var argv				:Array;
		protected var ordering			:int;
		protected var progname			:String;
		
		private var endparse		:Boolean = false;
		
		public function Getopt(progname:String,argv:Array,optstring:String,long_options:Array,long_only:Boolean=false)
		{
			super(); // for FlexPMD
			//TODO use setOptstring (optimize?)
			if(optstring.length == 0)
				optstring = ' ';
			
			this.progname 		= progname;
			this.argv 			= argv;
			this.optstring 		= optstring;
			this.long_options 	= long_options;
			this.long_only 		= long_only;
			
			//TODO check for posixly_correct substitute in as3
			
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
				ordering = PERMUTE;
			}
		}
		
		public function setOptstring(optstring:String):void
		{
			if(optstring.length == 0)
				optstring = ' ';
			this.optstring = optstring;
		}
		
		public function getOptind():int
		{
			return optind;
		}
		
		public function setOptind(optind:int):void
		{
			this.optind = optind;
		}
		
		public function setArgv(argv:Array):void
		{
			this.argv = argv;
		}
		
		public function getOptarg():String
		{
			return optarg;
		}
		
		public function setOpterr(opterr:Boolean):void
		{
			this.opterr = opterr;
		}
		
		public function getOptopt():*
		{
			return optopt;
		}
		
		public function getLongind():int
		{
			return longind;
		}
		
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
					len = middle - bottom;
					for (i = 0; i < len; i++)
					{
						tem = argv[bottom+i];
						argv[bottom+i] = argv[top - (middle - bottom) + i];
						argv[top - (middle - bottom) + i] = tem;
					}
					top -= len;
				}
				else
				{
					len = top - middle;
					for (i = 0; i < len; i++)
					{
						tem = argv[bottom + i];
						argv[bottom + i] = argv[middle + i];
						argv[middle + i] = tem;
					}
					bottom += len;
				}
			}
			first_nonopt += optind - last_nonopt;
			last_nonopt   = optind;
		}
		
		//java: returns int
		protected function checkLongOption():* 
		{
			var pfound		:LongOpt 	= null;
			var ambig		:Boolean	= false;
			var exact		:Boolean	= false;
			
			longopt_handled	= true;
			longind			= -1;
			
			var nameend	:int = nextchar.indexOf('=');
			if(nameend == -1)
				nameend = nextchar.length;
				
			for (var i:int = 0; i < long_options.length; i++)
			{
				if(long_options[i].name.substr(0,nameend) == nextchar.substring(0,nameend))
				{
					if(long_options[i].name == nextchar.substring(0,nameend))
					{
						pfound = long_options[i];
						longind = i;
						exact = true;
						break;
					}
					else if(pfound == null)
					{
						pfound = long_options[i];
						longind = i;
					}
					else
					{
						ambig = true;
					}
				}
			}
			if(ambig && !exact)
			{
				if(opterr)
				{
					//TODO push error ('getopt.ambigious'). throw?
				}
				nextchar = '';
				optopt = 0;
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
							if(argv[optind - 1].substr(0,2) == '--')
							{
								//TODO push warning ('getopt.arguments1').
							}
							else
							{
								//TODO push warning ('getopt.arguments2')
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
							//TODO push error ('getopt.requires')
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
					//pfound.flag = ''; //java: pfound.flag.setLength(0);
					pfound.flag += pfound.val; //java: pfound.flag.append(pfound.val);
					return null;	//java: return 0;
				}
				return pfound.val;
			}
			longopt_handled = false;
			return null; //java: return 0;
		}
		
		public function getopt():*
		{
			optarg = null;
			if(endparse == true)
				return -1;
			if(nextchar == null || nextchar == '')
			{
				if(last_nonopt > optind)
					last_nonopt = optind;
				if(first_nonopt > optind)
					first_nonopt = optind;
				
				if(ordering == PERMUTE)
				{
					if(first_nonopt != last_nonopt && last_nonopt != optind)
						exchange(argv);
					else if(last_nonopt != optind)
						first_nonopt = optind;
						
					while(optind < argv.length && argv[optind] == '' || String(argv[optind]).charAt(0) != '-' || argv[optind] == '-')
					{
						optind++;
					}
					last_nonopt = optind;
				}
				
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
				
				if(optind == argv.length)
				{
					if(first_nonopt != last_nonopt)
						optind = first_nonopt;
					return -1;
				}
				
				if(argv[optind] == '' || String(argv[optind]).charAt(0) != '-' || argv[optind] == '-')
				{
					if(ordering == REQUIRE_ORDER)
						return -1;
						
					optarg = argv[optind++];
					return 1;
				}
				
				if(String(argv[optind]).substr(0,2) == '--')
					nextchar = String(argv[optind]).substring(2);
				else
					nextchar = String(argv[optind]).substring(1);
			}
			
			var c:*;
			if(long_options != null && String(argv[optind]).substr(0,2) == '--' 
				|| (long_only && String(argv[optind]).length > 2) ||
				optstring.indexOf(String(argv[optind]).charAt(1)) == -1)
			{
				c = checkLongOption();
				if(longopt_handled)
					return c;
					
				if(!long_only || String(argv[optind]).substr(0,2) == '--')
				{
					//TODO push warning ('getopt.unrecognized')
				}
				else
				{
					//TODO push warning ('getopt.unrecognized2')
				}
				
				nextchar = '';
				++optind;
				optopt = 0;
				
				return 0; //java: return '?';
				
			}
			
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
						//TODO push error ('getopt.illegal')
					}
					else
					{
						//TODO push error ('getopt.invalid')
					}
				}
				
				optopt = c;
				return 0; //java: return '?';
			}
			
			if(temp.charAt(0) == 'W' && temp.length > 1 && temp.charAt(1) == ';')
			{
				if(!nextchar == '')
				{
					optarg = nextchar;
				}
				else if(optind == argv.length)
				{
					if(opterr)
					{
						//TODO push error ('getopt.requires2')
					}
					optopt = c;
					if(optstring.charAt(0) == ':')
						return ':';
					else
						return '?';
				}
				else
				{
					nextchar = argv[optind];
					optarg = argv[optind];
				}
				
				c = checkLongOption();
				
				if(longopt_handled)
					return c;
				else
				{
					nextchar = null;
					++optind;
					return 'W';
				}
			}
			
			if(temp.length > 1 && temp.charAt(1) == ':')
			{
				if(temp.length > 2 && temp.charAt(2) == ':')
				{
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
							//TODO push error ('getopt.requires2')
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
						
						if(posixly_correct && optarg == '--')
						{
							if(optind == argv.length)
							{
								if(opterr)
								{
									//TODO push error('getopt.requires2')
								}
								optopt = c;
								if(optstring.charAt(0) == ':')
									return ':';
								else
									return '?';
							}
							
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
		
		public function toString():String
		{
			return '[Getopt]';
		}
		
	}

}