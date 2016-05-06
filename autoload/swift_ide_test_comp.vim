function! swift_ide_test_comp#complete(findstart, base) abort
  if a:findstart == 1
    return getline('.')
  endif
  let content = getbufline('%', 1, '$')
  let line = line('.')-1
  let col  = col('.')

  let snip = matchstr(a:base, '\v\w+$')
  let content[line] = substitute(a:base, '\v\w+$', '', '') . "#^SEIFT_VIM_COMP_ANCHOR^#" . content[line]

  let tmpfile = tempname()
  call writefile(content, tmpfile)
  let outputs = systemlist('swift-ide-test -code-completion -source-filename ' . tmpfile . ' -code-completion-token=SEIFT_VIM_COMP_ANCHOR')
  call delete(tmpfile)

  let res = []
  for o in outputs
    let word = matchstr(o, '\v^[^ ]+\:\s+\zs\w+')
    echom word
    if word !~# '^' . snip
      continue
    endif
    let word = substitute(a:base, '\v\w+$', '', '') . word
    let abbr = matchstr(o, '\v^[^ ]+\:\s+\zs.+')
    call add(res, {"word": word, "abbr": abbr})
  endfor

  return res
endfunction
