setlocal softtabstop=-1
setlocal shiftwidth=2
if executable('python3')
  setlocal equalprg=python3\ -m\ json.tool\ --indent=2
endif
