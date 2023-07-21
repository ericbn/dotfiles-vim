function! ZshJoin()
  let v:errmsg = ""
  silent! s/\vif\s+(.*)\s*[;\n]+\s*then\n^\s*(.*)\s*\n^\s*fi/if \1 \2/
  if v:errmsg != ""
    silent! s/\vfor\s+(.{-})\s+in\s+(.*)\s*[;\n]+\s*do\n^\s*(.*)\s*\n^\s*done/for \1 (\2) \3/
  endif
  if v:errmsg != ""
    silent! s/\v(\S.*)\s*\n\s*(\S.*)\s*$/\1; \2/
  endif
endfunction

function! ZshSplit()
  let v:errmsg = ""
  silent! s/\v^(\s*)(.*)\s+\&\&\s+(.*)\s*$/\=submatch(1)."if ".submatch(2)."; then\r".submatch(1).repeat(" ", shiftwidth()).submatch(3)."\r".submatch(1)."fi"/
  if v:errmsg != ""
    silent! s/\v^(\s*)for\s+(.{-})\s+\((.{-})\)\s+(.*)\s*$/\=submatch(1)."for ".submatch(2)." in ".submatch(3)."; do\r".submatch(1).repeat(" ", shiftwidth()).submatch(4)."\r".submatch(1)."done"/
  endif
  if v:errmsg != ""
    silent! s/\v^(\s*)(.{-})\s*;\s*/\1\2\r\1/
  endif
endfunction

nnoremap <buffer> <leader>J :call ZshJoin()<CR>
nnoremap <buffer> <leader>S :call ZshSplit()<CR>
