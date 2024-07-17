require 'opal'
require 'opal-browser'
require 'glimmer-dsl-web'
require 'fileutils'

Opal.use_gem("opal-browser")
Opal.use_gem("glimmer-dsl-web")

builder = Opal::Builder.new
builder.build('glimmer-dsl-web')
builder.build("./script.js.rb")
FileUtils.mkdir_p "build"
File.binwrite "build/build.js", builder.to_s
