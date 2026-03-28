"TODO: convert to lua implementation and make it compatible with windows

"TAGS file setting
"auto loading tags and cscope.out
autocmd VimEnter,BufRead * call UpdateTagConnection()

nmap <silent> ffs :call JumpStack_DoJump('Cscope_Search', "s", expand("<cword>"))<cr>
nmap <silent> ffg :call Cscope_Search("g", expand("<cword>"))<cr>
nmap <silent> ffc :call JumpStack_DoJump('Cscope_Search', "c", expand("<cword>"))<cr>
nmap <silent> ffi :call JumpStack_DoJump('Cscope_Search', "i", expand("<cword>"))<cr>
nmap <silent> fff :call JumpStack_DoJump('Cscope_Search', "f", expand("<cword>"))<cr>
nmap <silent> fft :call JumpStack_DoJump('Cscope_Search', "t", expand("<cword>"))<cr>
nmap <silent> ffe :call JumpStack_DoJump('Cscope_Search', "e", expand("<cword>"))<cr>
nmap <silent> ffa :call JumpStack_DoJump('Cscope_Search', "a", expand("<cword>"))<cr>
nmap <silent> ffd :call JumpStack_DoJump('Cscope_Search', "d", expand("<cword>"))<cr>
vmap <silent> ffs "9y:call JumpStack_DoJump('Cscope_Search', "s", @9)<cr>
vmap <silent> ffg "9y:call Cscope_Search("g", @9)<cr>
vmap <silent> ffc "9y:call JumpStack_DoJump('Cscope_Search', "c", @9)<cr>
vmap <silent> ffi "9y:call JumpStack_DoJump('Cscope_Search', "i", @9)<cr>
vmap <silent> fff "9y:call JumpStack_DoJump('Cscope_Search', "f", @9)<cr>
vmap <silent> fft "9y:call JumpStack_DoJump('Cscope_Search', "t", @9)<cr>
vmap <silent> ffe "9y:call JumpStack_DoJump('Cscope_Search', "e", @9)<cr>
vmap <silent> ffa "9y:call JumpStack_DoJump('Cscope_Search', "a", @9)<cr>
vmap <silent> ffd "9y:call JumpStack_DoJump('Cscope_Search', "d", @9)<cr>
nmap <silent> ffrs :call JumpStack_DoJump('Cscope_Search', "s")<cr>
nmap <silent> ffrg :call Cscope_Search("g")<cr>
nmap <silent> ffrc :call JumpStack_DoJump('Cscope_Search', "c")<cr>
nmap <silent> ffri :call JumpStack_DoJump('Cscope_Search', "i")<cr>
nmap <silent> ffrf :call JumpStack_DoJump('Cscope_Search', "f")<cr>
nmap <silent> ffrt :call JumpStack_DoJump('Cscope_Search', "t")<cr>
nmap <silent> ffre :call JumpStack_DoJump('Cscope_Search', "e")<cr>
nmap <silent> ffra :call JumpStack_DoJump('Cscope_Search', "a")<cr>
nmap <silent> ffrd :call JumpStack_DoJump('Cscope_Search', "d")<cr>
func Cscope_Search(pat, ...)
  let input_pat = a:0 > 0 ? a:1 : input("> Find pattern input: ")
  if input_pat != '' && ['g', 's', 'c', 'i', 'f', 't', 'e', 'a', 'd']->count(a:pat)
    let cs_find = ''
    if a:pat == "g"
      "If the cursor is not in the valid edit window
      if JumpWinInvalid()
        let v:errmsg = "~^.^~ jump window is invalid!"
        echohl ErrorMsg | echo v:errmsg | echohl None
        return
      endif

      try
        if &shortmess !~# 'A'
          set shortmess+=A
          let shortmess_modified = 1
        endif
        let curidx= gettagstack().curidx
        "continue searching the tags file if no pattern is found in the cscope database
        " let cs_find = "Cs find g ".input_pat
        let cs_find = "Cstag ".input_pat
        exe cs_find
      catch /.*/
        let v:errmsg = v:exception
        echohl ErrorMsg | echo "Cscope_Search(\'g\', \'".input_pat."\'): ".v:errmsg | echohl None
      finally
        if curidx != gettagstack().curidx
          call JumpStack_UpdateStatus()
        endif
        if exists('shortmess_modified') && shortmess_modified == 1
          set shortmess-=A
        endif
      endtry
      return
    elseif a:pat == "s"
      let cs_find = "Cs find s ".input_pat
    elseif a:pat == "c"
      let cs_find = "Cs find c ".input_pat
    elseif a:pat == "i"
      let cs_find = "Cs find i ".input_pat
    elseif a:pat == "f"
      let cs_find = "Cs find f ".input_pat
    elseif a:pat == "t"
      let cs_find = "Cs find t ".input_pat
    elseif a:pat == "e"
      let cs_find = "Cs find e ".input_pat
    elseif a:pat == "a"
      let cs_find = "Cs find a ".input_pat
    elseif a:pat == "d"
      let cs_find = "Cs find d ".input_pat
    endif
    exe cs_find
    call JumpStack_SetHighLightPattern(input_pat)
  else
    if input_pat == ''
      let v:errmsg = "Pattern is null"
    else
      let v:errmsg = "Cscope_Search mode invalid"
    endif
    normal! :echo
  endif
