setlocal softtabstop=-1
setlocal shiftwidth=4
if executable('black')
  setlocal equalprg=black\ -q\ -
endif
