" The following are some settings which will allow me to extend the VIMWIKI
" plugin and give me some added functionality to the list feature of vimwiki.
"
" The following (along with some syntax stuff) will give me agilepad type
" functionality. 
"
if exists('g:loaded_journal') && g:loaded_journal
  finish
endif
let g:loaded_journal = 1

let s:save_cpo = &cpo
set cpo&vim

function! CheckOffItem()                                 "{{{
        try
                if getline(".") =~ '\[-\]'
                        let hls=@/
                        s,\[-\],\[x\],
                        let @/=hls
                else
                        let hls=@/
                        s,\[x\],\[-\],
                        let @/=hls
                endif
        catch /^Vim(\a\+):E486:/
        endtry
endfunction "}}}

function! Todo(day, ...)  "{{{
  " This function will add a search function for the new TODO list syntax.
  " Taken from: [ http://ifacethoughts.net/2008/05/11/task-management-using-vim/ ]
  "
  " See also: [ vimwiki/plugin/sysntax/vimwiki.vim ] for the syntax rules of
  " the meta-data items. 
  
    " Doing the first separately to clear the location list
    " before adding the first entry.
    let _date = "&".strftime("%m.%d", localtime()+a:day*86400)

    exe "cd %:p:h"
    let path = fnamemodify(expand(getcwd()), ":p") . "*.journal"

    try
        exec "lvimgrep /" . _date ."/j " . path
    catch /^Vim(\a\+):E480:/
    endtry

    if a:0 > 0
        " These commands will add results to the location list.
        for offset in range(a:day+1, a:1)
            " Returns 0601 for 1st June.
            let _date = "&".strftime("%m.%d.", localtime()+offset*86400)
            try
                exec "lvimgrepadd /" . _date . "/j " . path
            catch /^Vim(\a\+):E480:/
            endtry
        endfor
    endif

    exec "lw"
endfunction "}}}

function! TodoTag(tag, ...) "{{{
  " TODO
  "     [-] filter out the DONE items.
  "
  " This function will add a search function for the new TODO list syntax.
  " Adopted (revised) from: [ http://ifacethoughts.net/2008/05/11/task-management-using-vim/ ]
  "
  " See also: [ vimwiki/plugin/sysntax/vimwiki.vim ] for the syntax rules of
  " the meta-data items. 

    " let path = VimwikiGet('path', a:idx)
    " return substitute(path, '[/\\]\+$', '', '').'*.wiki/'

    exe "cd %:p:h"
    let path=fnamemodify(expand(getcwd()), ":p") . "*.journal"

    try
        exec "lvimgrep /" . a:tag . "/j " . path
    catch /^Vim(\a\+):E480:/
    endtry

    if a:0 > 0
        " These commands will add results to the location list.
            try
                exec "lvimgrepadd /" . "/\<\%[[[]0[]]]" . a:tag . "\>" . "/j " . path
            catch /^Vim(\a\+):E480:/
            endtry
    endif

   exec "lw"
endfunction "}}}

function! GetCword()            "{{{
        let wordUnderCursor = expand("<cword>")
        " let currentLine   = getline(".")
        return wordUnderCursor
endfunction     "}}}

nmap <silent><buffer> <C-Space> <Plug>CheckOffItem
vmap <silent><buffer> <C-Space> <Plug>CheckOffItem

nmap <silent><buffer> <C-]> <Plug>ToDoSearch
vmap <silent><buffer> <C-]> <Plug>ToDoSearch

nnoremap <silent><script><buffer>
      \ <Plug>CheckOffItem :CheckOffItem<CR>

nnoremap <silent><script><buffer>
      \ <Plug>ToDoSearch :ToDoSearch<CR>

command! -buffer -range CheckOffItem call CheckOffItem()

command! -buffer -range ToDoSearch call TodoTag(GetCword())

command! Today :call Todo(0)
command! Tomorrow :call Todo(1)
command! Dayafter :call Todo(2)
command! Week :call Todo(0, 7)
command! Month :call Todo(0,31)
command! Past :call Todo(-60,0)
command! Started :call TodoTag("%started")
command! Pending :call TodoTag("%pending")
command! Waiting :call TodoTag("%waiting")
command! Hold :call TodoTag("%HOLD")
command! High :call TodoTag("\\^5")
command! Medium :call TodoTag("\\^3")
command! Low :call TodoTag("\\^1")
command! TODO :call TodoTag("\\[\\-\\]")
" Locate any line begining with "[-] " (a TODO item). 

" Restore cpo.
let &cpo = s:save_cpo
unlet s:save_cpo