endfunc

"VIM tags setting
let g:jumpstack_disable_default_tag_highlight = 0
" set <C-]> check &cst option, g<C-]> use default tags file, use g<LeftMouse> as an alternative to <C-LeftMouse> for some terminals
nn <silent> <C-]> :call Tag_Search(v:false)<CR>
nn <silent> g<C-]> :call Tag_Search(v:true)<CR>
nn <silent> <C-LeftMouse> <LeftMouse>:call Tag_Search(v:false)<CR>
nn <silent> g<LeftMouse> <LeftMouse>:call Tag_Search(v:false)<CR>
vn <silent> <C-]> "9y:call Tag_Search(v:false, @9)<CR>
vn <silent> g<C-]> "9y:call Tag_Search(v:true, @9)<CR>
vn <silent> <C-LeftMouse> "9y:call Tag_Search(v:false, @9)<CR>
vn <silent> g<LeftMouse> "9y:call Tag_Search(v:false, @9)<CR>
map <silent> <C-RightMouse> :<c-u>call JumpStack_GoBack()<cr>
map <silent> g<RightMouse> :<c-u>call JumpStack_GoBack()<cr>
map <silent> <C-t> :<c-u>call JumpStack_GoBack()<cr>
nn <silent> <C-l> :call JumpStack_Select()<cr>
nn <silent> <c-b> :call JumpStack_Previous()<cr>
nn <silent> <c-f> :call JumpStack_Next()<cr>

func Tag_Search(search_tag_only, ...)
  let input_pat = a:0 > 0 ? a:1 : expand("<cword>")
  let curidx= gettagstack().curidx

  if input_pat == ''
    let v:errmsg = "Search pattern is null"
    echohl ErrorMsg | echo v:errmsg | echohl None
    return
  endif

  try
    if &shortmess !~# 'A'
      set shortmess+=A
      let shortmess_modified = 1
    endif

    if a:search_tag_only || (exists('&cst') && !&cst)
      exe "tjump ".input_pat
    else
      exe "Cstag ".input_pat
      " call feedkeys("\<c-]>", "!nx")
    endif
  catch /.*/
    let v:errmsg = v:exception
    echohl ErrorMsg | echo "Tag_Search(): ".v:errmsg | echohl None
  finally
    if curidx != gettagstack().curidx
      call JumpStack_UpdateStatus()
    endif
    if exists('shortmess_modified') && shortmess_modified == 1
      set shortmess-=A
    endif
  endtry
endfunc


func GetPathParent(path)
  let parent = substitute(a:path, '[\/][^\/]\+[\/:]\?$', '', '')
  if parent == '' || parent !~ '[\/]'
    let parent .= '/'
  endif
  return parent
