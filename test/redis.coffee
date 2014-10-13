path = require('path')
random = require('../lib/random_id')
testid = random()

# NOTE: database config will need adding to `argv`
argv = require('../lib/defaultargs.coffee')({data: path.join('/tmp', 'sfwtests', testid), root: path.join(__dirname, '..')})

try
  page = require('../../wiki-storage-redis/lib/redis.js')(argv)
catch e
  console.log "Not Testing redis integration: storage package not present"
  return
fs = require('fs')


testpage = {title: 'Asdf'}



describe 'redis', ->
  describe '#page.put()', ->
    it 'should save a page', (done) ->
      page.put('asdf', testpage, (e) ->
        if e then throw e
        done()
      )
  describe '#page.get()', ->
    it 'should get a page if it exists', (done) ->
      page.get('asdf', (e, got) ->
        if e then throw e
        got.title.should.equal 'Asdf'
        done()

      )
    it 'should copy a page from default if nonexistant in db', (done) ->
      page.get('welcome-visitors', (e, got) ->
        if e then throw e
        got.title.should.equal 'Welcome Visitors'
        done()
      )
    it 'should copy a page from plugins if nonexistant in db', (done) ->
      page.get('air-temperature', (e, got) ->
        if e then throw e
        got.title.should.equal 'Air Temperature'
        done()
      )
    it 'should create a page if it exists nowhere', (done) ->
      page.get(random(), (e, got) ->
        if e then throw e
        got.should.equal('Page not found')
        done()
      )
