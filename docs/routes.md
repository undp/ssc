# Routes


### Valid (stateRef, viewState and filter)
/?stateRef=c69271d1446f
/#region/lac
/?viewState=list
/#region/lac?viewState=list&stateRef=c69271d1446f
/#region/lac?stateRef=c69271d1446f



## Route components
stateRef (param)  : stateRef=c69271d1446f
filter            : #region/lac
viewState (param) : viewState=map


## Pseudocode

```coffeescript
if valid stateRef
  if rebuild from stateRef is successful
    render
  else 
    try next method
else if valid filter
  if rebuild from filter is successful
    render
  else 
    try next method
else if valid viewState
  if rebuild from viewState is successful
    render
  else 
    set default values
    render
```