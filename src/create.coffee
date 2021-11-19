fs = require 'fs'

TEMPLATES = [
  'bare'
  'tags'
]

exports.create = ({ name, template }) ->
  template ||= 'bare'
  if template in TEMPLATES
    { createProject } = require "./create/#{template}"
  else 
    console.error "No template named '#{template}'. Available templates: #{TEMPLATES}"
    process.exit 1

  dir = "#{CWD}/#{name}"
  if fs.existsSync dir
    console.error "#{dir} already exists."
    process.exit 1
  else
    console.log "Creating a new project inside of #{dir}"
    fs.mkdirSync dir

  createProject { name, dir }