endfunc

func UpdateTagConnection()
  let tags_search_path = expand("%:p")
  let tags_search_path_list = []
  if !empty(tags_search_path)
    "Resolve invalid path, eg.: ../a/../.. , a not exists or no permission to access
    while !isdirectory(tags_search_path)
      let tmp = tags_search_path
      let tags_search_path = GetPathParent(tags_search_path)
      "check if a wrong path leads to an infinite loop
      if tmp ==# tags_search_path
        break
      endif
    endwhile
    "Convert path with .. to absolute path
    let tags_search_path = system("cd ".tags_search_path." && echo -n $PWD")
  endif
  "No Permission to loading directory"
  if empty(tags_search_path) || !isdirectory(tags_search_path)
    let tags_search_path = getcwd()
  endif
  let parent = tags_search_path
  "Not include root directory(/)
  while parent != "/"
    call add(tags_search_path_list, parent)
    let tmp = parent
    let parent = GetPathParent(parent)
    "check if a wrong path leads to an infinite loop
    if tmp ==# parent
      break
    endif
  endwhile
  if empty(tags_search_path_list)
    return
  endif
  let tags_ctags_list = []
  let tags_cscope_list = []
  for item in tags_search_path_list
    if filereadable(item."/tags")
      call add(tags_ctags_list, item."/tags")
    endif
    if filereadable(item."/cscope.out")
      call add(tags_cscope_list, item."/cscope.out")
    endif
  endfor
  for item in tags_ctags_list
    silent! exec "set tags+=".item
  endfor
  for item in tags_cscope_list
    silent! exec "Cs db add ".item."::@"
  endfor
endfunc

func UpdateTagFile()
  "If the cursor is not in the valid file window
  if JumpWinInvalid()
    echohl ErrorMsg | echo "~^.^~ Invalid file" | echohl None
    return
  endif

  let tag_connected_list = tagfiles()
  if !len(tag_connected_list)
    echohl ErrorMsg | echo "No TAG files found" | echohl None
  else
    let file_src = expand('%:p:h')
    for item in tag_connected_list
      let tag_scope=item[:-6]."/cscope.files"
      if filereadable(tag_scope) && len(system("grep \'".file_src."\' ".tag_scope))
        let tmp = getcwd()
        silent! exe "cd " . item[:-6]
        call system("tag -u")
        echo "[  update  ]  ".item[:-6]
        silent! exe "cd " .tmp
        silent! exe "cs reset"
      else
        echo "[non-update]  ".item[:-6]
      endif
    endfor
  endif
endfunc

let g:JumpDisableWinList = [
\ "aerial",
\ "neo-tree",
\ "__Tagbar__.*",
\ "__Tag_List__",
\ "NERD_tree_.*",
\ "ControlP",
\ "Source_Explorer"
\ ]

func JumpWinInvalid()
  for item in g:JumpDisableWinList
    if bufname("%") =~# item || &ft =~# item
      return -1
    endif
  endfor
  "Aslo filter the Quickfix/Locationlist window
  if &buftype ==# "quickfix"
    return -1
  endif
  return 0
endfunc

func JumpStack_CreateHighlights()
  hi JumpStack_HighLight_Red ctermfg=0 ctermbg=9 guifg=Black guibg=#FF7272
  hi JumpStack_HighLight_Cyan ctermfg=0 ctermbg=14 guifg=Black guibg=#8CCBEA
  hi JumpStack_HighLight_Green ctermfg=0 ctermbg=10 guifg=Black guibg=#A4E57E
  hi JumpStack_HighLight_Yellow ctermfg=0 ctermbg=11 guifg=Black guibg=#FFDB72
  hi JumpStack_HighLight_Magenta ctermfg=0 ctermbg=13 guifg=Black guibg=#FFB3FF
  hi link JumpStack_HighLight_Default JumpStack_HighLight_Magenta
  hi link JumpStack_HighLight_Tag JumpStack_HighLight_Magenta
