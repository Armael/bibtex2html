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

(* $Id: readbib.ml,v 1.8 2000-06-30 02:36:45 filliatr Exp $ *)

open Printf

(* [(read_entries_from_file f)] returns the BibTeX entries of the
   BibTeX file [f] (from standard input if [f=""]).  *)

let read_entries_from_file f =
  if not !Options.quiet then begin
    if f = "" then 
      eprintf "Reading from standard input...\n"
    else
      eprintf "Reading %s..." f; 
    flush stderr
  end;
  Bibtex_lexer.reset();
  let chan = if f = "" then stdin else open_in f in
  try
    let el =
      Bibtex_parser.command_list Bibtex_lexer.token (Lexing.from_channel chan)
    in
    if f <> "" then close_in chan;
    if not !Options.quiet then begin
      eprintf "ok (%d entries).\n" (Bibtex.size el); flush stderr
    end;
    el
  with
      Parsing.Parse_error | Failure "unterminated string" ->
	if f <> "" then close_in chan;
	eprintf "Parse error line %d.\n" !Bibtex_lexer.line;
	flush stderr;
	exit 1 
