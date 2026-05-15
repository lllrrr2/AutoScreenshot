program Project1;

// https://forum.lazarus.freepascal.org/index.php/topic,73973.msg581900.html#msg581900

uses htmlelements;

var
  s:string = '&quot;hello&quot; &apos;world&apos; !@#$#$%%^&amp;*()_+789456341?/&lt;&gt;,m';
begin
  writeln(s);
  s :=   UnescapeHtml(s);
  writeln(s);
  s:=EscapeHTML(s);
  writeln(s);
end.
                             
