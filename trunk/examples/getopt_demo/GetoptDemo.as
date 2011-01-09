//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2011 
// 
////////////////////////////////////////////////////////////////////////////////

package
{

	import flash.events.Event;
	import flash.display.Sprite;
	import getopt.Getopt;
	import getopt.LongOpt;

	/**
	 * Application entry point for as3getopt.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 * 
	 * @author John Doe
	 * @since 08.01.2011
	 */
	public class GetoptDemo extends Sprite
	{
	
		/**
		 * @constructor
		 */
		public function GetoptDemo()
		{
			super();
		
			//----------------------- argv
		
			// usually passed by Event.INVOKE at application start (Adobe AIR)
			// and where argv[0] would be the application name. argv[0] of
			// invoke would be ignored due to incomplete argument structure.
			var argv:Array = ['-c2','--outputdir','myoutput.txt','-h','--maximum'];
			
			//----------------------- long options ( --<myoption> )
		
			var longopts:Array = new Array(3);
			longopts[0] = new LongOpt("help", 		LongOpt.NO_ARGUMENT, 		null, 	'h');
		 	longopts[1] = new LongOpt("outputdir", 	LongOpt.REQUIRED_ARGUMENT, 	null, 	'o'); 
		 	longopts[2] = new LongOpt("maximum", 	LongOpt.OPTIONAL_ARGUMENT, 	'', 	2);
			
			//----------------------- getopt instance
			
			// Getopt [0] program name. If Adobe AIR this could be set to argv[0].
			// Getopt [1] command-line arguments.
			// Getopt [2] options string (structure of possible arguments).
			// Getopt [3] Long options.
			
			var g:Getopt = new Getopt('testprog',argv,'-:bc:do:hW;',longopts);
			g.setOpterr(false);	// We'll do our own error handling;
		
			//----------------------- start getopt loop
		
			// read the first opt
			var c:String = g.getopt();
			var arg:String;
			
			// loop though the opts
			while(c != Getopt.END_OF_ARGS)
			{
				switch(c)
				{
					case Getopt.LONG_OPTION:
						arg = g.getOptarg();
						trace('Got long option "'+longopts[g.getLongind()].name+'" with value "' + longopts[g.getLongind()].val + '" and argument "' + arg + '"')
						break;
					case Getopt.INVALID_ORDER:
						g.getOptarg()
						trace('I see you have return in order set and that a non-option argv element was' +
							  ' just found with value "' + arg + '"');
						break;
					case Getopt.LONG_GUESS:
						arg = g.getOptarg();
						trace('I know this but i pretend I didn\'t');
						trace('We picked option ' + longopts[g.getLongind()].name + ' with value ' + arg);
						break;
					case 'b':
						trace('You picked plain old option ' + c)
						break;
					case 'c':
					case 'd':
						arg = g.getOptarg();
						trace('You picked option "' + c + '" with argument ' + arg);
						break;
					case 'h':
						trace('I see you asked for help');
						break;
					case 'W':
						trace('Hmmm. You tried a -W with an incorrect long option name');
						break;
					case 'o':
						arg = g.getOptarg();
						trace('output dir set to: ' + arg); 
						break;
					case ':':
						trace('Doh! You need an argument for option ' + g.getOptopt());
						break;
					case '?':
						trace('The option "' + g.getOptopt() + '" is not valid');
						break;
					default:
						trace('getopt() returned ' + c);
						break;
				}
				c = g.getopt();
			}
			
		}
	
	}

}
