import os,osproc , json

proc getJsonValue(node : JsonNode , key : string) : string =
    if node.hasKey(key): return node[key].getStr
    return ""

proc createMKDoc(path : string) =
    var
        (dir , name , _) = path.splitFile
        p = startProcess("/home/kutimoti/.nimble/bin/nim","",@["jsondoc",path])
    defer:
        p.close
    discard p.waitForExit()
    var
        mkdoc = "doc" & "/" & name & ".md"
        jsondoc = dir & "/" & name & ".json"
        f = open(mkdoc , FileMode.fmWrite)
        json = parseFile(jsondoc)
    defer:
        f.close

    
    f.writeLine "# " & name
    f.writeLine ""
    
    for ele in json:
        f.writeLine ("## " & getJsonValue(ele , "name"))
        f.writeLine ""
        f.writeLine getJsonValue(ele, "description")
        f.writeLine "```nim"
        f.writeLine getJsonValue(ele , "code")
        f.writeLine "```"
    var rm = startProcess("/bin/rm" , "" , @[jsondoc])
    defer:
        rm.close
    discard rm.waitForExit()
    
for f in walkFiles("./*/*.nim"):
    echo f
    createMKDoc(f)