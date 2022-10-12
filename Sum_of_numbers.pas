{$IFDEF WINDOWS}
     {$APPTYPE CONSOLE}
{$ENDIF}

uses
     {$IFDEF UNIX}
       {$IFDEF UseCThreads}
       cthreads,
         {$ENDIF}
       {Widestring manager needed for widestring support}
       cwstring,
       {$ENDIF}
       {$IFDEF WINDOWS}
       Windows, {for setconsoleoutputcp}
       {$ENDIF}
       Classes,
       math;

const
    MAXLEN=1001;
type 
    long=array[1..MAXLEN] of integer; 
var
    base_input,base_output,i,j,length1,length2,length11,length22,lenrez:integer;
    z1,z2,z3,k:boolean;
    a,b,a2,b2,rez:long;
    c,base1,base2:char;

procedure perevod(var a,a2:long;length1,base_input,base_output:integer;var length11:integer);
var i,j,t,m:integer;
begin
 length11:=MAXLEN;
 for i:=1 to length1 do
 begin
    a2[MAXLEN]:=a2[MAXLEN]+a[i]; {запишем число в обратном порядке}
    j:=MAXLEN;
    t:=0;
    while t=0 do
     begin
        a2[j-1]:=a2[j-1]+a2[j] div base_output;
        a2[j]:=a2[j] mod base_output;
        if a2[j-1]<base_output then
                if a2[length11-1]<base_output then t:=1
                                            else begin
                                                 j:=j-1;
                                                 if j<length11 then length11:=j;
                                                 end
                               else begin
                               j:=j-1;
                               if j<length11 then length11:=j;
                               end;
     end;
    if i<length1 then 
        begin
         for m:=1 to MAXLEN do a2[m]:=a2[m]*base_input;
         j:=MAXLEN;
         t:=0;
         while t=0 do
          begin
            a2[j-1]:=a2[j-1]+a2[j] div base_output;
            a2[j]:=a2[j] mod base_output;
            if a2[j-1]<base_output then
                if a2[length11-1]<base_output then t:=1
                                            else begin
                                                 j:=j-1;
                                                 if j<length11 then length11:=j;
                                                 end
                                else begin
                                     j:=j-1;
                                     if j<length11 then length11:=j;
                                     end
          end
         end
 end;
 if a2[length11-1]<>0 then length11:=length11-1  
end;

function maxi(var num_left:long; length1:integer; var num_right:long;length2:
                integer):boolean;
var i,t:integer;
begin
if length1<length2 then maxi:=true {true если первое число больше второго}
  else if length1>length2 then maxi:=false
     else begin
            t:=0;
            i:=length1;
            while (i<=MAXLEN) and (t=0) do
             begin
              if num_left[i]>num_right[i] then
                begin 
                    maxi:=true;
                    t:=1;
                end
               else if num_left[i]<num_right[i] then
                        begin 
                            maxi:=false;
                            t:=1;
                        end
                    else i:=i+1;
            end;
            if t=0 then maxi:=true;
          end;
end;             


procedure summa(var num_left:long;length1:integer;z1:boolean;var num_right:long;
                    length2:integer;z2:boolean;var rez:long;var lenrez:integer;
                    var z3:boolean; base_output:integer);
var 
 length,i,j,m:integer;
 k:boolean;
 t:long;
begin
z3:=true;
if ((z1=true) and (z2=true)) or ((z1=false) and (z2=false)) then
    begin
        if length1<=length2 then length:=length1
                            else length:=length2;
        for i:=MAXLEN downto length do
            begin
                rez[i]:=rez[i]+num_left[i]+num_right[i];
                rez[i-1]:=rez[i-1]+rez[i] div base_output;
                rez[i]:=rez[i] mod base_output;
                
                if i = length then
                begin
{                  write('NL: ');writeln(num_left[i]);
                    write('NR: ');writeln(num_right[i]);
                    write('Res: ');writeln(rez[i]);}
                end;
            end;
        if rez[length-1]<>0 then lenrez:=length-1
                            else lenrez:=length;
    end
    else 
        begin
         {первое число отрицательное и по модулю больше второго}
         if (maxi(num_left,length1,num_right,length2)=true)and(z1=false) then z3:=false;
         {второе число отрицательное и по модулю больше первого}
         if (maxi(num_left,length1,num_right,length2)=false)and(z2=false) then z3:=false;
         if maxi(num_left,length1,num_right,length2)=false then 
                    begin
                        t:=num_left;
                        num_left:=num_right;
                        num_right:=t;
                    end;
         k:=true;
         if length1<=length2 then length:=length1
                             else length:=length2;
         for i:=MAXLEN downto length do
            begin
            rez[i]:=rez[i]+num_left[i]-num_right[i];
            if rez[i]<0 then
            if num_left[i-1]-num_right[i-1]<>0 then
                    begin
                        rez[i-1]:=rez[i-1]-1;
                        rez[i]:=rez[i]+base_output
                    end
                     else begin
                          j:=i-2;
                          while k=true do
                            if num_left[j]-num_right[j]<>0 then 
                             begin
                                rez[j]:=rez[j]-1;
                                for m:=j+1 to i-1 do
                                rez[m]:=rez[m]+base_output-1;
                                rez[i]:=rez[i]+base_output;
                                k:=false;
                             end
                               else j:=j-1;
                          end;
          end;
         lenrez:=length;
         m:=length;
         k:=true;
         while (k=true) and (m<=MAXLEN) do
          if rez[m]=0 then 
            begin
                m:=m+1;
                lenrez:=lenrez+1;
            end
             else k:=false;
         if lenrez=MAXLEN+1 then 
            begin
                lenrez:=MAXLEN;
                z3:=true;
            end;
        end;
 if (z1=false) and (z2=false) then z3:=false
 end;


                 
{Основная  программа}
begin
 k:=true;
 base_input:=0; base_output:=0;
 write('Enter the number system for input numbers (from 2 to 36): ');
 while (not eoln) and (k=true) do
   begin
        read(base1);
        if (base1<'0') or (base1>'9') then 
                    begin
                        write('Incorrect number system');
                        k:=false;
                    end
                else base_input:=10 * base_input + ord(base1) - ord('0');
   end;
   
 if k=true then 
   if (base_input<2) or (base_input>36) then
                begin
                    write('Incorrect number system');
                    k:=false;
                end;
                
 
