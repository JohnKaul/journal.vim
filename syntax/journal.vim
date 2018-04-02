" Custom project task todo managment additions 
"
if exists('b:current_syntax')
	finish
endif

let b:current_syntax = 'journal'

" {{{
"  * [ ] Test Bug        #design   @jdoe  ^3 &2016-11-09        %done
"           ^              ^        ^     ^   ^                  ^
"           |              |        |     |   |                  |
"           |              |        |     |   |                  +----- Status
"           |              |        |     |   +------------------------ Date/Milestone
"           |              |        |     +---------------------------- Priority/Cost
"           |              |        +---------------------------------- Assignment
"           |              +------------------------------------------- Tag
"           +---------------------------------------------------------- Label

syntax match projDate           '&\d\d\.\d\d\.\d\d'

"" The following two lines establish the comments:
""  eg: >> This is a single line comment
""
""      >*
""        This is a multi line comment
""      *<
syntax region projTaskDoc matchgroup=Comment start=">>" skip="\\$" end="$" keepend contains=projDate,projTag,projStatus,projAssignment,projPriority,@Spell
syntax region projTaskDoc  matchgroup=Comment start=">\*" skip="\\$" end="\*<" keepend contains=projDate,projTag,projStatus,projAssignment,projPriority,@Spell fold extend

"" The following few lines establish the meta-data syntaxes.
syn region	projTag	start="s*\zs\(%:\|#\)" skip="\\$" end="\>" keepend contains=@Spell
syn region	projStatus start="s*\zs\(%:\|%\)" skip="\\$" end="\>" keepend contains=@Spell
syn region	projAssignment start="s*\zs\(%:\|@\)" skip="\\$" end="\>" keepend contains=@Spell
syn region	projPriority start="s*\zs\(%:\|\^\)" skip="\\$" end="\>" keepend contains=@Spell

"" Define some colors for everthing.
hi def link projDate         SpecialChar
hi def link projTaskDoc      Comment
hi def link projTag          Character
hi def link projAssignment   Type
hi def link projStatus       Include
hi def link projPriority     Operator
" }}}
" Set custom filetype syntax's

autocmd BufNewFile,BufRead,BufEnter *.journal set syntax=journal 
autocmd BufNewFile,BufRead,BufEnter *.journal filetype indent on