endfunc
call JumpStack_CreateHighlights()
autocmd ColorScheme * call JumpStack_CreateHighlights()

func JumpStack_SetHighLightPattern(...)
  let input_pat = a:0 > 0 ? a:1 : expand('<cword>')
  if type(input_pat) != v:t_string
    echoerr "highlight pattern is invalid type"
    return
  else
    let t:jumpstack_hlpattern = input_pat
  endif
endfunc

func JumpStack_LocationTagActive(...)
  let winid = (a:0 > 0 && a:1 > 0) ? a:1 : win_getid()
  let locwinid = getloclist(winid, {'winid' : 0}).winid
  if locwinid == winid
    let winid = getloclist(locwinid, {'filewinid': 0}).filewinid
  endif
  let stack = gettagstack(winid)
  if (stack['length'] > 0 && stack['curidx'] > 1) "if have tag in stack
    let items = stack['items'][stack['curidx'] - 2]
    let from = items.from
    let tagname = items.tagname
    let loctitle = getloclist(winid, {'title' : 0}).title
    let locctx = getloclist(winid, {'context' : 0}).context
    if type(locctx) == v:t_dict && has_key(locctx, 'from') && type(locctx.from) == v:t_list
      let locfrom = locctx.from
      "the line number of the jump buffer stored in tagstack changes dynamically as the buffer is updated
      if len(locfrom) == 4 && len(from) == 4 && locfrom[0] ==# from[0] && locfrom[2:3] ==# from[2:3] &&
            \ loctitle ==# tagname
        return 1
      endif
    endif
  endif
  return 0
endfunc

func JumpStack_UpdateStatus(...)
  let highlight = 'JumpStack_HighLight_Default'
  let highlighttag = 'JumpStack_HighLight_Tag'
  let priority = 10
  let matchid = 1000
  let winid = (a:0 > 0 && a:1 > 0) ? a:1 : win_getid()
  let hlpattern = a:0 > 1 ? a:2 : ''
  let jumpsel = a:0 > 2 ? a:3 : v:false
  let locwinid = getloclist(winid, {'winid' : 0}).winid
  if locwinid == winid
    let winid = getloclist(locwinid, {'filewinid': 0}).filewinid
  endif
  if !empty(hlpattern) && &ignorecase && hlpattern !~# '\\\@<!\\C'
    let hlpattern = '\c'.hlpattern
  endif

  if exists('t:jumpstack_defclosed_locwin')
    for key in keys(t:jumpstack_defclosed_locwin)
      if !win_id2win(key)
        unlet t:jumpstack_defclosed_locwin[key]
      endif
    endfor
  endif

  if JumpStack_LocationTagActive(winid)
    if winid == win_getid() || locwinid == win_getid()
      if jumpsel
        "select first item, ignore none items or other errors
        silent! exe "normal :lopen\<cr>\<cr>"
      elseif exists('t:jumpstack_defclosed_locwin') && has_key(t:jumpstack_defclosed_locwin, winid) && t:jumpstack_defclosed_locwin[winid]
        lclose
      elseif !locwinid
        lopen
        call win_gotoid(winid)
      endif
    endif
    let locctx = getloclist(winid, {'context' : 0}).context
    if type(locctx) == v:t_dict && has_key(locctx, 'hlpattern') && type(locctx.hlpattern) == v:t_string
      let hlpattern = locctx.hlpattern
      if !empty(hlpattern) && &ignorecase && hlpattern !~# '\\\@<!\\C'
        let hlpattern = '\c'.hlpattern
      endif
    endif
  else
    if winid == win_getid() || locwinid == win_getid()
      lclose
    endif
    if !exists('g:jumpstack_disable_default_tag_highlight') || g:jumpstack_disable_default_tag_highlight == 0
      let stack = gettagstack(winid)
      if (stack['length'] > 0 && stack['curidx'] > 1) "if have tag in stack
        let highlight = highlighttag
        let tagname = stack['items'][stack['curidx'] - 2].tagname
        if empty(hlpattern) && tagname !=# 'JumpStack_UnknownString'
          let hlpattern = tagname
          "cscope tag use ignorecase, tag not use, so ???
          " if !empty(hlpattern) && &ignorecase && hlpattern !~# '\\\@<!\\C'
          "     let hlpattern = '\c'.hlpattern
          " endif
        endif
      endif
    endif
  endif

  silent! call matchdelete(matchid, winid)
  let locwinid = getloclist(winid, {'winid' : 0}).winid
  if locwinid
    silent! call matchdelete(matchid, locwinid)
    if JumpStack_LocationTagActive(winid)
      call matchadd(highlight, hlpattern, priority, matchid, {'window': locwinid})
    endif
  endif
  call matchadd(highlight, hlpattern, priority, matchid, {'window': winid})
