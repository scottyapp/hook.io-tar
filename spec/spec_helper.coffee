main = require '../lib/index'
fs = require "fs"

module.exports = 
  hook: null
  currentCb : null
  eatMe : 0
  sourceText1 : "Hello world, foo bar!"
  sourceText2 : "A lazy fox jumps!"
  sourceFile1 : "afile.txt"
  sourceFile2 : "anotherfile.txt"
  
  compressedFileSingle : "afile.txt.tar"
  compressedFileMultiple : "files.tar"
    
  setup: (cb) ->
      
    @hook = new main.Tar(name: 'tar')
    @hook.onAny (data) =>
      console.log "ANY #{@hook.event} EatMe: #{@eatMe} HasCurrentCb: #{@currentCb != null}"
      if @currentCb
        if @eatMe == 0
          @currentCb null,@hook.event, data
          @currentCb = null
        @eatMe = @eatMe - 1  
      
    @hook.start()
    cb null,@hook
    
  fixturePath: (fileName) ->
    "#{__dirname}/fixtures/#{fileName}"

  tmpPath: (fileName) ->
    "#{__dirname}/../tmp/#{fileName}"
  
  cleanTmpFiles: (fileNames) ->
    for file in fileNames
      try
        fs.unlinkSync @tmpPath(file)
      catch ignore
    
  # Invoke this in your topic and pass your callback.
  # The cb will be called with: null,event,data
  # we passing null for err as the first parameter to stay true to node.js
  # HookMeUp always eats the first message.
  hookMeUp: (cb) ->
    @currentCb = cb
    @eatMe = 1
