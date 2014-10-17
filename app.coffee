casper = require("casper").create dummy:0 #, verbose:true, logLevel:'info'

[userid,password] = casper.cli.args

URL = 'http://nano.korea.ncsoft.corp'

unless userid? and password?
	casper.echo '[userid] [password]'
	return casper.exit() 

casper
	.start URL    

casper.waitForUrl /Login/, ->
	@fill "form[name=loginForm]", LoginId:userid, UserPwd:password, false
	@evaluate ->
		CheckInputAndSubmit()	

casper.waitForSelector '.logout', ->
	@echo 'logged in'
	@evaluate ->
		popRequestDinner()

casper.then ->	
	@waitForPopup /popRequest/

casper.withPopup /popRequest/, ->		
	@click '#btnRequest'
	@capture 'result.png'
	@echo 'popup opened and screenshot captured into result.png'

casper.run()
