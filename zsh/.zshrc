
# (%) at the start of a variable expands all % escapes in the resulting words
#     in the same way as in prompts
#
# :-  in ${var:-word}, the ":-" returns "word" if "var" evaluates to null
#
# %x  for a prompt, evaluates to the name of the file containing the source code
#     currently being executed
source ${${(%):-%x}:h}/zshrc

