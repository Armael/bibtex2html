(*
 * bibtex2html - A BibTeX to HTML translator
 * Copyright (C) 1997-2000 Jean-Christophe Filli�tre and Claude March�
 * 
 * This software is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * 
 * See the GNU General Public License version 2 for more details
 * (enclosed in the file GPL).
 *)

(*i $Id: copying.ml,v 1.7 2002-07-16 14:09:14 filliatr Exp $ i*)

(*s Copyright and licence information. *)

open Printf

let copying () =
  prerr_endline "
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2, as
published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License version 2 for more details
(enclosed in the file GPL).";
  flush stderr

let authors = match Sys.os_type with
  | "Win32" -> "Jean-Christophe Filli\131tre and Claude March\130"
  | _       -> "Jean-Christophe Filli�tre and Claude March�" (* iso latin 1 *)

let banner softname =
  if not !Options.quiet then begin
    eprintf "This is %s version %s, compiled on %s\n"
      softname Version.version Version.date;
    eprintf "Copyright (c) 1997-2001 %s\n" authors;
    eprintf "This is free software with ABSOLUTELY NO WARRANTY (use option --warranty)\n\n";
    flush stderr
  end


