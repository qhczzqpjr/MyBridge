#SingleInstance


/********************
	npm
*******************/


;~ npm config set proxy=proxy.citicorp.com:8080
;~ npm config set https-proxy=proxy.citicorp.com:8080
;~ npm install -g @angular/cli
;~ ng new my-first-app
;~ ng serve
;~ ng generate component servers


npm help
npm help-search update ;web search by keyword "update"

;Package.json ;manage dep
npm init ;in folder
npm init --year ;without questions
npm config set init-author-name "Thomas Zhu"
npm config set init-license "MIT"
npm config get init-author-name ;get
npm config delete init-license ;delete

npm install -h ;ways of usage
npm install <package> ;latest version
npm install <package> --save ; dep
npm install <package> --save-dev ; dev-dep
npm uninstall <package> --save ;remve dep

npm install <package> -g ; 
npm list ;list
npm list -depth 1 ;
npm list --global true --depth 0 ;root global AppData/Roaming/npm/node_modules

npm install <package@version> ; specific version
;&version latest version
;~version, latest feature
;* latest one
npm update ;
npm update npm@latest -g ; install npm 

npm prune ; rmeove extraneous

npm i ;
npm un ;
npm i <package> -S ;
npm i <package> -D ;
;docs.npmjs.com/misc/config

npm config set proxy http://proxy.citicorp.com:8080
npm config set https-proxy http://proxy.citicorp.com:8080
