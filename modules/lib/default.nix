{
  filterNull = list: builtins.filter (e: e != null) list;
  mkIfElseNull = cond: yes:
    if cond
    then yes
    else null;
}
