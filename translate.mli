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

(*i $Id: translate.mli,v 1.2 2001-10-15 07:28:17 filliatr Exp $ i*)

(*s Production of the HTML documents from the BibTeX bibliographies. *)

open Bibtex

(*s Translation options. *)

val nodoc : bool ref
val nokeys : bool ref
val file_suffix : string ref
val link_suffix : string ref
val raw_url : bool ref
val title : string ref
val title_spec : bool ref
val print_abstract : bool ref
val print_footer : bool ref
val multiple : bool ref
val both : bool ref
val user_footer : string ref
val bib_entries : bool ref
val input_file : string ref
val output_file : string ref
val use_label_name : bool ref
val table : bool ref

(*s Inserting links for some BibTeX fields. *)

val add_field : string -> unit
val add_named_field : string -> string -> unit

(*s Production of the HTML output. *)

val format_list :
  biblio ->
  (string option * (string option * string * Expand.entry) list) list ->
  KeySet.t option -> unit