
" if exists("jsense_loaded")
    finish
endif
let g:jsense_loaded = 1

python << EOF

import vim

import subprocess
import json

def launchJsenseParser():
    # get our current cursor position
    cursor = vim.current.window.cursor
    row = cursor[0] - 1
    col = cursor[1]

    # get our buffer and save our current line
    buffer = vim.current.buffer
    line = buffer[row]

    # replace our cursor position with a sentinel and join the entire file
    buffer[row] = line[:col] + "{{cursor}}" + line[col:]
    joined = " ".join(buffer)

    # restore our line back to its original state
    buffer[row] = line

    # call our jsense parser
    subprocess.Popen([r"C:\Python27\pythonw.exe", r"C:\Users\JaredRu\Mesh\jsense.py", vim.eval("v:servername"), joined])

    # members = json.loads(res)
    # for name in members:
    #     member = members[name]
    #     completion = '{ "word": "' + name + '", "kind": "'

    #     if member["type"] == "function":
    #         completion += "f"

    #         if member["repr"]:
    #             completion += '", "info": "' + member["repr"].replace('"', r'\"')
    #     elif member["type"] == "object":
    #         completion += "m"
    #     else:
    #         print member["type"]

    #     completion += '" }'
    #     vim.command("call complete_add(" + completion + ")")

EOF

function! ShowJsensePopup()
    " python has the ability to launch subprocesses
    py launchJsenseParser()

    " clear our current completion list
    call complete(col("."), ["constructor", "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable", "toLocaleString", "toString", "valueOf"])

    if exists("jsense_used")
        return "\<C-P>\<C-P>"
    else
        return "\<C-P>"
    endif
endfunction

function! AddJsenseResults(jsense)
    let l:added = 0

    if pumvisible()
        exec "let l:props = " . a:jsense

        for l:prop in l:props
            if complete_add(l:prop) == 1
                let l:added = l:added + 1
            endif
        endfor
    endif

    return l:added
endfunction

inoremap . .<C-R>=ShowJsensePopup()<CR>