endfunc

func JumpStack_Begin(...)
  if JumpWinInvalid()
    echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
    return
  endif
  "Store where we're jumping from before we jump.
  let tag = a:0 > 0 ? a:1 : 'JumpStack_UnknownString'
  let pos = [bufnr()] + getcurpos()[1:3]
  let winid = win_getid()
  let stack = gettagstack(winid)
  let t:jumpstack_tagidx = stack['curidx']
  let t:jumpstack_item = {'bufnr': pos[0], 'from': pos, 'tagname': tag}
  let t:jumpstack_winid = winid
  let t:jumpstack_qf_title = getqflist({'title' : 0}).title
  let t:jumpstack_qf_id = getqflist({'id' : 0}).id
  let t:jumpstack_loc_title = getloclist(0, {'title' : 0}).title
  let t:jumpstack_loc_id = getloclist(0, {'id' : 0}).id
  let t:jumpstack_qf_winid = getqflist({'winid' : 0}).winid
  let t:jumpstack_hlpattern = ''
  let v:errmsg = ''
  let t:jumpstack_done = 0
endfunc

func JumpStack_Done()
  "Not have tag item or has been written to the tag stack.
  if !exists('t:jumpstack_item') || !exists('t:jumpstack_done') || t:jumpstack_done == 1
    return
  endif
  "exclude tabpage switch
  let t:jumpstack_done = 1
  "Jump was successful, write previous location to tag stack.
  if JumpWinInvalid()
    let winid = t:jumpstack_winid
  else
    let winid = win_getid()
  endif
  let stack = gettagstack(winid)
  if t:jumpstack_qf_id != getqflist({'id' : 0}).id || t:jumpstack_qf_title !=# getqflist({'title' : 0}).title "assert tag match results in quickfix
    call win_gotoid(winid) "some plugin update quickfix without jump to the first item automatically, and it also caused the recent window access records to be lost
    if (stack['length'] > 0 && stack['curidx'] > t:jumpstack_tagidx && t:jumpstack_tagidx > 0) "assert tagstack has modified together with quickfix, pop out
      call settagstack(winid, {'curidx' : t:jumpstack_tagidx}, 't')
      let stack = gettagstack(winid)
    endif
    let qftitle = getqflist({'title' : 0}).title
    let t:jumpstack_item['tagname'] = qftitle
    let stack['items'] = [t:jumpstack_item]
    call settagstack(winid, stack, 't')
    "create locationlist if not exist, move results from quickfix to locationlist
    call setloclist(winid, getqflist())
    call setloclist(winid, [], 'r', {'title': qftitle, 'context': {'from': t:jumpstack_item['from'], 'hlpattern': t:jumpstack_hlpattern}})
    "restore quickfix window status
    if !t:jumpstack_qf_winid
      silent! cclose
    endif
    "clear quickfix
    call setqflist([], "r")
    silent! colder
  elseif winid == t:jumpstack_winid && (t:jumpstack_loc_id != getloclist(winid, {'id' : 0}).id || t:jumpstack_loc_title !=# getloclist(winid, {'title' : 0}).title) "assert tag match results in locationlist
    call win_gotoid(winid) "some plugin update quickfix without jump to the first item automatically, and it also caused the recent window access records to be lost
    if (stack['length'] > 0 && stack['curidx'] > t:jumpstack_tagidx && t:jumpstack_tagidx > 0) "assert tagstack has modified together with quickfix, pop out
      call settagstack(winid, {'curidx' : t:jumpstack_tagidx}, 't')
      let stack = gettagstack(winid)
    endif
    let loctitle = getloclist(winid, {'title' : 0}).title
    let t:jumpstack_item['tagname'] = loctitle
    let stack['items'] = [t:jumpstack_item]
    call settagstack(winid, stack, 't')
    "create locationlist if not exist
    call setloclist(winid, [], 'r', {'context': {'from': t:jumpstack_item['from'], 'hlpattern': t:jumpstack_hlpattern}})
  else
    let pos = [bufnr()] + getcurpos()[1:3]
    if t:jumpstack_item['from'] ==# pos && (v:errmsg != '' || v:exception != '')
      return
    endif
    if !empty(t:jumpstack_hlpattern) && t:jumpstack_item.tagname ==# 'JumpStack_UnknownString'
      if &ignorecase && t:jumpstack_hlpattern  !~# '\\\@<!\\C'
        let t:jumpstack_hlpattern = '\c'.t:jumpstack_hlpattern
      endif
      let t:jumpstack_item.tagname = t:jumpstack_hlpattern
    endif
    let stack['items'] = [t:jumpstack_item]
    call settagstack(winid, stack, 't')
  endif
  call JumpStack_UpdateStatus(winid, t:jumpstack_hlpattern, v:true)
endfunc

func JumpStack_DoJump(jumpmethod, ...)
  "If the cursor is not in the valid edit window
  if JumpWinInvalid()
    echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
    return
  endif

  call JumpStack_Begin()
  try
    if &shortmess !~# 'A'
      set shortmess+=A
      let shortmess_modified = 1
    endif
    if exists("*".a:jumpmethod)
      let Func = function(a:jumpmethod, a:000)
      call Func()
    else
      exe a:jumpmethod
    endif
  catch /.*/
    let v:errmsg = v:exception
    echohl ErrorMsg | echo "JumpStack_DoJump(\'".a:jumpmethod."\'): ".v:errmsg | echohl None
  finally
    call JumpStack_Done()
    if exists('shortmess_modified') && shortmess_modified == 1
      set shortmess-=A
    endif
  endtry
endfunc

func JumpStack_GoBack()
  "If the cursor is not in the valid edit window
  if JumpWinInvalid()
    echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
    return
  endif

  try
    if &shortmess !~# 'A'
      set shortmess+=A
      let shortmess_modified = 1
    endif

    let stack = gettagstack()
    silent pop
    if (stack['length'] > 0 && stack['curidx'] > 1) "assert if :pop success
      let popitems = stack['items'][stack['curidx'] - 2]
      let popfrom = popitems.from
      let poptagname = popitems.tagname
      let loctitle = getloclist(0, {'title' : 0}).title
      let locctx = getloclist(0, {'context' : 0}).context
      if type(locctx) == v:t_dict && has_key(locctx, 'from') && type(locctx.from) == v:t_list
        let locfrom = locctx.from
        "the line number of the jump buffer stored in tagstack changes dynamically as the buffer is updated
        if len(locfrom) == 4 && len(popfrom) == 4 &&
              \ locfrom[0] ==# popfrom[0] && locfrom[2:3] ==# popfrom[2:3] &&
              \ loctitle ==# poptagname
          let locidx = getloclist(0, {'nr' : 0}).nr
          if locidx < 2 "at location list stack bottom
            silent! lclose
            call setloclist(0, [], "f")
          else
            silent! lolder
          endif
        endif
      endif
      call JumpStack_UpdateStatus()
    endif
  catch /.*/
    let v:errmsg = v:exception
    echohl ErrorMsg | echo v:errmsg | echohl None
  finally
    if exists('shortmess_modified') && shortmess_modified == 1
      set shortmess-=A
    endif
  endtry
endfunc

func JumpStack_Select()
  "If the cursor is not in the valid edit window
  if JumpWinInvalid() && !JumpStack_LocationTagActive()
    echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
    return
  endif

  let stack = gettagstack()
  let winid = win_getid()

  if (!stack['length'] || stack['curidx'] < 2)
    echohl WarningMsg | echo "tag stack empty" | echohl None
    return
  endif

  try
    if JumpStack_LocationTagActive()
      let locwinid = getloclist(winid, {'winid' : 0}).winid
      if locwinid == winid
        let winid = getloclist(locwinid, {'filewinid': 0}).filewinid
      endif
      if !exists('t:jumpstack_defclosed_locwin')
        let t:jumpstack_defclosed_locwin = {}
      endif
      if locwinid
        let t:jumpstack_defclosed_locwin[winid] = v:true
      else
        let t:jumpstack_defclosed_locwin[winid] = v:false
      endif
      call JumpStack_UpdateStatus(winid)
    else
      ts
    endif
  catch /.*/
    let v:errmsg = v:exception
    echohl WarningMsg | echo v:errmsg | echohl None
  finally
    "tag stack may be modified
    call settagstack(winid, stack, 'r')
    call settagstack(winid, {'curidx' : stack['curidx']})
  endtry
endfunc

func JumpStack_Previous()
  "If the cursor is not in the valid edit window
  if JumpWinInvalid()
    echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
    return
  endif

  let stack = gettagstack()
  let winid = win_getid()

  if (!stack['length'] || stack['curidx'] < 2)
    echohl WarningMsg | echo "tag stack empty" | echohl None
    return
  endif

  try
    if JumpStack_LocationTagActive()
      lp
    else
      tp
      if (stack['items'][stack['curidx'] - 2].matchnr > 1) "update if :tp success
        let stack['items'][stack['curidx'] - 2].matchnr = stack['items'][stack['curidx'] - 2].matchnr - 1
      endif
    endif
  catch /.*/
    let v:errmsg = v:exception
    echohl WarningMsg | echo v:errmsg | echohl None
  finally
    "tag stack may be modified
    call settagstack(winid, stack, 'r')
    call settagstack(winid, {'curidx' : stack['curidx']})
  endtry
endfunc

func JumpStack_Next()
  "If the cursor is not in the valid edit window
  if JumpWinInvalid()
    echohl ErrorMsg | echo "~^.^~ jump window is invalid!" | echohl None
    return
  endif

  let stack = gettagstack()
  let winid = win_getid()

  if (!stack['length'] || stack['curidx'] < 2)
    echohl WarningMsg | echo "tag stack empty" | echohl None
    return
  endif

  try
    if JumpStack_LocationTagActive()
      lne
    else
      tn
      let stack['items'][stack['curidx'] - 2].matchnr = stack['items'][stack['curidx'] - 2].matchnr + 1 "update if :tn success
    endif
  catch /.*/
    let v:errmsg = v:exception
    echohl WarningMsg | echo v:errmsg | echohl None
  finally
    "tag stack may be modified
    call settagstack(winid, stack, 'r')
    call settagstack(winid, {'curidx' : stack['curidx']})
  endtry
endfunc

" Unused Now
" func LocationlistWinToggle()
"   if getloclist(0, {'winid' : 0}).winid
"     silent! lclose
"   else
"     silent! lopen
"     let locnum = getloclist(0, {'nr' : '$'}).nr
"     if !locnum
"       echohl WarningMsg | echo "Location List not exist!" | echohl None
"     endif
"   endif
" endfunc

" func QuickfixWinToggle()
"   if getqflist({'winid' : 0}).winid
"     silent! cclose
"   else
"     silent! bo copen
"   endif
" endfunc

" func QuickfixWinCleanClose()
"   call setqflist([], "f")
"   silent! cclose
" endfunc