if k=true then 
begin
 readln;
 write('Enter the number system for output sum (from 2 to 36): ');
 while (not eoln) and (k=true) do
   begin
    read(base2);
    if (base2<'0') or (base2>'9') then 
                    begin
                        write('Incorrect number system');
                        k:=false;
                    end
                else base_output:=10 * base_output + ord(base2) - ord('0');
    end;
 
 if k=true then 
   if (base_output<2) or (base_output>36) then 
                                        begin
                                        write('Incorrect number system');
                                        k:=false;
                                        end;
end;
 
  {обнуление массивов}
 for i:=1 to MAXLEN do
    begin
        a[i]:=0;
        b[i]:=0;
        a2[i]:=0;
        b2[i]:=0;
        rez[i]:=0;
    end;

   {первое число}   
if k=true then 
 begin
 readln;
 z1:=true;
 i:=1;
 length1:=0;
 write('Enter 1st number in ', base_input, ' number system: ');
 read(c);
 if c='-' then z1:=false
    else begin
          if (c>='A') and (c<='Z') then a[1]:=ord(c)-ord('A')+10
                        else if (c>='0') and (c<='9') then 
                                                a[1]:=ord(c)-ord('0')
                            else begin
                                    k:=false;
                                    write('Incorrect number.')
                                 end;
          if base_input-a[1]<=0 then 
                    begin
                        k:=false;
                        write('Incorrect number.')
                    end;
          i:=2;
          length1:=1;
         end;
 
 while (not eoln) and (k=true) do
    begin
     read(c);
     if (c>='A') and (c<='Z') then a[i]:=ord(c)-ord('A')+10
                        else if (c>='0') and (c<='9') then 
                                                a[i]:=ord(c)-ord('0')
                            else begin
                                    k:=false;
                                    write('Incorrect number.')
                                 end;
     if (base_input-a[i]<=0) and (k=true) then 
            begin
                k:=false;
                write('Incorrect number.')
            end;
     if (i=1001) and (k=true) then 
        begin
            write('Number can have maximum 1000 digits.');
            k:=false
        end;
     i:=i+1;
     length1:=length1+1
    end;
    
 if (z1=false) and (a[1]=0) and (k=true) then 
    begin
        k:=false;
        write('Incorrect number.')
    end;

    {второе число}
if k=true then 
 begin
 perevod(a,a2,length1,base_input,base_output,length11);
 readln;
 z2:=true;
 length2:=0;
 i:=1;
 write('Enter 2nd number in ', base_input, ' number system: ');
 read(c);
 if c='-' then z2:=false
     else begin
          if (c>='A') and (c<='Z') then b[1]:=ord(c)-ord('A')+10
                        else if (c>='0') and (c<='9') then 
                                                b[1]:=ord(c)-ord('0')
                            else begin
                                    write('Incorrect number.');
                                    k:=false
                                 end;
         if base_input-b[1]<=0 then 
                    begin
                        k:=false;
                         write('Incorrect number.')
                    end;    
         i:=2;      
         length2:=1;
       end;
 
 while (not eoln) and (k=true) do
    begin
     read(c);
     if (c>='A') and (c<='Z') then b[i]:=ord(c)-ord('A')+10
                        else if (c>='0') and (c<='9') then 
                                                b[i]:=ord(c)-ord('0')
                            else begin
                                  k:=false;
                                  write('Incorrect number.')
                                 end;
     if (base_input-b[i]<=0) and (k=true) then 
            begin
             k:=false;
             write('Incorrect number.')
            end;
     if (i=1001) and (k=true) then 
      begin
      write('Number can have maximum 1000 digits.');
      k:=false
      end;
     i:=i+1;
     length2:=length2+1;
    end;
    
 if (z2=false) and (b[1]=0) and (k=true) then 
    begin
     k:=false;
     write('Incorrect number.')
    end;
 
 
 if k=true then 

	begin
	 readln;
	 perevod(b,b2,length2,base_input,base_output,length22);
	 summa(a2,length11,z1,b2,length22,z2,rez,lenrez,z3,base_output);
	 writeln('Sum in ',base_output,' number system is equal to ');
	 if z3=false then write('-');
	 for j:=lenrez to maxlen do
	  if rez[j]>9 then write (chr(rez[j]+55))
	       else write(rez[j])
	end;
{
    begin
        readln;
        perevod(b,b2,length2,base_input,base_output,length22);
        summa(a2,length11,z1,b2,length22,z2,rez,lenrez,z3,base_output);
        write('Sum in ',base_output,' number system is equal to ');
        if z3=false then write('-');
        for j:=lenrez to MAXLEN do
                    if rez[j]>9 then write (chr(rez[j]+55))
                                else write(rez[j])
    end;
}
    writeln();

end;
end;    
end.
