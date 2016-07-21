var module_name='js_format';
var module_ver='1.0';

function Init()
{
  menuName = "&Format Code";
  addMenuItem("&Beautify JS", menuName, "beautifyJS");
}

/*
  Original:
    Lorin Thwaits: http://geekswithblogs.net/lorint/
    Lorin's simple code beautifier for C++, C#, Java, and Javascript
    http://geekswithblogs.net/lorint/archive/2006/07/17/85455.aspx

  Adaption des CS-Codes für JScript/PSPad:
  - Nachbildung String-Builder (minimal)
  - Nachbildung einiger Namespace-/Klassenfunktionen
  - Anpassung String.ToString()
  - Variablendeklarationen angepasst

  Changes Sat, 16 February 2008 by Jan Schreiber:
  Added comment awareness
*/

function beautifyJS()
{
  var System =
  {
    Text :
    {
      StringBuilder : function(len)
      {
        this.arr=[];
        this.length = 0;
        this.Append = function(x)
        {
          this.arr.push(x);
          this.length += x.length;  
        }
        this.ToString = this.toString = function ()
        {
          return this.arr.join('');
        }
        this.set = function(text)
        {
          this.arr = [text.toString()];
          this.length = this.arr[0].length;  
        }
        this.cut = function(d)
        {
          if(d < 0) this.set(this.toString().substr(0,this.length+d));
        }
      }
    }
  };

  String.prototype.ToString = String.prototype.toString;

  String.Empty = '';

/* ---------------------------------------------------------------------------------*/

  var e = newEditor(); //New PSPad editor object
  e.assignActiveEditor();
  var selText = true;

  var source =
  {
    Text: e.selText()
  }

  if (!source.Text)
  {
    selText = false;
    source.Text = e.Text();
  }

  var indentWith =
  {
    SelectedValue:'s' // Spaces = 's', Tabs = 't'  
  };
  
/* ---------------------------------------------------------------------------------*/

  var StringType =
  {
    None:0,
    SingleQuote:1,
    DoubleQuote:2,
    Comment:3,
    MultilineComment:4
  } 

  var level=0;
  var inString=StringType.None;
  var nextChar=String.Empty;
  var indentChar;

  function spaces(level)
  {
    return (new Array(level+1)).join(indentChar);
  }

  function removeWhitespaceAtEnd(dst)
  {
    dst.set(dst.toString().replace(/[ \t]*$/g,''));
  }

  function endsWith(dst,check)
  {
    var a = dst.toString();
    var p = a.length - check.length;
    dst.set(a);
    return a.substr(p) == check;
  }

/* ---------------------------------------------------------------------------------*/

  // Set the character to be used for indentation
  indentChar=(indentWith.SelectedValue=="s"?'  ':'\t');
  var whiteSpace=false,   // Is this character whitespace?
    whiteSpacePrev=false, // Was the previous character some kind of whitespace?
    newLine=false,        // Are we starting a new line?
    nextEndLine=false,
    inForLoop=false;
  var srcLen=source.Text.Length;
  // Allocate a StringBuilder that's 125% of the size of the original
  var dst=new System.Text.StringBuilder(srcLen+(srcLen>>2));
  var prevChar=String.Empty;    // Previous character

  // Go through each input character one by one
  var stl = source.Text.length;
  for(var ich = 0; ich < stl; ich++)
  {
    var ch = source.Text.charAt(ich);

    if(nextEndLine)     // If we just had a closing curly brace "}" but this next one is a semicolon, defer the newline to the semicolon.
    {
      if(ch!=';' && ch!=',')
        dst.Append("\r\n"+spaces(level));
      nextEndLine=false;
    }
    whiteSpacePrev=whiteSpace;
    whiteSpace=false;
    nextChar=ch.ToString(); // This will be the actual string emitted, which may end up being blank.
    switch(ch)
    {
      // Any kind of whitespace
      case ' ':
      case '\t':
      case '\r':
      case '\n':
        if(inString==StringType.Comment && ch=="\n")
        {
          if(!endsWith(dst,"\r\n"))   // Add a carriage return if we don't have one already
            dst.Append("\r\n");
          dst.Append(spaces(level));
          newLine=true;
          whiteSpace=true;
          inString=StringType.None;
          break;
        }
        if(inString==StringType.MultilineComment && ch=="\n")
        {
          if(!endsWith(dst,"\r\n"))   // Add a carriage return if we don't have one already
            dst.Append("\r\n");
          dst.Append(spaces(level));
          newLine=true;
          whiteSpace=true;
          break;
        }
        if(!newLine)      // If it's a new line then we'll already be indenting up to the proper place, so forget about any whitespace
          whiteSpace=true;
        nextChar=String.Empty;    // We'll emit the whitespace appropriately below
        break;
        // Something to indent
      case '{':
        if(inString==StringType.None)
        {
          // Back up and take any extra spaces off the end of dst
          // (This has the same effect as:  dst=dst.TrimEnd(' ','\t'); )
          removeWhitespaceAtEnd(dst);

          newLine=true;
          dst.Append("\r\n"+spaces(level)+"{\r\n");
          nextChar=String.Empty;
          dst.Append(spaces(++level));
        }
        break;
        // Something to de-indent
      case '}':
        if(inString==StringType.None)
        {
          newLine=true;
          if(--level<0)
          {
            dst.Append("\r\n<<< Bogus level >>>\r\n");
            level=0;
          }
          // Take any extra spaces off the end of dst
          removeWhitespaceAtEnd(dst);     // Was:  dst=dst.TrimEnd(' ','\t');
          if(!endsWith(dst,"\r\n"))   // Add a carriage return if we don't have one already
            dst.Append("\r\n");
          dst.Append(spaces(level)+"}");
          nextEndLine=true;     // Emit this before the next character unless it's a function definition: "\r\n"+spaces(level);
          nextChar=String.Empty;
        }
        break;
        // New statement
      case ';':
        if(inString==StringType.None)   // If we're in a string then this has no bearing on statements, so just emit the semicolon
        {
          nextChar=String.Empty;    // We'll emit on our own as we see fit
          if(endsWith(dst,"\r\n"))  // Take off any stray carriage returns
            dst.cut(-2); // dst.Length-=2;
            
          dst.Append(";");
          if(!inForLoop)
            dst.Append("\r\n"+spaces(level));   // New statement, so semicolon and carriage return, plus cue up appropriately for the next statement
          newLine=true;
        }
        break;
      case ',':
        if(inString==StringType.None && prevChar=="}")
        {
          nextChar=String.Empty;    // We'll emit on our own as we see fit
          if(endsWith(dst,"\r\n"))  // Take off any stray carriage returns
            dst.cut(-2); // dst.Length-=2;
            
          dst.Append(",");
          dst.Append("\r\n"+spaces(level));
          newLine=true;
        }
        break;
      // String toggle
      case '\'':
        if(inString!=StringType.Comment &&
          inString!=StringType.DoubleQuote &&   // Is it just a tick inside a double quoted string?
          prevChar!="\\")                       // Or is it an escaped single-quote?  Then don't get fooled!
          inString=(inString==StringType.None? StringType.SingleQuote:StringType.None);
        break;
      case '\"':
        if(inString!=StringType.Comment &&
          inString!=StringType.SingleQuote &&   // Is it just a quote inside a single quoted string?
          prevChar!="\\")                       // Is it an escaped double-quote?  Then don't get fooled!
          inString=(inString==StringType.None? StringType.DoubleQuote:StringType.None);
        break;
      case '(':
        // See if this is a for loop, in which case the next two semicolons are moot
        if(endsWith(dst,"for"))
          inForLoop=true;
        break;
      case ')':
        inForLoop=false;    // By default switch off the FOR loop analysis at any closing curly brace.
        break;
      // Comment toggle
      case '\/':
        if(prevChar=="\/" && inString==StringType.None)
        {
          inString=StringType.Comment;
        }
        if(prevChar=="*" && inString==StringType.MultilineComment)
        {
          inString=StringType.None;
          dst.Append("\/\r\n"+spaces(level));
          newLine=true;
          whiteSpace=true;
        }
        break;
      case '*':
        if(prevChar=="\/" && inString==StringType.None)
        {
          inString=StringType.MultilineComment;
        }
    }

    if(!whiteSpace)           // Emitting something real here?
    {
      prevChar=ch.ToString();   // Save this for the next go-'round
      if(whiteSpacePrev)
      {
        if(!newLine)            // If this is in the middle of the line and we had some whitespace, we need to add at least one space
          dst.Append(" ");
        whiteSpace=false;     // This way next iteration of the loop the whiteSpacePrev will get set false
      }
      if(nextChar!=String.Empty)    // If we have something to emit, do that, and also it must not be a new line.
      {
        dst.Append(nextChar);
        newLine=false;
      }
    }

  }   // For loop

  if(selText)
    e.selText(dst.ToString());
  else
    e.Text(dst.ToString());
}